#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"

#import "ALScriptSelectionViewController.h"
#import "ALTutorialViewController.h"
#import "ALUniversalIDScanConfigController.h"
#import "ALUniversalIDScanViewController.h"

NSString * const kDriversLicenseTitleString = @"Driver's License";
NSString * const kIDCardTitleString = @"ID Card";
NSString * const kPassportVisaTitleString = @"Passport / Visa";

NSString * const kArabicIDTitleString = @"Arabic";
NSString * const kCyrillicIDTitleString = @"Cyrillic";
NSString * const kLatinIDTitleString = @"Latin";
NSString * const kDefaultIDTitleString = @"ID";

NSString * const kOneSide = @"1 sided";
NSString * const kTwoSide = @"2 sided";

static const NSUInteger kChoicesCount = 3;

static NSString *kChoiceTitles[kChoicesCount] = { // NOTE: a C array
    kLatinIDTitleString,
    kArabicIDTitleString,
    kCyrillicIDTitleString,
};

NSString * const kDocumentationSupportedIdsURL = @"https://documentation.anyline.com/toc/products/id/universal_id/index.html#supported-document-types-and-countries";
NSString * const kRequestSupportMsgBodyFmt = @"Dear Anyline Support,</br></br>I have recurrently faced an error updating the content.</br></br>This is related to the deployment \"%@\".</br></br>The error I received is: \"%@\".</br></br>Kind regards";

NSString * const kScanIDFrontLabelText = @"Scan your ID";
NSString * const kScanIDBackLabelText = @"Turn ID over";
NSString * const kScanViewPluginFrontID = @"IDPluginFront";
NSString * const kScanViewPluginBackID = @"IDPluginBack";

NSString * const kFileNameUniversalIdFront = @"universal_id_front_config";
NSString * const kFileNameUniversalIdCompositeBack = @"universal_id_composite_config";
NSString * const kFileNameIdFront = @"id_front_config";
NSString * const kFileNameIdCompositeBack = @"id_composite_config";
NSString * const kFileNameDriverLicenseFront = @"driver_license_front_config";
NSString * const kFileNameDriverLicenseCompositeBack = @"driver_license_composite_config";

NSString * const kTroubleScanningAlertDefaultTitleText = @"Having trouble scanning?";
NSString * const kTroubleScanningAlertDefaultMessageText = @"This ID is either not supported yet or the scan was not captured correctly.";
NSString * const kTroubleScanningAlertDefaultActionText = @"Try again";

NSString * const kTroubleScanningAlertBadConditionTitleText = @"This ID was not captured correctly.";
NSString * const kTroubleScanningAlertBadConditionMessageText = @"Please ensure a good scanning environment. \
Try again later or read through the documentation for more information.";

NSString * const kTroubleScanningAlertUnknownIDTitleText = @"ID not supported";
NSString * const kTroubleScanningAlertUnknownIDMessageText = @"Unfortunately, it seems like this ID is not supported yet.";

NSString * const kActionTitleMoreInfo = @"More info";
NSString * const kActionTitleOK = @"OK";
NSString * const kActionTitleStartOver = @"Start over";

NSUInteger const kUniversalIDTroubleScanningCounter = 3;

// Timeout applied to each side of ID scan before a prompt is shown
NSInteger const kUniversalIDTroubleScanningTimeoutTime = 30;

NSTimeInterval const kUniversalIDBacksideScanTimeout = 0.5;

// applies to the second part of the serial scan (backside parallel scan
// of barcode:PDF417+ID). This is the total time before serial gives up and
// results are gathered and presented, regardless of whether or not an ID
// backside is successfully scanned.
// NSInteger const kUniversalIDSerialScanTimeout = 5;

// as PDF417 is an optional child of the parallel plugin (together with ID
// backside), this is the amount of additional seconds barcode scanning is
// given to add to the back side ID scan after the latter has already been
// successfully scanned.
// NSInteger const kBarcodePDF417Timeout = 1;

typedef NS_ENUM(NSUInteger, ALUniversalIDScanType) {
    ALUniversalIDScanTypeGeneric = 0,
    ALUniversalIDScanTypeDriverLicense,
    ALUniversalIDScanTypeIDCard
};


@interface ALUniversalIDScanViewController () <ALScanPluginDelegate, ALUniversalIDScanConfigControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSString *configJSONStr;

