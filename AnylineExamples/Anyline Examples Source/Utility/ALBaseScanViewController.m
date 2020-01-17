//
//  ALBaseScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 24/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBaseScanViewController.h"

#import "ALHistoryTableViewController.h"
#import "ALWarningView.h"
#import "ScanHistory.h"
#import "NSUserDefaults+ALExamplesAdditions.h"

#import "ALAwardsView.h"

#import <QuartzCore/QuartzCore.h>

@import CoreMotion;

@interface ALBaseScanViewController ()
@property (nonatomic, strong) ALWarningView * warningView;
@property (nonatomic, strong) NSTimer * animationTimer;
@property (nonatomic, strong) CMMotionManager * motionManager;

@property (nonatomic, assign) BOOL successfulScan;

@end

@implementation ALBaseScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successfulScan = NO;
    
    ALWarningView * warningView = [[ALWarningView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    warningView.center = CGPointMake(self.view.center.x, 0);
    self.warningView = warningView;
    [self.view addSubview:warningView];
    self.warningView.alpha = 0;    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.startTime = CACurrentMediaTime();
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

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)startPlugin:(ALAbstractScanViewPlugin *)plugin {
    NSError *error;
    BOOL success = [plugin startAndReturnError:&error];
    if( !success ) {
        //this alert does not actually show, because the SDK shows its own alert, but eventually we should be able to silence those.
        [self showAlertWithTitle:@"Could not start scanning" message:error.localizedDescription];
    }
}

- (void)dealloc {
    [self.motionManager stopDeviceMotionUpdates];
}

- (CGRect)scanViewFrame {
    CGRect frame = [[UIScreen mainScreen] bounds];
      frame = CGRectMake(frame.origin.x, frame.origin.y + CGRectGetMaxY(self.navigationController.navigationBar.frame), frame.size.width, frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    return frame;
}

@end
