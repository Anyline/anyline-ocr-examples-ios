#import "ALBarcodeScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h" // for ALResultViewController
#import "ALBarcodeFormatHelper.h"
#import "ALBarcodeResultUtil.h"
#import "ALSelectionTable.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UISwitch+ALExamplesAdditions.h"

NSTimeInterval const kBarcodeTroubleScanningTimeoutTime = 15;

NSString * const kBarcodeScanVC_titleText = @"Barcode does not scan?";

NSString * const kBarcodeScanVC_messageText = @"By default not all barcodes are enabled for scanning, \
take a look at the settings to find out if your barcode is currently selected for scanning.";

NSString * const kBarcodeScanVC_configJSONFilename = @"sample_barcode_config";


@interface ALBarcodeScanViewController () <ALScanPluginDelegate, ALScanViewPluginDelegate, ALSelectionTableDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@property (nonatomic, readonly) ALScanViewPluginConfig *scanViewPluginConfigDefault;

@property (nonatomic, strong) ALScanResult *latestScanResult;

@property (nonatomic, strong) NSArray<ALBarcodeFormat *> *selectedBarcodeFormats;

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) NSTimer *fadeTimer;

@property (nonatomic, strong) UISwitch *barcodeModeToggle;

@property (nonatomic, assign) BOOL isMultiBarcode;

@property (nonatomic, strong) NSArray<NSString *> *defaultBarcodeSymbologiesReadable;

@property (nullable, nonatomic, strong) NSTimer *troubleScanningTimeout;

+ (ALScanViewPluginConfig *)defaultScanViewPluginConfig;

+ (ALScanViewPlugin *)scanViewPluginWithBarcodeFormats:(NSArray<ALBarcodeFormat *> *)barcodeFormats
                                        isMultiBarcode:(BOOL)isMultiBarcode;

@end


@implementation ALBarcodeScanViewController

- (void)dealloc {
    NSLog(@"dealloc ALBarcodeScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Barcodes";
    self.controllerType = ALScanHistoryBarcode;

    [self setupSettingsNavBarBtn];

    self.defaultBarcodeSymbologiesReadable = [ALBarcodeFormatHelper defaultSymbologiesReadableNames];

    // NOTE: we don't use the `self.* = ` notation here to avoid calling the reloadScanView each time
    // The values of these two properties are defined here and their corresponding values on the
    // config JSON file are ignored. Also, must give this property a value otherwise a crash will
    // ensue.
    _isMultiBarcode = NO;

    // or alternatively,
    //   _selectedBarcodeFormats = @[ <ALBarcodeFormat Constant>,... ];
    _selectedBarcodeFormats = [ALBarcodeFormatHelper formatsForReadableNames:
                               self.defaultBarcodeSymbologiesReadable];

    [self reloadScanView];
    
    [self setupConfirmScanButton];

    [self setupMultiBarcodeToggleButton];

    [self setColors];

    // ACO - maybe no need for this.
    // [self setupResultLabel];

    // TODO: enable PDF417 in the core, if it is available (it's a flag in the old plugin)
    // TODO: replicate the existing "info" delegate calls
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanViewPlugin startWithError:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTroubleScanningTimeout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanViewPlugin stop];
    [self stopTroubleScanningTimeout];

    // ACO do we still need this?
    // usleep(200000);
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
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

- (void)setIsMultiBarcode:(BOOL)isMultiBarcode {
    [self.scanViewPlugin stop];
    _isMultiBarcode = isMultiBarcode;
    [self reloadScanView];
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

    ALScanViewPlugin *scanViewPlugin = [self.class scanViewPluginWithBarcodeFormats:self.selectedBarcodeFormats
                                                                     isMultiBarcode:self.isMultiBarcode];
    scanViewPlugin.scanPlugin.delegate = self;
    scanViewPlugin.delegate = self;

    self.scanButton.alpha = self.isMultiBarcode ? 1 : 0;
    
    self.scanViewPlugin = scanViewPlugin;

    if (self.scanView) {
        [self.scanView setScanViewPlugin:scanViewPlugin error:nil];
    } else {
        NSDictionary *configJSONDictionary = [[self configJSONStrWithFilename:kBarcodeScanVC_configJSONFilename]
                                              asJSONObject];
        ALScanViewConfig *scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:configJSONDictionary
                                                                                      error:nil];
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                           scanViewConfig:scanViewConfig
                                                    error:nil];
        [self installScanView:self.scanView]; // call startCamera and start the plugin outside
    }

    // we've just readded the ScanView, make sure it goes beneath the other views.
    [self.view sendSubviewToBack:self.scanView];
    
    [self.scanView startCamera];
}