@property (nullable, nonatomic, strong) NSMutableArray<ALResultEntry *> *resultData;

@property (nullable, nonatomic, strong) UIImage *frontScanImage;

@property (nullable, nonatomic, strong) UIImage *backScanImage;

@property (nullable, nonatomic, strong) UIImage *faceImage;

@property (nullable, nonatomic, strong) NSTimer *troubleScanningTimeout;

// how long to wait before wrapping backside scan (must have at least 1 out of 2 results)
@property (nullable, nonatomic, strong) NSTimer *backsideScanTimeout;

@property (nonatomic) NSUInteger troubleScanningCounter;

@property (nonatomic, strong) NSMutableString *resultHistoryString;

@property (nullable, nonatomic, strong) UIView *hintView;

@property (nullable, nonatomic, strong) UILabel *hintViewLabel;

@property (nonatomic, strong) UIImageView *flipIDAnimationView;

@property (nonatomic, strong) ALIDCountryHelper *countryIDHelper;

@property (nonatomic, strong) ALUniversalIDScanConfigController *configController;

@property (nonatomic, assign) BOOL isTwoSided;

@property (nonatomic, assign) BOOL hasScannedSecondSide;

@property (nonatomic, readonly) ALUniversalIDScanType scanType;

@property (nonatomic, assign) NSUInteger dialogIndexSelected;

@property (nonatomic, strong, nullable) ALBarcodeResult *barcodeResult;

@property (nonatomic, strong, nullable) ALUniversalIDResult *backsideIDResult;

@end

@implementation ALUniversalIDScanViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isTwoSided = NO;
    self.resultData = [[NSMutableArray alloc] init];
    [self subscribeToAppLifecycleEvents];
    
    if (!_countryIDHelper) {
        _countryIDHelper = [[ALIDCountryHelper alloc] init];
    }

    self.dialogIndexSelected = 0;
    
    self.title = (self.title && self.title.length > 0) ? self.title : kDefaultIDTitleString;
    
    // assume a script type based on VC title
    self.scriptType = ALScriptTypeLatin;
    if ([self.title localizedCaseInsensitiveCompare:kArabicIDTitleString] == NSOrderedSame) {
        self.scriptType = ALScriptTypeArabic;
    } else if ([self.title localizedCaseInsensitiveCompare:kCyrillicIDTitleString] == NSOrderedSame) {
        self.scriptType = ALScriptTypeCyrillic;
    }
    
    CGFloat hintMargin = 7;
    
    // Add scan hint label
    self.hintView = [self createScanHintView:hintMargin];
    [self.view addSubview:self.hintView];
    
    [self setupNavigationBar];

    [self setupModeToggle];
    
    [self configureSelectNoOfSidesButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self resumeScanning];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTroubleScanningTimeout];
    [self stopBacksideScanTimeout];
}

- (void)resetResultData {
    self.resultData = [NSMutableArray array];
    self.frontScanImage = nil;
    self.backScanImage = nil;
    self.barcodeResult = nil;
    self.backsideIDResult = nil;
    self.hasScannedSecondSide = NO;
    self.faceImage = nil;
}

- (void)removeScanView {
    if (self.scanView) {
        [self.scanView stopCamera];
        [self.scanView removeFromSuperview];
    }
}

- (void)createFrontScanViewPlugin {
    [self resetResultData];
    
    NSDictionary *frontIDScanViewConfig = [self getConfigDictForFrontIDScanner];
    
    NSError *error; // each time it's used, you should really check the error.
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:frontIDScanViewConfig error:&error];
    
    // Handle it properly: you most likely couldn't proceed to the next stage when an error occurs.
    ALScanViewPluginConfig *scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithJSONDictionary:frontIDScanViewConfig
                                                                                                    error:&error];
    [scanViewPluginConfig.scanPluginConfig.pluginConfig.universalIDConfig setAlphabet:[self getAlphabet]];
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:&error];
    
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    if (self.scanView) {
        BOOL success = [self.scanView setScanViewPlugin:scanViewPlugin error:&error];
        if (!success) {
            NSLog(@"Unable to update scan view plugin. Reason: %@", error.localizedDescription);
        }
        if ([self popWithAlertOnError:error]) {
            return;
        }
    } else {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                           scanViewConfig:self.scanViewConfig
                                                    error:&error];
        
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
    }
    scanViewPlugin.scanPlugin.delegate = self;
    [self startScanning:&error];
    [self.scanView startCamera];
    [self.view sendSubviewToBack:self.scanView];
}

