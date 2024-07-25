#import "ALBaseScanViewController.h"
#import "ALWarningView.h"
#import "ScanHistory+CoreDataClass.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAwardsView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"

#if __has_include("AppDelegate_store.h")
#import "AppDelegate_store.h"
#else
#import "AppDelegate.h"
#endif

NSString * const kMsgAllowCameraAccessInSettings = @"Please allow Anyline to access \
the camera from Settings.";

static const NSTimeInterval kDelayBeforeWarningShown = 2.0;

@interface ALBaseScanViewController () <ALScanViewPluginDelegate>

@property (nonatomic, strong) ALWarningView *warningView;

@property (nonatomic, strong) NSTimer *animationTimer;

@property (nonatomic, assign) BOOL successfulScan;

@property (nonatomic, strong) NSLayoutConstraint *warningViewYOffsetCnst;

@property (nonatomic, assign) NSTimeInterval timeScanningStarted;

@end

@implementation ALBaseScanViewController

- (void)dealloc {
    // NSLog(@"ALBaseScanViewController")
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = (title && title.length > 0) ? title : @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successfulScan = NO;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.startTime = CACurrentMediaTime();
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor AL_BackButton]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor AL_BackButton]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.warningView hideWarning];
    [self enableLandscapeOrientation:NO];
}

- (NSString *)configJSONStrWithFilename:(NSString *)filename error:(NSError **)error {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:filename
                                                             ofType:@"json"];
    if (jsonFilePath != nil) {
        return [NSString stringWithContentsOfFile:jsonFilePath
                                         encoding:NSUTF8StringEncoding
                                            error:error];
    }
    return nil;
}

