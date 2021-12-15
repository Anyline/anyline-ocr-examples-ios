//
//  ALBaseScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBaseScanViewController.h"
#import "ALAwardsView.h"
#import "ALWarningView.h"
#import "ScanHistory+CoreDataClass.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import <QuartzCore/QuartzCore.h>

@import CoreMotion;

@interface ALBaseScanViewController ()

@property (nonatomic, strong) ALWarningView * warningView;
@property (nonatomic, strong) NSTimer * animationTimer;
@property (nonatomic, strong) CMMotionManager * motionManager;
@property (nonatomic, assign) BOOL successfulScan;

@end

NSString * const kMsgAllowCameraAccessInSettings = @"Please allow Anyline Scanner to access \
the camera from Settings.";

@implementation ALBaseScanViewController

- (void)dealloc {
    [self.motionManager stopDeviceMotionUpdates];
    
    @try {
        [[ALErrorManager sharedInstance] removeObserver:self forKeyPath:@"error"];
    } @catch (NSException * __unused exception) {}
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = (title && title.length > 0) ? title : @"";
        
        [[ALErrorManager sharedInstance] addObserver:self forKeyPath:@"error"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successfulScan = NO;
    
    ALWarningView * warningView = [[ALWarningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    warningView.center = CGPointMake(self.view.center.x, 0);
    self.warningView = warningView;
    [self.view addSubview:warningView];
    self.warningView.alpha = 0;    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.startTime = CACurrentMediaTime();
}

- (NSString *)jsonStringFromResultData:(NSArray*)resultData {
    return @"";
}

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule; {
    [self updateBrightness:brightness forModule:anylineModule ignoreTooDark:NO];
}

- (void)updateBrightness:(CGFloat)brightness forModule:(id)anylineModule ignoreTooDark:(BOOL)ignoreTooDark {
    if([anylineModule isKindOfClass:[ALOCRScanViewPlugin class]]) {
        if( brightness < 40 && !ignoreTooDark) {
            [self updateScanWarnings:ALWarningStateTooDark];
        } else if (brightness > 200) {
            [self updateScanWarnings:ALWarningStateTooBright];
        }
    }
}



- (void)startListeningForMotion {
    __weak __block typeof(self) welf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CMMotionManager * motionManager = [[CMMotionManager alloc] init];
        motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                           withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                               CGFloat threshold = 0.05;
                                               if( fabs(motion.userAcceleration.x) > threshold ||
                                                   fabs(motion.userAcceleration.y) > threshold) {
                                                   [welf updateScanWarnings:ALWarningStateHoldStill];
                                               }
                                           }];
        welf.motionManager = motionManager;
    });
}

- (void)updateScanWarnings:(ALWarningState)warningState {
    [self.warningView showWarning:warningState];
}

- (void)updateWarningPosition:(CGFloat)newPosition {
    self.warningView.center = CGPointMake(self.warningView.center.x, newPosition);
}

- (void)anylineDidFindResult:(NSString *)result
               barcodeResult:(NSString *)barcodeResult
                       image:(UIImage *)image
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion {
    self.successfulScan = YES;
    if (completion){
        completion();
    }
    
}

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                      images:(NSArray*)images
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion {
    [self anylineDidFindResult:result barcodeResult:barcodeResult faceImage:nil images:images scanPlugin:scanPlugin viewPlugin:viewPlugin completion:completion];
}

- (void)anylineDidFindResult:(NSString*)result
               barcodeResult:(NSString *)barcodeResult
                   faceImage:(UIImage*)faceImage
                      images:(NSArray*)images
                  scanPlugin:(ALAbstractScanPlugin *)scanPlugin
                  viewPlugin:(ALAbstractScanViewPlugin *)viewPlugin
                  completion:(void (^)(void))completion {
    self.successfulScan = YES;
    if (completion){
        completion();
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message completion:nil];
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

- (void)showAlertForScanningError:(NSError * _Nonnull)error
                       completion:(void (^ _Nullable)(void))completion
                   dismissHandler:(void (^ _Nullable)(void))dismissHandler {

    // sometimes this alert will show, sometimes the slightly-less-friendly one
    // from the SDK will show instead.

    NSString *errorTitle = @"Could not start scanning";
    NSString *errorMessage = error.localizedDescription;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
        if (dismissHandler != nil) {
            dismissHandler();
        }
    }]];
    if (error.code == ALCameraAccessDenied) {
        // offer an additional action to open Settings and allow camera access for the app
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault
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

- (void)startPlugin:(ALAbstractScanViewPlugin *)plugin {
    NSError *error;
    BOOL success = [plugin startAndReturnError:&error];
    if (!success) {
        __weak __block typeof(self) weakSelf = self;
        [self showAlertForScanningError:error completion:nil dismissHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (CGRect)scanViewFrame {
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat navbarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    navbarHeight = MAX(navbarHeight, 0);
    return CGRectMake(frame.origin.x, frame.origin.y + navbarHeight,
                      frame.size.width, frame.size.height - navbarHeight);
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    // Catch any errors 'added' during run time, when plugin is already running
    // (as the start call is not allowed to block; common cases arise when asynchronously
    // denying access to a camera permission request)
    if ([keyPath isEqualToString:@"error"]) {
        // IMPORTANT: Do not use this space to display an error alert. The two places where
        // an alert would have be shown are at the following:
        //
        // 1) synchronously (for SDK consumers like the demo app) - using the NSError object
        // obtained right after returning from `-[scanViewPlugin startAndReturnError:]`;
        // 2) asynchronously (within the SDK) - happens after startup e.g. when user denies
        // camera access request prompt
        //
        // You shouldn't stop the running plugin here either, as the SDK will have taken
        // care of it already.
        NSError *error = [[ALErrorManager sharedInstance] error];
        if (error && ![error.userInfo[@"cached"] isEqual:@(YES)]) {
            // We only do this part here because we believe an SDK-based alert error is also
            // being shown at this point; and that the SDK shouldn't provide this
            // behavior, for obvious reasons.
            __weak __block typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

@end