- (void)createBackScanViewPlugin {
    NSDictionary *backIDScanViewConfig = [self getConfigDictForBackIDScanner];
    
    // going to recreate the scan plugin configs and all with the currently-selected alphabet
    ALAlphabet *alphabet = [self getAlphabet];
    
    NSError *error;
    id<ALScanViewPluginBase> backScanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:backIDScanViewConfig
                                                                                        error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    // (The ScanViewPlugin needs to be recreated)
    // create a new scan plugin (with the config changes) and pass it to scan view
    // plugin obj / constructor.
    ALScanViewPluginConfig *scanViewPluginConfig;
    if ([backScanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        ALScanViewPlugin *scanViewPlugin = backScanViewPlugin;
        scanViewPluginConfig = scanViewPlugin.scanViewPluginConfig;
        scanViewPluginConfig.scanPluginConfig.pluginConfig.universalIDConfig.alphabet = alphabet;
        
        backScanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:scanViewPluginConfig.asJSONString.asJSONObject
                                                                   error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        
        ((ALScanViewPlugin *)backScanViewPlugin).scanPlugin.delegate = self;
        
    } else if ([backScanViewPlugin isKindOfClass:ALViewPluginComposite.class]) {
        ALViewPluginComposite *composite = backScanViewPlugin;
        // modify the alphabet of the ID plugin child
        for (id<ALScanViewPluginBase> child in composite.children) {
            if ([child isKindOfClass:ALScanViewPlugin.class] && [[(ALScanViewPlugin *)child scanPlugin] scanPluginConfig].pluginConfig.universalIDConfig != nil) {
                ALScanViewPlugin *scanViewPlugin = child;
                scanViewPluginConfig = scanViewPlugin.scanViewPluginConfig;
                scanViewPluginConfig.scanPluginConfig.pluginConfig.universalIDConfig.alphabet = alphabet;
                break;
            }
        }
        composite = [[ALViewPluginComposite alloc] initWithJSONDictionary:composite.JSONDictionary[@"viewPluginCompositeConfig"] error:nil];
        backScanViewPlugin = composite;
        for (id<ALScanViewPluginBase> child in composite.children) {
            if ([child isKindOfClass:ALScanViewPlugin.class]) {
                ((ALScanViewPlugin *)child).scanPlugin.delegate = self;
            }
        }
    }
    
    NSAssert(backScanViewPlugin, @"backScanViewPlugin should not be null!");
    
    scanViewPluginConfig.scanPluginConfig.pluginConfig.universalIDConfig.alphabet = [self getAlphabet];

    // the way it works, unfortunately for the back scan view, is that it will keep using
    // any scan view config used for the front scan because then we wouldn't have to recreate the
    // scan view.
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:backIDScanViewConfig error:&error];
    
    if (self.scanView) {
        BOOL success = [self.scanView setScanViewPlugin:backScanViewPlugin error:&error];
        if (!success) {
            NSLog(@"Unable to update scan view plugin. Reason: %@", error.localizedDescription);
        }
        if ([self popWithAlertOnError:error]) {
            return;
        }
    } else {
        
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:backScanViewPlugin
                                           scanViewConfig:self.scanViewConfig
                                                    error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        
        [self installScanView:self.scanView];
    }
    
    [self startScanning:&error];
    
    [self.scanView startCamera];
    [self.view sendSubviewToBack:self.scanView];
}

- (ALAlphabet *)getAlphabet {
    switch (self.scriptType) {
        case ALScriptTypeLatin:
            return [ALAlphabet withValue:@"latin"];
        case ALScriptTypeArabic:
            return [ALAlphabet withValue:@"arabic"];
        case ALScriptTypeCyrillic:
            return [ALAlphabet withValue:@"cyrillic"];
    }
    return [ALAlphabet withValue:@"latin"];
}

- (ALUniversalIDScanType)scanType {
    if ([self.title isEqualToString:kIDCardTitleString]) {
        return ALUniversalIDScanTypeIDCard;
    } else if ([self.title isEqualToString:kDriversLicenseTitleString]) {
        return ALUniversalIDScanTypeDriverLicense;
    }
    return ALUniversalIDScanTypeGeneric;
}