- (void)installScanView:(ALScanView *)scanView {
    [self.view addSubview:scanView];
    
    scanView.translatesAutoresizingMaskIntoConstraints = false;
    [scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    self.scanView.delegate = self;
}

- (BOOL)startScanning:(NSError **)error {

    if ([self.scanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        [(ALScanViewPlugin *)self.scanViewPlugin setDelegate:self];
    }
    [self.scanViewPlugin startWithError:error];

    if (error && *error) {
        NSLog(@"There was an error: %@", *error);
        return NO;
    }

    self.timeScanningStarted = [NSDate timeIntervalSinceReferenceDate];
    return YES;
}

- (void)stopScanning {
    [self.scanViewPlugin stop];
}

- (NSObject<ALViewPluginBase> *)scanViewPlugin {
    if ([self.scanView.viewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        return (ALScanViewPlugin *)self.scanView.viewPlugin;
    }
    return self.scanView.viewPlugin;
}

// MARK: - Warning View

- (ALWarningView *)warningView {
    if (!_warningView) {
        _warningView = [[ALWarningView alloc] init];
    }
    return _warningView;
}

- (void)addWarningSubviewIfNeededToScanView:(ALScanView *)scanView
                                cutoutFrame:(CGRect)cutoutFrame {

    // can be brought up by lazy initialization
    ALWarningView *warningView = self.warningView;

    // hide when cutout frame is null
    if (CGRectIsEmpty(cutoutFrame)) {
        warningView.hidden = YES;
        return;
    }
    warningView.hidden = NO;

    if (warningView.superview == scanView) { // already added
        [scanView bringSubviewToFront:self.warningView];
    } else {
        // not yet added, setup constraints
        [scanView addSubview:warningView];
        warningView.translatesAutoresizingMaskIntoConstraints = NO;
        [warningView.centerXAnchor constraintEqualToAnchor:scanView.centerXAnchor].active = YES;
        [warningView.widthAnchor constraintEqualToAnchor:scanView.widthAnchor].active = YES;
        self.warningViewYOffsetCnst = [warningView.centerYAnchor
                                       constraintEqualToAnchor:scanView.topAnchor constant:0];
        self.warningViewYOffsetCnst.active = YES;
    }

    // Prefer to place the warning view above the cutout, unless there's much less
    // space than below. Multiplier (x1.1) is to give more weight to top placement
    // if discrepancy between the two is not too significant.
    CGFloat cutoutTop = roundf(cutoutFrame.origin.y);
    CGFloat cutoutBottom = roundf(cutoutFrame.origin.y + cutoutFrame.size.height);
    CGFloat bottom = scanView.bounds.size.height;
    CGFloat height = self.warningView.bounds.size.height;
    CGFloat belowToAboveMultiplier = 1.1;
    BOOL placeBelow = cutoutTop * belowToAboveMultiplier < (bottom - cutoutBottom);
    if (placeBelow) {
        self.warningViewYOffsetCnst.constant = cutoutBottom + height * 0.5 + 25;
    } else {
        self.warningViewYOffsetCnst.constant = cutoutTop - height * 0.5 - 20;
    }
}

- (void)updateScanWarnings:(ALWarningState)warningState {
    NSTimeInterval timeNow = [NSDate timeIntervalSinceReferenceDate];
    // NSLog(@"ACO: time diff %.2f", timeNow - self.timeScanningStarted);
    // APP-410: this prevents the warning view from being shown until it's X seconds in
    if (timeNow - self.timeScanningStarted >= kDelayBeforeWarningShown) {
        [self.warningView showWarning:warningState];
    }
}

- (void)addModeSelectButtonWithTitle:(NSString *)title buttonPressed:(void (^)(void))buttonPressed {
    ALModeSelectionButton *modeSelectionButton = [[ALModeSelectionButton alloc] initWithTitle:title];
    if (modeSelectionButton) {
        [modeSelectionButton setDidPressButton:buttonPressed];
        [self.view addSubview:modeSelectionButton];
        modeSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat margin = 20;
        [modeSelectionButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-margin].active = YES;
        [modeSelectionButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:margin].active = YES;
        self.modeSelectButton = modeSelectionButton;
    }
}

// MARK: - anylineDidFindResult

- (void)anylineDidFindResult:(NSString *)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage *)image
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion {
    
    NSArray<UIImage *> *images = nil;
    if (image) {
        images = @[ image ];
    }
    
    [self anylineDidFindResult:result
                 barcodeResult:barcodeResult
                     faceImage:nil
                        images:images
                    scanPlugin:scanPlugin
                    viewPlugin:viewPlugin
                    completion:completion];
}

- (void)anylineDidFindResult:(NSString *)result
               barcodeResult:(NSString *)barcodeResult
                      images:(NSArray *)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion {
    [self anylineDidFindResult:result
                 barcodeResult:barcodeResult
                     faceImage:nil
                        images:images
                    scanPlugin:scanPlugin
                    viewPlugin:viewPlugin
                    completion:completion];
}

- (void)anylineDidFindResult:(NSString *)result
               barcodeResult:(NSString *)barcodeResult
                   faceImage:(UIImage *)faceImage
                      images:(NSArray *)images
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion {
    
    self.successfulScan = YES;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    NSString *what = ALScanHistoryType_toString[self.controllerType];
    
    // TODO: fix this.
    NSString *addon = [self addon];
    if (addon) {
        // TODO: should be more dynamic
        [attributes setObject:[self addon] forKey:@"digit_count"];
    }
    
    CFTimeInterval finishedTime = CACurrentMediaTime();
    [attributes setObject:[NSNumber numberWithDouble:(finishedTime-self.startTime)] forKey:@"scan_duration_ms"];
    
    switch (self.controllerType) {
        case ALScanHistoryGasMeter:
        case ALScanHistoryAnalogMeter:
        case ALScanHistoryDigitalMeter:
        case ALScanHistoryElectricMeter:
        case ALScanHistoryWaterMeter:
        case ALScanHistoryHeatMeter:
        case ALScanHistoryDialMeter:
            break;
        case ALScanHistoryLicensePlates:
            break;
        case ALScanHistoryNone:
        default:
            [attributes setObject:what forKey:@"use_case"];
            break;
    }
    
    self.startTime = finishedTime;
    
    [NSUserDefaults AL_incrementScanCount];

    NSError *error;
    [ScanHistory insertNewObjectWithType:self.controllerType
                                  result:result
                           barcodeResult:barcodeResult
                               faceImage:faceImage
                                  images:images
                  inManagedObjectContext:self.managedObjectContext
                                   error:&error];
#ifdef IS_SHOWCASE_APP
    NSInteger scanCount = [NSUserDefaults AL_scanCount];
    [self showAwardIfScanCount:scanCount
                    scanPlugin:scanPlugin
                    viewPlugin:viewPlugin
                    completion:completion];
#else
    completion();
#endif
}

- (void)showAwardIfScanCount:(NSInteger)scanCount
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALViewPluginBase>)viewPlugin
                  completion:(void (^)(void))completion {
    
    ALAwardType awardType;
    switch (scanCount) {
        case 1: awardType = ALAwardType1; break;
        case 10: awardType = ALAwardType10; break;
        case 30: awardType = ALAwardType30; break;
        case 50: awardType = ALAwardType50; break;
        case 80: awardType = ALAwardType80; break;
        case 100: awardType = ALAwardType100; break;
        default:
            if (completion) {
                completion();
            }
            return;
    }
    
    // [ALReportingController logEventArchivement:awardType];
    
    BOOL restart = NO;
    if (scanPlugin.isRunning) {
        [viewPlugin stop];
        restart = YES;
    }
    
    ALAwardsView *awards = [[ALAwardsView alloc] initWithFrame:CGRectZero];
    
    awards.awardType = awardType;
    __weak id<ALViewPluginBase> wViewPlugin = viewPlugin;
    __weak ALAwardsView *wawards = awards;
    __weak typeof(self) welf = self;
    [awards setTouchDownBlock:^{
        // Remove the view when touched and restart scanning
        if (restart) {
            [wViewPlugin startWithError:nil];
            welf.startTime = CACurrentMediaTime();
        }
        
        [wawards removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
    
    [self.view addSubview:awards];
    
    awards.translatesAutoresizingMaskIntoConstraints = NO;
    [awards.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [awards.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    [awards.widthAnchor constraintEqualToConstant:300].active = YES;
    [awards.heightAnchor constraintEqualToConstant:200].active = YES;
}

- (NSString *)addon {
    return nil;
}

- (CGRect)scanViewFrame {
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat navbarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    navbarHeight = MAX(0, navbarHeight);
    frame = CGRectMake(frame.origin.x, frame.origin.y,
                       frame.size.width, frame.size.height - navbarHeight);
    return frame;
}

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <UIAlertAction *>*)actions {
    UIAlertController *sender = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        if ([action isKindOfClass:[UIAlertAction class]]) {
            [sender addAction:action];
        }
    }
    [self presentViewController:sender animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
        if (completion != nil) {
            completion();
        }
    }];
    [alertController addAction:dismissAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertForError:(NSError * _Nonnull)error
           dismissHandler:(void (^ _Nullable)(void))dismissHandler {
    [self showAlertForError:error completion:nil dismissHandler:dismissHandler];
}

- (void)showAlertForError:(NSError * _Nonnull)error
               completion:(void (^ _Nullable)(void))completion
           dismissHandler:(void (^ _Nullable)(void))dismissHandler {
    
    // sometimes this alert will show, sometimes the slightly-less-friendly one
    // from the SDK will show instead.
    
    NSString *errorTitle = @"Could not start scanning";
    NSString *errorMessage = error.localizedDescription;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
        if (dismissHandler != nil) {
            dismissHandler();
        }
    }]];
    
    if (error.code == ALCameraAccessDenied) {
        // offer an additional action to open Settings and allow camera access for the app
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            NSURL *settingsURL = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
            if (settingsURL) {
                [[UIApplication sharedApplication] openURL:settingsURL options:@{}
                                         completionHandler:^(BOOL success) {
                    if (dismissHandler != nil) {
                        dismissHandler();
                    }
                }];
            }
        }]];
        
        alert.message = [NSString stringWithFormat:@"%@\n\n%@",
                         errorMessage,
                         kMsgAllowCameraAccessInSettings];
    }
    
    [self.navigationController presentViewController:alert animated:YES completion:^{
        if (completion != nil) {
            completion();
        }
    }];
}

