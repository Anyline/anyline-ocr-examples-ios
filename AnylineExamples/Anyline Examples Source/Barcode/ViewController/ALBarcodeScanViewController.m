#import "ALBarcodeScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h" // for ALResultViewController
#import "ALBarcodeFormatHelper.h"
#import "ALBarcodeResultUtil.h"
#import "ALSelectionTable.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UISwitch+ALExamplesAdditions.h"
#import "ALConfigurationDialogViewController.h"
#import "ALBarcodeSettingsViewController.h"
#import "ALBarcodeBatchCountView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"

NSTimeInterval const kBarcodeTroubleScanningTimeoutTime = 15;

NSString * const kBarcodeScanVC_titleText = @"Barcode does not scan?";

NSString * const kBarcodeScanVC_messageText = @"By default not all barcodes are enabled for scanning, \
take a look at the settings to find out if your barcode is currently selected for scanning.";

NSString * const kBarcodeScanVC_configJSONFilename = @"sample_barcode_config";

NSString * const kBarcodeActionText = @"OK";

NSString * const kSingleSelection = @"Single";
NSString * const kMultiSelection = @"Multi";
NSString * const kBatchSelection = @"Batch";

typedef enum : NSUInteger {
    BarcodeSingleScanMode,
    BarcodeMultiScanMode,
    BarcodeBatchScanMode,
} BarcodeScanMode;


@interface ALBarcodeScanViewController () <ALScanPluginDelegate, ALScanViewPluginDelegate, ALBarcodeSettingsDelegate, ALConfigurationDialogViewControllerDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@property (nonatomic, readonly) ALScanViewPluginConfig *scanViewPluginConfigDefault;

@property (nonatomic, strong) ALScanResult *latestScanResult;

@property (nonatomic, strong) NSMutableArray<ALBarcode *> *latestUniqueBarcodeScanResult;

@property (nonatomic, strong) NSArray<ALBarcodeFormat *> *selectedBarcodeFormats;

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) NSTimer *fadeTimer;

@property (nonatomic, assign) BOOL isMultiBarcode;

@property (nullable, nonatomic, strong) NSTimer *troubleScanningTimeout;

@property (nullable, nonatomic, strong) ALBarcodeSettingsViewController *barcodeSettingsViewController;
@property (nonatomic, assign) BarcodeScanMode dialogIndexScanModeSelected;
@property (nonatomic, assign) BOOL isSingleManualScanEnabled;
@property (nonatomic, assign) BOOL isMultiManualScanEnabled;
@property (nonatomic, strong) UIButton *scanModeSelectionButton;
@property (nonatomic, strong) ALBarcodeBatchCountView *batchCountView;

+ (ALScanViewPluginConfig *)defaultScanViewPluginConfig;

+ (ALScanViewPlugin *)scanViewPluginWithBarcodeFormats:(NSArray<ALBarcodeFormat *> *)barcodeFormats
                                        isMultiBarcode:(BOOL)isMultiBarcode
                                                 error:(NSError * _Nullable * _Nullable)error;

@end


@implementation ALBarcodeScanViewController