- (NSDictionary *)getConfigDictForFrontIDScanner {
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      [self fileNameForCurrentScanModeIsFront:YES] ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:path];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:jsonFile
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    return configDict;
}

- (NSDictionary *)getConfigDictForBackIDScanner {
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      [self fileNameForCurrentScanModeIsFront:NO] ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:path];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:jsonFile
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    return configDict;
}

- (NSString *)fileNameForCurrentScanModeIsFront:(BOOL)isFront {
    switch (self.scanType) {
        case ALUniversalIDScanTypeIDCard:
            return isFront ? kFileNameIdFront : kFileNameIdCompositeBack;
        case ALUniversalIDScanTypeDriverLicense:
            return isFront ? kFileNameDriverLicenseFront : kFileNameDriverLicenseCompositeBack;
        case ALUniversalIDScanTypeGeneric:
            return isFront ? kFileNameUniversalIdFront : kFileNameUniversalIdCompositeBack;
    }
}

- (void)setupNavigationBar {
    UIBarButtonItem *infoBarItem;
    
    NSMutableArray<UIBarButtonItem *> *barButtonItems = [NSMutableArray array];
    
    if (![[[NSBundle mainBundle] bundleIdentifier] localizedCaseInsensitiveContainsString:@"bundle"]) {
        UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [infoButton setTintColor:[UIColor AL_BackButton]];
        [infoButton setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        [infoButton addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
        infoBarItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    }

    if (infoBarItem) {
        [barButtonItems addObject:infoBarItem];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barButtonItems addObject:flexibleSpace];
    
    self.navigationItem.rightBarButtonItems = barButtonItems;
}

- (void)showScanOptionsDialog {
    ALScriptType scriptType = self.scriptType;
    ALUniversalIDScanConfig *config = [[ALUniversalIDScanConfig alloc] initWithRegions:@[] // regions is no longer used here

                                                                            scriptType:scriptType];
    [self startScanConfigurator:config];
    [self.scanView stopCamera];
}

- (void)startScanConfigurator:(ALUniversalIDScanConfig *)config {
    if (!_configController) {
        _configController = [[ALUniversalIDScanConfigController alloc] initWithPresentingVC:self
                                                                              countryHelper:_countryIDHelper
                                                                                 selectMode:ALConfigDialogTypeScriptSelection
                                                                                   delegate:self];
    }
    self.configController.config = config;
    [self.configController start];
}

- (IBAction)infoPressed:(id)sender {
    [self presentViewController:[[ALTutorialViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)selectScriptPressed:(id)sender {
    [self showScanOptionsDialog];
}

- (IBAction)settingsPressed:(id)sender {
    [self showScanOptionsDialog];
}

// MARK: - Configure UI

- (void)openContactEmailWithDeployment:(NSString *)deployment error:(NSString *)error {
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlertWithTitle:@"Mail Settings"
                         message:@"Please set up an email account in the Settings App"];
        return;
    }
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface
    [composeVC setToRecipients:@[@"support@anyline.com"]];
    [composeVC setSubject:[NSString stringWithFormat:@"%@ Support",
                           [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]]];
    NSString *msgBody = [NSString stringWithFormat:kRequestSupportMsgBodyFmt, deployment, error];
    [composeVC setMessageBody:msgBody isHTML:YES];
    
    [self presentViewController:composeVC animated:YES completion:nil];
}

- (void)configureSelectNoOfSidesButton {
    UIButton *selectSides = [[UIButton alloc] init];
    CGFloat margin = 20;
    CGFloat buttonWidth = 72;
    CGFloat buttonHeight = 36;
    selectSides.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75].CGColor;
    selectSides.layer.cornerRadius = round(buttonHeight / 2.0f);
    selectSides.layer.borderWidth = 0.6;
    selectSides.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    [selectSides setTitle:kOneSide forState:UIControlStateNormal];
    [selectSides setTitle:kTwoSide forState:UIControlStateSelected];
    [selectSides setSelected:NO];
    [[selectSides titleLabel] setFont:[UIFont AL_proximaRegularWithSize:14]];
    [self.view addSubview:selectSides];
    selectSides.translatesAutoresizingMaskIntoConstraints = NO;
    
    [selectSides.rightAnchor constraintEqualToAnchor:self.modeSelectButton.leftAnchor constant:-10].active = YES;
    [selectSides.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:margin].active = YES;
    [selectSides.widthAnchor constraintEqualToConstant:buttonWidth].active= YES;
    [selectSides.heightAnchor constraintEqualToConstant:buttonHeight].active = YES;
    
    [selectSides addTarget:self action:@selector(changeSelectedSides:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)changeSelectedSides:(UIButton *)sender {
    _isTwoSided = !sender.isSelected;
    [sender setSelected:_isTwoSided];
    [self startTroubleScanningTimeout];
}

- (UIView *)createScanHintView:(CGFloat)hintMargin {
    UILabel * hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView * hintView = [[UILabel alloc] initWithFrame:CGRectZero];
    hintView.alpha = 0;
    hintViewLabel.text = kScanIDFrontLabelText;
    [hintViewLabel sizeToFit];
    [hintView addSubview:hintViewLabel];
    hintView.frame = UIEdgeInsetsInsetRect(hintViewLabel.frame, UIEdgeInsetsMake(-hintMargin, -hintMargin, -hintMargin, -hintMargin));
    hintView.center = CGPointMake(self.view.center.x, 0);
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor constant:0].active = YES;
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor constant:0].active = YES;
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = YES;
    hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hintViewLabel.textColor = [UIColor whiteColor];
    
    // We shouldn't do this here:
    self.hintViewLabel = hintViewLabel;
    
    return hintView;
}

- (void)updateHintPosition:(CGFloat)newPosition {
    self.hintView.center = CGPointMake(self.hintView.center.x, newPosition);
    self.hintView.alpha = 1.0;
}

- (void)showPrepareForBacksideScanningHintWithDuration:(NSTimeInterval)secondsToDisplay complete:(void (^ __nullable)(void))complete {
    [self updateScanLabelWithStringWithAnimation:kScanIDBackLabelText];
    self.flipIDAnimationView.hidden = NO;
    [self.flipIDAnimationView startAnimating];
    
    __weak __block typeof(self) weakSelf = self;
    dispatch_time_t gifTimeout = dispatch_time(DISPATCH_TIME_NOW, secondsToDisplay * NSEC_PER_SEC);
    dispatch_after(gifTimeout, dispatch_get_main_queue(), ^(void){
        weakSelf.flipIDAnimationView.hidden = YES;
        complete();
    });
}

- (void)setupModeToggle {
    __weak __block typeof(self) weakSelf = self;
    [self addModeSelectButtonWithTitle:kChoiceTitles[self.dialogIndexSelected] buttonPressed:^{
        [weakSelf showScanOptionsDialog];
    }];
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    
    __weak ALUniversalIDScanViewController *weakSelf = self;
    
    // if barcode result is found, store it
    if (scanResult.pluginResult.barcodeResult) {
        self.barcodeResult = scanResult.pluginResult.barcodeResult;
    }

    [self addResultsAtIndex:scanResult.pluginResult.fieldList.resultEntries.mutableCopy];

    if (scanResult.faceImage && !self.faceImage) { // save only the first face image that is scanned
        // front side will have a first chance to do so, then the back side.
        // so if both sides have photos, the front pic will be used.
        self.faceImage = scanResult.faceImage;
    }
    
    if (_isTwoSided && !_hasScannedSecondSide) { // front scan + turn over
        
        self.frontScanImage = scanResult.croppedImage;
        [self stopTroubleScanningTimeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPrepareForBacksideScanningHintWithDuration:2.0 complete:^{
                [weakSelf createBackScanViewPlugin];
                weakSelf.hasScannedSecondSide = YES;
                [weakSelf startTroubleScanningTimeout];
            }];
        });
    } else {

        ALUniversalIDResult *IDResult = scanResult.pluginResult.universalIDResult;

        // if it was barcode, wait for ID before returning
        [self stopTroubleScanningTimeout];
        
        if (IDResult) {
            self.backsideIDResult = IDResult;
            self.backScanImage = scanResult.croppedImage;
        }
        
        if (!_isTwoSided) {
            // one sided
            [self finishBacksideScanning];
        } else {
            // two sided
            if ([self scanViewPluginIsComposite]) {
                // backside is composite (ID + Barcode)
                if (self.backsideIDResult && !self.barcodeResult) {
                    [self startBacksideScanTimeout];
                } else if (self.barcodeResult && !self.backsideIDResult) {
                    [self startBacksideScanTimeout];
                } else {
                    [self finishBacksideScanning];
                }
            } else {
                // backside is plain / not composite
                [self finishBacksideScanning];
            }
        }
    }
}