- (BOOL)popWithAlertOnError:(NSError *)error {
    if (error) {
        __weak __block typeof(self) weakSelf = self;
        [self showAlertForError:error dismissHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        return YES;
    }
    return NO;
}


// MARK: - Change to Landscape Orientation

- (void)flipOrientationPressed:(id)sender {
    self.isOrientationFlipped = !self.isOrientationFlipped;
    [self enableLandscapeOrientation:self.isOrientationFlipped];
}

- (void)enableLandscapeOrientation:(BOOL)isLandscape {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.enableLandscapeRight = isLandscape;
    if (@available(iOS 16, *)) {
        UIInterfaceOrientationMask orientationMask = isLandscape ? UIInterfaceOrientationMaskLandscapeRight: UIInterfaceOrientationMaskPortrait;
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        for (UIWindow *window in windowScene.windows) {
            [window.rootViewController setNeedsUpdateOfSupportedInterfaceOrientations];
        }
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientationMask];
        [windowScene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:nil];
    } else {
        NSNumber *value = [NSNumber numberWithInt:(isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)setupFlipOrientationButton {
    UIButton *flipOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (flipOrientationBtn) {
        [flipOrientationBtn addTarget:self
                                       action:@selector(flipOrientationPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
        
        flipOrientationBtn.frame = CGRectMake(0, 0, 50, 50);
        UIImage *buttonImage = [UIImage imageNamed:@"rotate_screen_white"];
        [flipOrientationBtn setImage:buttonImage forState:UIControlStateNormal];
        flipOrientationBtn.imageView.tintColor = UIColor.whiteColor;
        [flipOrientationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        flipOrientationBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        flipOrientationBtn.adjustsImageWhenDisabled = NO;
        
        [flipOrientationBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:flipOrientationBtn];
        flipOrientationBtn.layer.cornerRadius = 25;
        flipOrientationBtn.backgroundColor = [[UIColor AL_Black] colorWithAlphaComponent:0.85];
        self.isOrientationFlipped = false;
        
        NSArray *flipConstraints = @[[flipOrientationBtn.widthAnchor constraintEqualToConstant:50],
                                     [flipOrientationBtn.heightAnchor constraintEqualToConstant:50],
                                     [flipOrientationBtn.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-10],
                                     [flipOrientationBtn.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]];
        
        [self.view addConstraints:flipConstraints];
        [NSLayoutConstraint activateConstraints:flipConstraints];
        self.flipOrientationButton = flipOrientationBtn;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
}

- (void)setColors {
    // override
}

- (BOOL)isDarkMode {
    BOOL isDarkMode = NO;
    if (@available(iOS 13.0, *)) {
        isDarkMode = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    }
    return isDarkMode;
}

// MARK: - ALScanViewPluginDelegate

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin brightnessUpdated:(ALEvent *)event {
    // APP-412: Disable the brightness feedback
//    NSInteger value = [[event.JSONObject valueForKey:@"value"] intValue];
//    // NSLog(@"ACO: brightness value: %ld", value);
//    if (value < 30) {
//        [self updateScanWarnings:ALWarningStateTooDark];
//    } else if (value > 240) {
//        [self updateScanWarnings:ALWarningStateTooBright];
//    }
}

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin visualFeedbackReceived:(ALEvent *)event {
    // NSLog(@"ACO visual feedback received: %@", event.JSONStr);
    // [self updateScanWarnings:ALWarningStateNone];
}

- (void)scanViewPluginResultBeepTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPluginResultBlinkTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPluginResultVibrateTriggered:(ALScanViewPlugin *)scanViewPlugin {

}

- (void)scanViewPlugin:(ALScanViewPlugin *)scanViewPlugin cutoutVisibilityChanged:(ALEvent *)event {
    // NSLog(@"ACO cutout visibility changed: %@", event.JSONStr);
    // ACO TODO: maybe include the cutout coordinates in scan view coordinate space.
}


// MARK: - ALScanViewDelegate

- (void)scanViewMotionExceededThreshold:(ALScanView *)scanView {
    // APP-412: Disable the motion feedback
    // [self updateScanWarnings:ALWarningStateHoldStill];
}

- (void)scanView:(ALScanView *)scanView updatedCutoutWithPluginID:(NSString *)pluginID frame:(CGRect)frame {
    // APP-410: disable the warning label. We may want to bring this back again, but if we do, make sure
    // to check if the view is allowing the flash toggle button to be accessed while on landscape.
    // [self addWarningSubviewIfNeededToScanView:scanView cutoutFrame:frame];
}

- (void)scanView:(ALScanView *)scanView encounteredError:(NSError *)error {
    NSLog(@"stopping scan view, error encountered: %@", error.localizedDescription);
    [self popWithAlertOnError:error];
    [self.scanView stopCamera];
    [self stopScanning];
}

@end