- (void)dealloc {
    // NSLog(@"dealloc ALBarcodeScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Barcodes";
    self.controllerType = ALScanHistoryBarcode;
    self.isMultiManualScanEnabled = YES;
    self.dialogIndexScanModeSelected = BarcodeSingleScanMode;
    self.barcodeSettingsViewController = [[ALBarcodeSettingsViewController alloc] init];
    self.barcodeSettingsViewController.delegate = self;
    
    [self setupSettingsNavBarBtn];
    [self setupScanModeSelectionButton];
    [self setupBatchCountView];
    [self setupConfirmScanButton];
    
    NSArray<ALBarcodeFormat *> *selectedSymbologies = [ALBarcodeFormatHelper formatsForReadableNames:[NSUserDefaults AL_selectedSymbologiesForBarcode]];
    if (!selectedSymbologies || (selectedSymbologies.count < 1)) {
        selectedSymbologies = [self.barcodeSettingsViewController getDefaultFormatsForDefaultReadableNames];
    }
    _selectedBarcodeFormats = selectedSymbologies;

    // NOTE: we don't use the `self.* = ` notation here to avoid calling the reloadScanView each time
    // The values of these two properties are defined here and their corresponding values on the
    // config JSON file are ignored. Also, must give this property a value otherwise a crash will
    // ensue.
    _isMultiBarcode = NO;
    
    // or alternatively,
    //   _selectedBarcodeFormats = @[ <ALBarcodeFormat Constant>,... ];

    [self reloadScanView];

    [self setColors];
    // ACO - maybe no need for this.
    // [self setupResultLabel];

    // TODO: enable PDF417 in the core, if it is available (it's a flag in the old plugin)
    // TODO: replicate the existing "info" delegate calls
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanViewPlugin startWithError:nil];
    if (self.dialogIndexScanModeSelected == BarcodeSingleScanMode) {
        [self setScanButtonHidden:!_isSingleManualScanEnabled andEnable:NO];
    } else if (self.dialogIndexScanModeSelected == BarcodeMultiScanMode) {
        [self setScanButtonHidden:!_isMultiManualScanEnabled andEnable:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTroubleScanningTimeout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanViewPlugin stop];
    [self stopTroubleScanningTimeout];
    [self saveBarcodeSymbologies];
    // ACO do we still need this?
    // usleep(200000);
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
}

- (void)removeRepeatedResultsFromResultArray:(NSArray<ALBarcode *> *)scanResultArray {
   
    [self.latestUniqueBarcodeScanResult addObjectsFromArray:scanResultArray];
    
    __block NSMutableSet *uniqueTypeIDs = [NSMutableSet set];
    NSIndexSet *set = [self.latestUniqueBarcodeScanResult indexesOfObjectsPassingTest:^BOOL(ALBarcode *object, NSUInteger idx, BOOL *stop) {
        if([uniqueTypeIDs containsObject:object.value]) {
            return NO;
        } else {
            [uniqueTypeIDs addObject:object.value];
            return YES;
        }
    }];
    
    self.latestUniqueBarcodeScanResult = [self.latestUniqueBarcodeScanResult objectsAtIndexes:set].mutableCopy;
}

// MARK: - Getters and Setters

+ (ALScanViewPluginConfig *)defaultScanViewPluginConfig {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:kBarcodeScanVC_configJSONFilename
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    return [[ALScanViewPluginConfig alloc] initWithJSONDictionary:[configStr asJSONObject] error:nil];
}

- (void)setSelectedBarcodeFormats:(NSArray<ALBarcodeFormat *> *)selectedBarcodeFormats {
    [self.scanViewPlugin stop];
    _selectedBarcodeFormats = selectedBarcodeFormats;
    [self reloadScanView];
}

/// When a config is updated, a new ScanView is generated and installed, along with a
/// new ScanViewPlugin incorporating the user config choices (`_selectedBarcodeFormats` and
/// `_isMultiBarcode` ).
- (void)reloadScanView {

    NSError *error;
    ALScanViewPlugin *scanViewPlugin = [self.class scanViewPluginWithBarcodeFormats:self.selectedBarcodeFormats
                                                                     isMultiBarcode:self.isMultiBarcode
                                                                              error:&error];

    if ([self popWithAlertOnError:error]) {
        return;
    }

    scanViewPlugin.scanPlugin.delegate = self;
    scanViewPlugin.delegate = self;
    
    self.scanViewPlugin = scanViewPlugin;

    if (self.scanView) {
        [self.scanView setScanViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    } else {
        NSDictionary *configJSONDictionary = [[self configJSONStrWithFilename:kBarcodeScanVC_configJSONFilename]
                                              asJSONObject];
        ALScanViewConfig *scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:configJSONDictionary
                                                                                      error:nil];
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                           scanViewConfig:scanViewConfig
                                                    error:&error];

        if ([self popWithAlertOnError:error]) {
            return;
        }

        [self installScanView:self.scanView]; // call startCamera and start the plugin outside
    }

    // we've just readded the ScanView, make sure it goes beneath the other views.
    [self.view sendSubviewToBack:self.scanView];
    
    [self.scanView startCamera];
}

