//
//  ALScrabbleScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALScrabbleScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALScrabbleViewController.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kScrabbleLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALScrabbleScanViewController ()<AnylineOCRModuleDelegate, AnylineDebugDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;

@end

@implementation ALScrabbleScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Scrabble";
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.ocrModuleView = [[AnylineOCRModuleView alloc] initWithFrame:frame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALAuto;
    config.tesseractLanguages = @[@"scrabble"];
    config.charWhiteList = @"ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ";
    config.validationRegex = @"^[A-ZÄÜÖ]{7,10}$";

    
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.ocrModuleView setupWithLicenseKey:kScrabbleLicenseKey
                                                  delegate:self
                                                 ocrConfig:config
                                                     error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"scrabble_config" ofType:@"json"];
    ALUIConfiguration *ibanConf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.ocrModuleView.currentConfiguration = ibanConf;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.ocrModuleView];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    // We use a postdelay for 'start scanning' to improve the user experience:
    // otherwise the scrabble result would be shown faster as the user realizes the scanning
    // process has already started
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnyline];
    });

}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.ocrModuleView cancelScanningAndReturnError:nil];
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
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
               didFindResult:(ALOCRResult *)result {
    ALScrabbleViewController *vc = [[ALScrabbleViewController alloc] init];
    [vc setScrabbleWord:(NSString *)result.result];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
             reportsVariable:(NSString *)variableName
                       value:(id)value {
    
}

-(void) anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView runSkipped:(ALRunFailure)runFailure {
    
    switch (runFailure) {
        case ALRunFailureResultNotValid:
            break;
        case ALRunFailureSharpnessNotReached:
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