- (BOOL)scanViewPluginIsComposite {
    // it's talking about the current one, whether it be front side (single-sided) or
    // backside (when in double-side scanning)
    return ![self.scanViewPlugin isKindOfClass:ALScanViewPlugin.class];
}

- (void)finishBacksideScanning {
    [self stopBacksideScanTimeout];
    // show the results assuming one of two
    // its a composite, you want the first child
    
    ALScanPlugin *scanPlugin;
    if ([self.scanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        scanPlugin = [(ALScanViewPlugin *)self.scanViewPlugin scanPlugin];
    } else {
        scanPlugin = [(ALScanViewPlugin *)[self.scanViewPlugin children][0] scanPlugin];
    }
    
    NSMutableArray *images = [NSMutableArray array];
    if (self.frontScanImage) {
        [images addObject:self.frontScanImage];
    }
    if (self.backScanImage) {
        [images addObject:self.backScanImage];
    }
    
    __weak __block typeof(self) weakSelf = self;
    
    NSString *resultJSONStr = [ALResultEntry JSONStringFromList:self.resultData];
    [self anylineDidFindResult:resultJSONStr
                 barcodeResult:@""
                     faceImage:self.faceImage
                        images:images
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{
        dispatch_time_t gifTimeout = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(gifTimeout, dispatch_get_main_queue(), ^(void){
            ALResultViewController *vc = [[ALResultViewController alloc]
                                          initWithResults:weakSelf.resultData];
            vc.imageFace = weakSelf.faceImage;
            vc.imagePrimary = weakSelf.frontScanImage;
            vc.imageSecondary = weakSelf.backScanImage;
            vc.showDisclaimer = YES;
            vc.isRightToLeft = weakSelf.scriptType == ALScriptTypeArabic;
            UIViewController *topVC = [weakSelf.navigationController topViewController];
            if ([topVC isKindOfClass:[ALUniversalIDScanViewController class]]) {
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        });
    }];
}


// MARK: - GIF Animation for Backside

- (UIImageView *)flipIDAnimationView {
    if (!_flipIDAnimationView) {
        UIImage *flipAnimation = [UIImage animatedImageNamed:@"flip-id-" duration:1.0f];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = flipAnimation;
        
        NSMutableArray *animatedImagesArray = [NSMutableArray array];
        for (int i = 0; i <= 150; i++) {
            [animatedImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"flip-id-%d%@", i, @".png"]]];
        }
        
        imgView.animationImages = animatedImagesArray;
        imgView.animationDuration = 3.0f;
        imgView.animationRepeatCount = 1;
        imgView.hidden = YES;
        
        imgView.image = [imgView.animationImages lastObject]; // maybe we won't need this...
        [imgView startAnimating];
        
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        _flipIDAnimationView = imgView;
    }
    // original GIF size: 500 x 310
    
    [self.view addSubview:_flipIDAnimationView];
    [_flipIDAnimationView.centerXAnchor constraintEqualToAnchor:self.scanView.centerXAnchor constant:0].active = YES; // -90
    [_flipIDAnimationView.centerYAnchor constraintEqualToAnchor:self.scanView.centerYAnchor constant:0].active = YES; // -160
    [_flipIDAnimationView.widthAnchor constraintEqualToConstant:320].active = YES; // 250
    [_flipIDAnimationView.heightAnchor constraintEqualToConstant:180].active = YES; // 155
    
    return _flipIDAnimationView;
}