+ (ALScanViewPlugin *)scanViewPluginWithBarcodeFormats:(NSArray<ALBarcodeFormat *> *)barcodeFormats
                                        isMultiBarcode:(BOOL)isMultiBarcode
                                                 error:(NSError **)error {
    ALScanViewPluginConfig *scanViewPluginConfig = [self.class defaultScanViewPluginConfig];
    // reach into the barcode config and change the formats and multibarcode flags
    ALPluginConfig *pluginConfig = scanViewPluginConfig.scanPluginConfig.pluginConfig;

    // if multibarcode, also cancelOnResult = false, otherwise true
    pluginConfig.cancelOnResult = [NSNumber numberWithBool:isMultiBarcode ? false : true];

    ALBarcodeConfig *barcodeConfig = pluginConfig.barcodeConfig;
    barcodeConfig.barcodeFormats = barcodeFormats;
    barcodeConfig.multiBarcode = @(isMultiBarcode);

    NSMutableDictionary *scanFeedbackConfigDict = [NSMutableDictionary dictionaryWithDictionary:[[scanViewPluginConfig.scanFeedbackConfig asJSONString] asJSONObject]];

    scanFeedbackConfigDict[@"beepOnResult"] = @(!isMultiBarcode);
    scanFeedbackConfigDict[@"vibrateOnResult"] = @(!isMultiBarcode);
    ALScanFeedbackConfig *scanFeedbackConfig = [ALScanFeedbackConfig withJSONDictionary:scanFeedbackConfigDict];

    scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithScanPluginConfig:scanViewPluginConfig.scanPluginConfig cutoutConfig:scanViewPluginConfig.cutoutConfig scanFeedbackConfig:scanFeedbackConfig error:nil];

    return [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:error];
}

- (void)saveBarcodeSymbologies {
    [NSUserDefaults AL_setSelectedSymbologiesForBarcode:[ALBarcodeFormatHelper readableNameForFormats:self.selectedBarcodeFormats]];
}

// MARK: - Setup UI Elements