+ (ALScanViewPlugin *)scanViewPluginWithBarcodeFormats:(NSArray<ALBarcodeFormat *> *)barcodeFormats
                                        isMultiBarcode:(BOOL)isMultiBarcode {
    ALScanViewPluginConfig *scanViewPluginConfig = [self.class defaultScanViewPluginConfig];
    // reach into the barcode config and change the formats and multibarcode flags
    ALPluginConfig *pluginConfig = scanViewPluginConfig.scanPluginConfig.pluginConfig;

    // if multibarcode, also cancelOnResult = false, otherwise true
    pluginConfig.cancelOnResult = [NSNumber numberWithBool:isMultiBarcode ? false : true];

    ALBarcodeConfig *barcodeConfig = pluginConfig.barcodeConfig;
    barcodeConfig.barcodeFormats = barcodeFormats;
    barcodeConfig.multiBarcode = @(isMultiBarcode);

    // ALScanFeedbackConfig *scanFeedbackConfig =
    NSMutableDictionary *scanFeedbackConfigDict = [NSMutableDictionary dictionaryWithDictionary:[[scanViewPluginConfig.scanFeedbackConfig asJSONString] asJSONObject]];

    scanFeedbackConfigDict[@"beepOnResult"] = @(!isMultiBarcode);
    scanFeedbackConfigDict[@"vibrateOnResult"] = @(!isMultiBarcode);
    ALScanFeedbackConfig *scanFeedbackConfig = [ALScanFeedbackConfig withJSONDictionary:scanFeedbackConfigDict];

    scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithScanPluginConfig:scanViewPluginConfig.scanPluginConfig cutoutConfig:scanViewPluginConfig.cutoutConfig scanFeedbackConfig:scanFeedbackConfig error:nil];

    return [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:nil];
}

// MARK: - Setup UI Elements

- (void)setupConfirmScanButton {
    CGFloat horizontalPadding = 30;

    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scanButton];
    self.scanButton = scanButton;

    scanButton.backgroundColor = [UIColor AL_examplesBlue];
    scanButton.alpha = 0;
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
                                                                     action:@selector(showSymbologiesSelector:)];
    // UIColor *tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)setupMultiBarcodeToggleButton {
    UISwitch *multiBarcodeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.view addSubview:multiBarcodeSwitch];

    multiBarcodeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [multiBarcodeSwitch.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
    [multiBarcodeSwitch.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:115].active = YES;
    [multiBarcodeSwitch setTintColor:[UIColor AL_NonSelectedToolBarItem]];
    [multiBarcodeSwitch setOnTintColor:[UIColor AL_examplesBlue]];
    [multiBarcodeSwitch useHighContrast];

    [multiBarcodeSwitch addTarget:self action:@selector(toggleMultiBarcode:) forControlEvents:UIControlEventValueChanged];
    [multiBarcodeSwitch setOn:self.isMultiBarcode];

    self.barcodeModeToggle = multiBarcodeSwitch;

    UILabel *multiBarcodeLabel = [[UILabel alloc] init];
    [self.view addSubview:multiBarcodeLabel];
    multiBarcodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [multiBarcodeLabel.centerYAnchor constraintEqualToAnchor:multiBarcodeSwitch.centerYAnchor].active = YES;
    [multiBarcodeLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [multiBarcodeLabel.rightAnchor constraintEqualToAnchor:multiBarcodeSwitch.leftAnchor constant:-10].active = YES;
    [multiBarcodeLabel.heightAnchor constraintEqualToAnchor:multiBarcodeSwitch.heightAnchor].active = YES;

    multiBarcodeLabel.text = @"Multi Barcode";
    multiBarcodeLabel.font = [UIFont AL_proximaBoldWithSize:16];
    multiBarcodeLabel.textColor = [UIColor AL_White];
    multiBarcodeLabel.textAlignment = NSTextAlignmentRight;
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

- (void)scanAction:(id)sender {

    [self showResultControllerWithResults]; // maybe save the last scanned cropped image result too
}

- (IBAction)toggleMultiBarcode:(id)sender {
    self.isMultiBarcode = self.barcodeModeToggle.isOn; // calls the setter for this property
    [self.scanViewPlugin startWithError:nil];
}

- (void)showSymbologiesSelector:(id)button {
    NSArray<NSString *> *selectedItems = [ALBarcodeFormatHelper readableNameForFormats:self.selectedBarcodeFormats];
    NSString *title = @"Select Symbologies"; // "Select Barcode Symbologies" would've been clearer, but is a bit long
    ALSelectionTable *table = [[ALSelectionTable alloc] initWithSelectedItems:selectedItems
                                                                     allItems:[ALBarcodeFormatHelper readableBarcodeNamesDict]
                                                                 headerTitles:[ALBarcodeFormatHelper readableHeaderArray]
                                                                 defaultItems:self.defaultBarcodeSymbologiesReadable
                                                                        title:title
                                                                 singleSelect:NO];
    table.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:table];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

// MARK: - ALSelectionTableDelegate

- (void)selectionTable:(ALSelectionTable *)selectionTable
         selectedItems:(NSArray<NSString *> *)selectedItems {
    // this calls the setter for this property.
    self.selectedBarcodeFormats = [ALBarcodeFormatHelper
                                   formatsForReadableNames:selectedItems];
    [self.scanViewPlugin startWithError:nil];
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

    NSArray<ALBarcode *> *barcodes = scanResult.pluginResult.barcodeResult.barcodes;
    if (barcodes.count < 1) {
        return;
    }

    if (!self.isMultiBarcode) {
        [self showResultControllerWithResults];
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

@end