- (void)setupBackScanningGuideAnimation {
    
    if (!_flipIDAnimationView) { // create it the very first time
        UIImage *flipAnimation = [UIImage animatedImageNamed:@"flip-id-" duration:1.0f];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = flipAnimation;
        
        NSMutableArray *animatedImagesArray = [NSMutableArray array];
        for (int i = 0; i <= 150; i++) {
            [animatedImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"flip-id-%d%@", i, @".png"]]];
        }
        
        imgView.animationImages = animatedImagesArray;
        imgView.animationDuration = 3.0f;
        imgView.animationRepeatCount = 1;
        imgView.hidden = YES;
        
        imgView.image = [imgView.animationImages lastObject]; // maybe we won't need this...
        [imgView startAnimating];
        
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        _flipIDAnimationView = imgView;
    }
    // original GIF size: 500 x 310
    
    [self.view addSubview:_flipIDAnimationView];
    [_flipIDAnimationView.centerXAnchor constraintEqualToAnchor:self.scanView.centerXAnchor constant:0].active = YES; // -90
    [_flipIDAnimationView.centerYAnchor constraintEqualToAnchor:self.scanView.centerYAnchor constant:0].active = YES; // -160
    [_flipIDAnimationView.widthAnchor constraintEqualToConstant:320].active = YES; // 250
    [_flipIDAnimationView.heightAnchor constraintEqualToConstant:180].active = YES; // 155
}