- (void)setupScanModeSelectionButton {
    self.scanModeSelectionButton = [[UIButton alloc] init];
    CGFloat margin = 20;
    CGFloat buttonWidth = 98;
    CGFloat buttonHeight = 36;
    self.scanModeSelectionButton.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75].CGColor;
    self.scanModeSelectionButton.layer.cornerRadius = round(buttonHeight / 2.0f);
    self.scanModeSelectionButton.layer.borderWidth = 0.6;
    self.scanModeSelectionButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    [self.scanModeSelectionButton setTitle:kSingleSelection forState:UIControlStateNormal];
    [self.scanModeSelectionButton setSelected:NO];
    [[self.scanModeSelectionButton titleLabel] setFont:[UIFont AL_proximaRegularWithSize:14]];
    [self.view addSubview:self.scanModeSelectionButton];
    self.scanModeSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scanModeSelectionButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-margin].active = YES;
    [self.scanModeSelectionButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:margin].active = YES;
    [self.scanModeSelectionButton.widthAnchor constraintEqualToConstant:buttonWidth].active= YES;
    [self.scanModeSelectionButton.heightAnchor constraintEqualToConstant:buttonHeight].active = YES;
    
    [self.scanModeSelectionButton addTarget:self action:@selector(showOptionsSelectionDialog) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBatchCountView {
    self.latestUniqueBarcodeScanResult = [NSMutableArray array];
    UINib *batchNib = [UINib nibWithNibName:@"ALBarcodeBatchCountView" bundle:[NSBundle mainBundle]];
    
    if ([batchNib instantiateWithOwner:self.batchCountView options:nil].count > 0) {
        self.batchCountView = [batchNib instantiateWithOwner:self.batchCountView options:nil].firstObject;
        [self.batchCountView resetLabels];
        self.batchCountView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.batchCountView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.batchCountView setHidden:YES];
        [self.view addSubview:self.batchCountView];
        
        NSArray *batchContainerConstraints = @[[self.batchCountView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                               [self.batchCountView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                               [self.batchCountView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                               [self.batchCountView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2]];
        
        [self.view addConstraints:batchContainerConstraints];
        [NSLayoutConstraint activateConstraints:batchContainerConstraints];
    }
}

- (void)setupConfirmScanButton {
    CGFloat horizontalPadding = 30;

    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scanButton];
    self.scanButton = scanButton;

    scanButton.backgroundColor = [UIColor AL_examplesBlue];
    scanButton.alpha = 1;
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    [scanButton.titleLabel setFont:[UIFont AL_proximaBoldWithSize:18]];
    [scanButton.titleLabel setTextColor:[UIColor whiteColor]];
    [scanButton.layer setCornerRadius:50/2];
    [scanButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scanButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    NSArray *scanButtonConstraints = @[
        [scanButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:horizontalPadding],
        [scanButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-horizontalPadding],
        [scanButton.heightAnchor constraintEqualToConstant:50],
        [scanButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30]
    ];

    [self.view addConstraints:scanButtonConstraints];
    [NSLayoutConstraint activateConstraints:scanButtonConstraints];
}

- (void)setupResultLabel {
    // The resultLabel is used as a debug view to see the scanned results. We set its text
    // in anylineBarcodeModuleView:didFindScanResult:atImage below
    CGRect frame = CGRectMake(20, self.view.frame.size.height - 150, self.view.frame.size.width - 40, 50);
    self.resultLabel = [[UILabel alloc] initWithFrame:frame];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.textColor = [UIColor whiteColor];
    self.resultLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.showsExpansionTextWhenTruncated = YES;
    self.resultLabel.numberOfLines = 2;
    [self.view addSubview:self.resultLabel];

    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.resultLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:40].active = YES;
    [self.resultLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.resultLabel.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-150].active = YES;
}

- (void)setupSettingsNavBarBtn {
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showSettings:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)setColors {
    [super setColors];

    UIColor *navTint = [UIColor colorWithWhite:0.3 alpha:1];
    if (self.isDarkMode) {
        navTint = [UIColor colorWithWhite:1 alpha:1];
    }
    self.navigationItem.rightBarButtonItem.tintColor = navTint;
}

// MARK: - IBAction methods

- (IBAction)showSettings:(id)sender {
    [self.barcodeSettingsViewController setBarcodeFormatOptions:[ALBarcodeFormatHelper readableNameForFormats:self.selectedBarcodeFormats]];
    [self.barcodeSettingsViewController setIsSingleManualScanEnabled:_isSingleManualScanEnabled];
    [self.barcodeSettingsViewController setIsMultiManualScanEnabled:_isMultiManualScanEnabled];
    [self.navigationController pushViewController:_barcodeSettingsViewController animated:YES];
}

- (void)scanAction:(id)sender {
    [self showResultControllerWithResults]; // maybe save the last scanned cropped image result too
}


- (void)showOptionsSelectionDialog {
    NSArray<NSString *> *choices = @[ kSingleSelection, kMultiSelection, kBatchSelection ];
    NSArray<NSNumber *> *selections = @[@(self.dialogIndexScanModeSelected)];
    ALConfigurationDialogViewController *vc = [[ALConfigurationDialogViewController alloc]
                                               initWithChoices:choices
                                               selections:selections
                                               secondaryTexts:@[]
                                               showApplyBtn:NO
                                               dialogType:ALConfigDialogTypeScanModeSelection];
    vc.delegate = self;
    [vc setSelectionDialogFontSize:16.0];
    [self presentViewController:vc animated:YES completion:nil];
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {

    if (!scanResult.croppedImage) { // reject any result that doesn't come with an image.
        // ACO this is a known bug in the core (at the moment)
        // In doing this, the plugin config (on JSON) needs `cancelOnResult` to be false.
        return;
    }

    [self stopTroubleScanningTimeout];

    self.latestScanResult = scanResult;

    NSArray<ALBarcode *> *barcodesFound = [NSArray arrayWithArray:self.latestScanResult.pluginResult
                                           .barcodeResult.barcodes];
    NSArray<ALBarcode *> *barcodes = scanResult.pluginResult.barcodeResult.barcodes;
    NSArray<ALResultEntry *> *resultData = [ALBarcodeResultUtil resultDataFromBarcodeResults:barcodesFound];
    if (barcodes.count < 1) {
        return;
    }

    switch (self.dialogIndexScanModeSelected) {
        case BarcodeSingleScanMode:
            if (_isSingleManualScanEnabled) {
                [self setScanButtonHidden:NO andEnable:YES];
                [self startTroubleScanningTimeout];
            } else {
                [self showResultControllerWithResults];
                [self stopTroubleScanningTimeout];
            }
            break;
        case BarcodeMultiScanMode:
            if (_isMultiManualScanEnabled) {
                [self setScanButtonHidden:NO andEnable:YES];
                [self startTroubleScanningTimeout];
            } else {
                [self showResultControllerWithResults];
                [self stopTroubleScanningTimeout];
            }
            break;
        case BarcodeBatchScanMode:
            [self removeRepeatedResultsFromResultArray:barcodes];
            [self stopTroubleScanningTimeout];
            [self.scanButton setHidden:YES];
            [self.batchCountView setCountResultText:resultData.firstObject.value];
            [self.batchCountView setBatchCountSymbologyText:[barcodes.firstObject format]];
            [self.batchCountView setBatchCountText:[NSString stringWithFormat:@"%lu", (unsigned long)self.latestUniqueBarcodeScanResult.count]];
            break;
        default:
            break;
    }
}


// MARK: - ALScanViewPluginDelegate

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin visualFeedbackReceived:(ALEvent *)event {
    // NSLog(@"ACO visual feedback received: %@", event.JSONStr);
}

- (void)scanViewPluginResultBeepTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPluginResultBlinkTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPluginResultVibrateTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin brightnessUpdated:(ALEvent *)event {
    // NSLog(@"ACO brightness updated: %@", event.JSONStr);
}

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin cutoutVisibilityChanged:(ALEvent *)event {
    // NSLog(@"ACO cutout visibility changed: %@", event.JSONStr);
    // ACO TODO: maybe include the cutout coordinates in scan view coordinate space.
}

// TODO: (ACO) see if there's any need to provide this

//- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin *)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult*)scanResult {
//    // Nothing to do there
//    // we get the results with anylineBarcodeScanPlugin:scannedBarcodes:
//}
//

//- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info {
//    if ([info.variableName isEqualToString:@"$brightness"]) {
//        [self updateBrightness:[info.value floatValue] forModule:self.barcodeScanPlugin];
//    }
//}

- (void)showResultControllerWithResults {
    if (!self.latestScanResult) {
        // prevent double pushes (result will be cleared upon entry)
        return;
    }
    [self.scanViewPlugin stop];

    // copy the barcodes array and image before clearing
    NSArray<ALBarcode *> *barcodesFound = [NSArray arrayWithArray:self.latestScanResult.pluginResult
                                           .barcodeResult.barcodes];
    UIImage *image = [self.latestScanResult.croppedImage copy];

    NSAssert(barcodesFound.count > 0, @"no barcodes found");

    self.latestScanResult = nil;
    self.latestUniqueBarcodeScanResult = [NSMutableArray array];
    
    NSArray<ALResultEntry *> *resultData = [ALBarcodeResultUtil resultDataFromBarcodeResults:barcodesFound];
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];

    // ACO this disabled block of code copies the result text into the result label (which we've also disabled)
    //    NSMutableArray *resultStrs = [NSMutableArray arrayWithCapacity:resultData.count];
    //    for (ALResultEntry *data in resultData) {
    //        if ([data.title isEqualToString:@"Barcode Result"]) {
    //            [resultStrs addObject:data.value];
    //        }
    //    }
    //    self.resultLabel.text = [resultStrs componentsJoinedByString:@", "];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:resultDataJSONStr
                 barcodeResult:barcodesFound[0].value
                         image:image
                    scanPlugin:self.scanViewPlugin.scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

// MARK: - Handle timeouts

- (void)startTroubleScanningTimeout {
    [self.troubleScanningTimeout invalidate];
    self.troubleScanningTimeout = [NSTimer scheduledTimerWithTimeInterval:kBarcodeTroubleScanningTimeoutTime
                                                                   target:self
                                                                 selector:@selector(showTroubleScanningDialog)
                                                                 userInfo:nil
                                                                  repeats:NO];
}

- (void)stopTroubleScanningTimeout {
    [self.troubleScanningTimeout invalidate];
    self.troubleScanningTimeout = nil;
}

- (void)showTroubleScanningDialog {
    if ([self.navigationController topViewController] != self) {
        return;
    }

    if (self.presentedViewController != nil) {
        return;
    }

    [self.scanViewPlugin stop];

    __weak __block typeof(self) weakSelf = self;
    [self showAlertWithTitle:kBarcodeScanVC_titleText message:kBarcodeScanVC_messageText completion:^{
        [weakSelf.scanViewPlugin startWithError:nil];
        [weakSelf startTroubleScanningTimeout];
    }];
}

// MARK: - ALBarcodeSettingsDelegate

- (void)isSingleScanTriggerEnabled:(BOOL)isEnabled {
    self.isSingleManualScanEnabled = isEnabled;
    [self setScanButtonHidden:!_isSingleManualScanEnabled andEnable:NO];
}

- (void)isMultiScanTriggerEnabled:(BOOL)isEnabled {
    self.isMultiManualScanEnabled = isEnabled;
    [self setScanButtonHidden:!_isMultiManualScanEnabled andEnable:NO];
}

- (void)selectedSymbologies:(nonnull NSArray<NSString *> *)selectedItems {
    [NSUserDefaults AL_setSelectedSymbologiesForBarcode:selectedItems];
    [self setSelectedBarcodeFormats:[ALBarcodeFormatHelper formatsForReadableNames:selectedItems]];
}

- (void)setScanButtonHidden:(BOOL)isHidden andEnable:(BOOL)isEnabled {
    if (self.dialogIndexScanModeSelected == BarcodeBatchScanMode) {
        return;
    }
    [self.scanButton setHidden:isHidden];
    [self.scanButton setEnabled:isEnabled];
    if (isEnabled) {
        [self.scanButton setBackgroundColor:[UIColor AL_examplesBlue]];
    } else {
        [self.scanButton setBackgroundColor:[UIColor grayColor]];
    }
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialog:(nonnull ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    NSString *buttonTitleString = kSingleSelection;
    BOOL isMultiBarcodeEnabled = NO;
    BOOL isBatchHidden = YES;
    [self.scanViewPlugin stop];
    self.dialogIndexScanModeSelected = index;
    switch (index) {
        case BarcodeSingleScanMode:
            buttonTitleString = kSingleSelection;
            isBatchHidden = YES;
            [self setScanButtonHidden:!_isSingleManualScanEnabled andEnable:NO];
            break;
        case BarcodeMultiScanMode:
            buttonTitleString = kMultiSelection;
            isMultiBarcodeEnabled = YES;
            isBatchHidden = YES;
            [self setScanButtonHidden:!_isMultiManualScanEnabled andEnable:NO];
            break;
        case BarcodeBatchScanMode:
            buttonTitleString = kBatchSelection;
            isMultiBarcodeEnabled = YES;
            isBatchHidden = NO;
            [self setScanButtonHidden:YES andEnable:NO];
            break;
        default:
            break;
    }
    [self.scanModeSelectionButton setTitle:buttonTitleString forState:UIControlStateNormal];
    self.isMultiBarcode = isMultiBarcodeEnabled;
    [self resetBatchCount:isBatchHidden];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadScanView];
    [self.scanViewPlugin startWithError:nil];
}

- (void)resetBatchCount:(BOOL)isBatchHidden {
    [self.batchCountView setHidden:isBatchHidden];
    [self.batchCountView resetLabels];
}

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {
    // required implementation
}

- (void)configDialogCancelled:(nonnull ALConfigurationDialogViewController *)dialog {
//    [self dialogCancelled];
}

@end
