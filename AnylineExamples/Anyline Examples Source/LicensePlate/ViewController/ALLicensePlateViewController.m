//
//  ALLicensePlateViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 09/10/17.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALLicensePlateViewController.h"
#import <Anyline/Anyline.h>
#import "ALLicensePlateResultOverlayView.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kLicensePlateLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineLicensePlateModuleDelegate> to be able to receive results
@interface ALLicensePlateViewController ()<AnylineLicensePlateModuleDelegate>
// The Anyline module used for LicensePlate
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
    self.title = @"License Plates";
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.licensePlateModuleView = [[AnylineLicensePlateModuleView alloc] initWithFrame:frame];

    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.licensePlateModuleView setupWithLicenseKey:kLicensePlateLicenseKey
                                                           delegate:self
                                                              error:&error];
    
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    //Set UI Config via JSON file
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"license_plate_view_config" ofType:@"json"];
    ALUIConfiguration *conf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    [self.licensePlateModuleView setCurrentConfiguration:conf];
    
    //With this method you can enable/disable the reporting - depending on your license type
    [self.licensePlateModuleView enableReporting:YES];
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.licensePlateModuleView];
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
}

#pragma mark -- AnylineLicensePlateModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */

- (void)anylineLicensePlateModuleView:(AnylineLicensePlateModuleView *)anylineLicensePlateModuleView
                        didFindResult:(ALLicensePlateResult *)scanResult {
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
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.licensePlateModuleView startScanningAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