// MARK: - Handle Scanning Issues

- (void)startTroubleScanningTimeout {
    [self.troubleScanningTimeout invalidate];
    self.troubleScanningTimeout = [NSTimer scheduledTimerWithTimeInterval:kUniversalIDTroubleScanningTimeoutTime
                                                                   target:self
                                                                 selector:@selector(showTroubleScanningDialog)
                                                                 userInfo:nil
                                                                  repeats:NO];
}

- (void)startBacksideScanTimeout {
    [self.backsideScanTimeout invalidate];
    self.backsideScanTimeout = [NSTimer scheduledTimerWithTimeInterval:kUniversalIDBacksideScanTimeout
                                                                target:self
                                                              selector:@selector(finishBacksideScanning)
                                                              userInfo:nil
                                                               repeats:NO];
}

- (void)stopTroubleScanningTimeout {
    [self.troubleScanningTimeout invalidate];
    self.troubleScanningTimeout = nil;
    self.troubleScanningCounter = 0;
}

- (void)stopBacksideScanTimeout {
    [self.backsideScanTimeout invalidate];
    self.backsideScanTimeout = nil;
}

- (void)showTroubleScanningDialog {
    [self.scanView stopCamera];
    // Note: because sometimes a race condition can cause the timeout invalidation to happen
    // after the ResultsVC has been pushed and is onscreen (we don't want to see the alert there)
    if ([self.navigationController topViewController] != self) {
        return;
    }
    
    // if you couldn't show the alert because there's a different dialog
    // (e.g. the scan config dialog) presented
    if (self.presentedViewController != nil) { return; }
    
    NSMutableArray <UIAlertAction *> *actions = [[NSMutableArray alloc] init];
    
    NSString *titleText = kTroubleScanningAlertDefaultTitleText;
    NSString *messageText = kTroubleScanningAlertDefaultMessageText;
    NSString *actionText = kTroubleScanningAlertDefaultActionText;
    
    self.troubleScanningCounter++;
    if (self.troubleScanningCounter < kUniversalIDTroubleScanningCounter) {
        // a few more chances given to try again, still using the same plugin
        
        __weak __block typeof(self) weakSelf = self;
        UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:actionText
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
            [weakSelf resumeScanning];
        }];
        [actions addObject:tryAgain];
        
        [self showAlertControllerWithTitle:titleText message:messageText actions:actions];
    } else {
        // no more tries remaining. On OK, start all over if still on frontside, or proceed to the
        // results if on backside.
        BOOL isDriverLicenseMode = self.scanType == ALUniversalIDScanTypeDriverLicense;
        [self showScanFailureAlertIsDriverLicenseMode:isDriverLicenseMode
                                   showMoreInfoOption:YES actionTitle:kActionTitleOK complete:^{
        }];
    }
}

- (void)returnFromBackground {
    [self resumeScanning];
}

- (void)resumeScanning {
    [self createFrontScanViewPlugin];
    [self startTroubleScanningTimeout];
}

// MARK: - Handle Scan Issues

