//
//  ALBadgeScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 11/12/17.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALBadgeScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kBadgeScannerLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALBadgeScanViewController ()<AnylineOCRModuleDelegate, AnylineDebugDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;

@end

@implementation ALBadgeScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Badge Scanner";
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.ocrModuleView = [[AnylineOCRModuleView alloc] initWithFrame:frame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    NSString *anylineTraineddata = [[NSBundle mainBundle] pathForResource:@"anyline_capitals" ofType:@"traineddata"];
    config.languages = @[anylineTraineddata];
    config.charWhiteList = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    config.validationRegex = @"[A-Z]{1}[0-9]{4}$";
    config.minConfidence = 80;
    config.scanMode = ALGrid;
    config.charCountX = 5;
    config.charCountY = 1;
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.ocrModuleView setupWithLicenseKey:kBadgeScannerLicenseKey
                                                  delegate:self
                                                 ocrConfig:config
                                                     error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    [self.ocrModuleView enableReporting:[NSUserDefaults AL_reportingEnabled]];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"badge_scanner_config" ofType:@"json"];
    ALUIConfiguration *ibanConf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.ocrModuleView.currentConfiguration = ibanConf;
    
    self.controllerType = ALScanHistoryBadge;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.ocrModuleView];
    [self.view sendSubviewToBack:self.ocrModuleView];
    [self startListeningForMotion];

}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self startAnyline];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.ocrModuleView cancelScanningAndReturnError:nil];
}

- (void)viewDidLayoutSubviews {
    [self updateWarningPosition:
     self.ocrModuleView.cutoutRect.origin.y +
     self.ocrModuleView.cutoutRect.size.height +
     self.ocrModuleView.frame.origin.y +
     90];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    NSError *error;
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
    
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.ocrModuleView.isRunning) {
        [self.ocrModuleView cancelScanningAndReturnError:nil];
    }
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
               didFindResult:(ALOCRResult *)result {
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image module:anylineOCRModuleView completion:^{
        [self stopAnyline];
        // Display an overlay showing the result
        
        //TODO: Find new image for result
        UIImage *image = [UIImage imageNamed:@"gift_card_background"];
        ALResultOverlayView *overlay = [[ALResultOverlayView alloc] initWithFrame:self.view.bounds];
        [overlay setImage:image];
        [overlay setText:result.result];
        __weak typeof(self) welf = self;
        __weak ALResultOverlayView *woverlay = overlay;
        [overlay setTouchDownBlock:^{
            // Remove the view when touched and restart scanning
            [welf startAnyline];
            [woverlay removeFromSuperview];
        }];
        [self.view addSubview:overlay];
    }];
}

- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
             reportsVariable:(NSString *)variableName
                       value:(id)value {
    if ([variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[value floatValue] forModule:self.ocrModuleView ignoreTooDark:YES];
    }
}

- (void)anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView
               runSkipped:(ALRunFailure)runFailure {
    switch (runFailure) {
        case ALRunFailureResultNotValid:
            break;
        case ALRunFailureConfidenceNotReached:
            break;
        case ALRunFailureNoLinesFound:
            break;
        case ALRunFailureNoTextFound:
            break;
        case ALRunFailureUnkown:
            break;
        default:
            break;
    }
}

@end
