#import "ALBaseScanViewController.h"
#import "ALWarningView.h"
#import "ScanHistory+CoreDataClass.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAwardsView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

#if __has_include("AppDelegate_store.h")
    #import "AppDelegate_store.h"
#else
    #import "AppDelegate.h"
#endif

NSString * const kMsgAllowCameraAccessInSettings = @"Please allow Anyline Scanner to access \
the camera from Settings.";

@interface ALBaseScanViewController ()

@property (nonatomic, strong) ALWarningView *warningView;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) BOOL successfulScan;

@end

@implementation ALBaseScanViewController

- (void)dealloc {
    if (!self.successfulScan) {
//        NSString *what = ALScanHistoryType_toString[self.controllerType];
//        NSString *addon = [self addon];
//        if (addon) {
//            what = [NSString stringWithFormat:@"%@ %@",what,addon];
//        }
//        if (what) {
//            CFTimeInterval finishedTime = CACurrentMediaTime();
//            //Only log event 'Not scanned'. Do not add controller type as event.
//            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
//            [attributes setObject:[NSNumber numberWithDouble:(finishedTime-self.startTime)] forKey:@"scan_duration_ms"];
//            [attributes setObject:what forKey:@"scan_mode"];
//            [ALReportingController logEventNotScannedWithMetaData:attributes];
//        } else {
//            NSLog(@"Unknown controller type: %lu",(unsigned long)self.controllerType);
//        }
    }
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
    [self addWarningSubview];
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
    [self enableLandscapeOrientation:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.warningView];
}


- (NSString *)configJSONStrWithFilename:(NSString *)filename {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:filename
                                                             ofType:@"json"];

    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];

    return configStr;
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

- (void)addWarningSubview {
    ALWarningView *warningView = [[ALWarningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    warningView.center = CGPointMake(self.view.center.x, 0);
    
    self.warningView = warningView;
    [self.view addSubview:warningView];
    self.warningView.alpha = 0;
}

//- (NSString *)JSONStringFromResultData:(NSArray <ALResultEntry *> *)inputArray {
//
//    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:inputArray.count];
//    for (ALResultEntry *entry in inputArray) {
//        [array addObject:[entry toDictionary]];
//    }
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:array forKey:@"result"];
//
//    NSError *jsonError;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonError];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//    return jsonString;
//}

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule; {
    [self updateBrightness:brightness forModule:anylineModule ignoreTooDark:NO];
}

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark {
//    if([anylineModule isKindOfClass:[ALOCRScanViewPlugin class]]) {
//        if( brightness < 40 && !ignoreTooDark) {
//            [self updateScanWarnings:ALWarningStateTooDark];
//        } else if (brightness > 200) {
//            [self updateScanWarnings:ALWarningStateTooBright];
//        }
//    }
}

- (void)updateScanWarnings:(ALWarningState)warningState {
    [self.warningView showWarning:warningState];
}

// MARK: - anylineDidFindResult

- (void)anylineDidFindResult:(NSString *)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage *)image
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
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
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
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
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
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
            // [ALReportingController logEventScanned:what metaData:attributes];
            break;
        case ALScanHistoryLicensePlates:
            // [ALReportingController logEventScanned:what metaData:attributes];
            break;
        case ALScanHistoryNone:
        default:
            [attributes setObject:what forKey:@"use_case"];
            // [ALReportingController logEventScanned:@"ocr" metaData:attributes];
            break;
    }

    self.startTime = finishedTime;

    [NSUserDefaults AL_incrementScanCount];
    NSInteger scanCount = [NSUserDefaults AL_scanCount];

    // [ALReportingController logEventUpdateScanCount:scanCount]; // should we disable this?

    NSError *error;
    [ScanHistory insertNewObjectWithType:self.controllerType
                                  result:result
                           barcodeResult:barcodeResult
                               faceImage:faceImage
                                  images:images
                  inManagedObjectContext:self.managedObjectContext
                                   error:&error];

    [self showAwardIfScanCount:scanCount
                    scanPlugin:scanPlugin
                    viewPlugin:viewPlugin
                    completion:completion];
}

- (void)showAwardIfScanCount:(NSInteger)scanCount
                  scanPlugin:(ALScanPlugin *)scanPlugin
                  viewPlugin:(id<ALScanViewPluginBase>)viewPlugin
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

    ALAwardsView *awards = [[ALAwardsView alloc] initWithFrame:self.view.bounds];
    awards.awardType = awardType;
    // __weak ALScanPlugin *wScanPlugin = scanPlugin;
    __weak id<ALScanViewPluginBase> wViewPlugin = viewPlugin;
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
    NSNumber *value = [NSNumber numberWithInt:(isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait)];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)setupFlipOrientationButton {
    self.flipOrientationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flipOrientationButton addTarget:self
                                   action:@selector(flipOrientationPressed:)
                         forControlEvents:UIControlEventTouchUpInside];

    self.flipOrientationButton.frame = CGRectMake(0, 0, 220, 50);
    UIImage *buttonImage = [UIImage imageNamed:@"baseline_screen_rotation_white_24pt"];
    [self.flipOrientationButton setImage:buttonImage forState:UIControlStateNormal];
    self.flipOrientationButton.imageView.tintColor = UIColor.whiteColor;
    [self.flipOrientationButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
    self.flipOrientationButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.flipOrientationButton.adjustsImageWhenDisabled = NO;

    [self.flipOrientationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5.0, 0.0, 5.0)];
    [self.flipOrientationButton setTitle:@"Change Screen Orientation" forState:UIControlStateNormal];
    self.flipOrientationButton.titleLabel.font = [UIFont AL_proximaRegularWithSize:14];

    [self.flipOrientationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.flipOrientationButton];
    self.flipOrientationButton.layer.cornerRadius = 3;
    self.flipOrientationButton.backgroundColor = [[UIColor AL_examplesBlue] colorWithAlphaComponent:0.85];
    self.isOrientationFlipped = false;

    NSArray *flipConstraints = @[[self.flipOrientationButton.widthAnchor constraintEqualToConstant:220],
                                 [self.flipOrientationButton.heightAnchor constraintEqualToConstant:50],
                                 [self.flipOrientationButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
                                 [self.flipOrientationButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:0]];

    [self.view addConstraints:flipConstraints];
    [NSLayoutConstraint activateConstraints:flipConstraints];
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

// MARK: - ALScanViewDelegate

- (void)scanViewMotionExceededThreshold:(ALScanView *)scanView {
    [self updateScanWarnings:ALWarningStateHoldStill];
}

- (void)scanView:(ALScanView *)scanView updatedCutoutWithPluginID:(NSString *)pluginID frame:(CGRect)frame {
    CGFloat xPos = (frame.origin.x + (frame.size.width/2));
    CGFloat yPos = frame.origin.y + frame.size.height + scanView.frame.origin.y + 80;
    if (_isOrientationFlipped) {
        yPos = frame.origin.y;
    }
    self.warningView.center = CGPointMake(xPos, yPos);
}

- (void)scanView:(ALScanView *)scanView encounteredError:(NSError *)error {
    NSLog(@"stopping scan view, error encountered: %@", error.localizedDescription);
    [self popWithAlertOnError:error];
    [self.scanView stopCamera];
    [self.scanView.scanViewPlugin stop];
}

@end