- (void)showScanFailureAlertIsDriverLicenseMode:(BOOL)isDriverLicenseMode
                             showMoreInfoOption:(BOOL)showMoreInfoOption
                                    actionTitle:(NSString *)actionTitle
                                       complete:(void (^ __nullable)(void))complete {
    
    NSString *titleText = kTroubleScanningAlertDefaultTitleText;
    NSString *messageText = kTroubleScanningAlertDefaultMessageText;
    
    NSMutableArray <UIAlertAction *> *actions = [[NSMutableArray alloc] init];
    
    if (isDriverLicenseMode) {
        titleText = kTroubleScanningAlertBadConditionTitleText;
        messageText = kTroubleScanningAlertBadConditionMessageText;
    } else {
        titleText = kTroubleScanningAlertUnknownIDTitleText;
        messageText = kTroubleScanningAlertUnknownIDMessageText;
    }
    
    if (showMoreInfoOption) {
        UIAlertAction *moreInfo = [UIAlertAction actionWithTitle:kActionTitleMoreInfo
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
            [[self class] loadDocumentationWebPage];
            // Since you'll be leaving the app into a browser, make sure `resumeScanning` gets
            // called when returning to it
        }];
        [actions addObject:moreInfo];
    }
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:actionTitle
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
        complete();
    }];
    [actions addObject:ok];
    
    [self showAlertControllerWithTitle:titleText message:messageText actions:actions];
}

- (void)updateScanLabelWithStringWithAnimation:(NSString *)labelText {
    self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, .25, .25);
    self.hintViewLabel.text = labelText;
    [UIView animateWithDuration:0.4 animations:^{
        self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 4.5, 4.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 0.875, 0.875);
        } completion:^(BOOL finished) {
            self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 1.0, 1.0);
            [self.hintViewLabel sizeToFit];
        }];
    }];
}


// MARK: - ALUniversalIDScanConfigControllerDelegate

- (void)idScanConfigController:(ALUniversalIDScanConfigController *)controller finishedWithUpdatedConfig:(BOOL)hasUpdates {

    ALUniversalIDScanConfig *config = controller.config;
    self.scriptType = config.scriptType;
    [self.scanView startCamera];

    if (!hasUpdates) {
        return;
    }
    [self createFrontScanViewPlugin];
    [self startTroubleScanningTimeout];
}

- (void)idScanConfigController:(ALUniversalIDScanConfigController *)controller
              isChangingScript:(ALScriptType)newScript {
    [_countryIDHelper setScriptType:newScript];

    NSUInteger index = 0;
    switch (newScript) {
        case ALScriptTypeLatin: index = 0; break;
        case ALScriptTypeArabic: index = 1; break;
        case ALScriptTypeCyrillic: index = 2; break;
    }

    self.dialogIndexSelected = index;

    [self.modeSelectButton setTitle:kChoiceTitles[self.dialogIndexSelected]
                           forState:UIControlStateNormal];

}

// MARK: - ResultData Processing

- (void)addResultAtIndex:(ALResultEntry *)entry forFieldName:(NSString *)fieldName withOffset:(NSUInteger)offset {
    for (ALResultEntry *entryTemp in self.resultData) {
        if ([entryTemp.title localizedCaseInsensitiveCompare:entry.title] == NSOrderedSame) {
            [entry setValue:entry.value];
            return;
        }
    }
    [self.resultData addObject:entry];
}

- (void)addResultsAtIndex:(NSMutableArray<ALResultEntry *> *)entryArray {
    if (self.resultData.count > 0) {
        for (ALResultEntry *entryTemp in entryArray) {
            NSUInteger index = [self.resultData indexOfObjectPassingTest:^BOOL(ALResultEntry * _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
                return ([entryTemp.title localizedCaseInsensitiveCompare:entry.title] == NSOrderedSame);
            }];
            if (index != NSNotFound) {
                [[self.resultData objectAtIndex:index] setValue:entryTemp.value];
            } else {
                [self.resultData addObject:entryTemp];
            }
        }
    } else {
        [self.resultData addObjectsFromArray:entryArray];
    }
}

// MARK: - Miscellaneous

- (void)dialogStarted {
    // [self.scanView stopCamera];
    [self stopTroubleScanningTimeout];
}

- (void)dialogCancelled {
    [self.scanView startCamera];
    [self startTroubleScanningTimeout];
}

+ (void)loadDocumentationWebPage {
    NSURL *url = [NSURL URLWithString:kDocumentationSupportedIdsURL];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)subscribeToAppLifecycleEvents {
    if (@available(iOS 13, *)) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(returnFromBackground)
                                                   name:UISceneWillEnterForegroundNotification
                                                 object:nil];
    } else {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(returnFromBackground)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
    }
}

@end
