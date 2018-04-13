//
//  ALLicensePlateViewController.m
//  AnylineExamples
//
//  Created by Matthias Gasser on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALLicensePlateViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALLicensePlateResultOverlayView.h"
#import "ALAppDemoLicenses.h"

#import "Anyline/AnylineLicensePlateModuleView.h"


// This is the license key for the examples project used to set up Aynline below
NSString * const kLicensePlateLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALLicensePlateViewController ()<AnylineLicensePlateModuleDelegate, AnylineDebugDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineLicensePlateModuleView *licensePlateModuleView;

@end

@implementation ALLicensePlateViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"License Plate";
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.licensePlateModuleView = [[AnylineLicensePlateModuleView alloc] initWithFrame:frame];
    
    [self.licensePlateModuleView setupAsyncWithLicenseKey:kDemoAppLicenseKey delegate:self finished:^(BOOL success, NSError * _Nullable error) {
        // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
        // we have to check the error object for the error message.
        if (!success) {
            // Something went wrong. The error object contains the error description
            NSAssert(success, @"Setup Error: %@", error.debugDescription);
        }
    }];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"license_plate_view_config" ofType:@"json"];
    ALUIConfiguration *lptConf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.licensePlateModuleView.currentConfiguration = lptConf;
    
    self.controllerType = ALScanHistoryLicensePlates;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.licensePlateModuleView];
    [self.view sendSubviewToBack:self.licensePlateModuleView];
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

- (void)viewDidLayoutSubviews {
    [self updateWarningPosition:
     self.licensePlateModuleView.cutoutRect.origin.y +
     self.licensePlateModuleView.cutoutRect.size.height +
     self.licensePlateModuleView.frame.origin.y +
     90];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.licensePlateModuleView cancelScanningAndReturnError:nil];
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
    BOOL success = [self.licensePlateModuleView startScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
    
    self.startTime = CACurrentMediaTime();
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */

- (void)anylineLicensePlateModuleView:(AnylineLicensePlateModuleView *)anylineLicensePlateModuleView
                        didFindResult:(ALLicensePlateResult *)scanResult {
    
    //build a string with country+result for the ScanHistory model -- if country==nil only take result
    NSString *formattedScanResult = (scanResult.country.length) ? [NSString stringWithFormat:@"%@-%@", scanResult.country, scanResult.result] : scanResult.result;
    [self anylineDidFindResult:formattedScanResult barcodeResult:@"" image:scanResult.image module:anylineLicensePlateModuleView completion:^{
        // Display an overlay showing the result
    	UIImage *image = [UIImage imageNamed:@"license_plate_background"];
    	
        ALLicensePlateResultOverlayView *overlay = [[ALLicensePlateResultOverlayView alloc] initWithFrame:self.view.bounds];
    	[overlay setImage:image];
        [overlay setCountryCode:scanResult.country];
        [overlay setText:scanResult.result];
    
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

@end
