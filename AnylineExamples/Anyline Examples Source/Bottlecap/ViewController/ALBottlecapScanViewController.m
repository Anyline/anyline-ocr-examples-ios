//
//  ALBottleCapScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALBottlecapScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kBottlecapLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALBottlecapScanViewController ()<AnylineOCRModuleDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;

@end

@implementation ALBottlecapScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Bottlecap";
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.ocrModuleView = [[AnylineOCRModuleView alloc] initWithFrame:frame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALGrid;
    config.charHeight = ALRangeMake(21, 97);
    config.tesseractLanguages = @[@"bottlecap"];
    config.charWhiteList = @"123456789ABCDEFGHJKLMNPRSTUVWXYZ";
    config.minConfidence = 75;
    config.validationRegex = @"^[0-9A-Z]{3}\n[0-9A-Z]{3}\n[0-9A-Z]{3}";
    
    config.charCountX = 3;
    config.charCountY = 3;
    config.charPaddingXFactor = 0.3;
    config.charPaddingYFactor = 0.5;
    config.isBrightTextOnDark = YES;
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.ocrModuleView setupWithLicenseKey:kBottlecapLicenseKey
                                                  delegate:self
                                                 ocrConfig:config
                                                     error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"bottlecap_config" ofType:@"json"];
    ALUIConfiguration *bottlecapConfig = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.ocrModuleView.currentConfiguration = bottlecapConfig;
    
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
    [self startAnyline];
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
    // Display an overlay showing the result
    UIImage *image = [UIImage imageNamed:@"bottle_background"];
    ALResultOverlayView *overlay = [[ALResultOverlayView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) welf = self;
    __weak ALResultOverlayView * woverlay = overlay;
    [overlay setImage:image];
    [overlay setText:result.text];
    [overlay setTouchDownBlock:^{
        // Remove the view when touched and restart scanning
        [welf startAnyline];
        [woverlay removeFromSuperview];
    }];
    [self.view addSubview:overlay];
}

- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
             reportsVariable:(NSString *)variableName
                       value:(id)value {
    
}

- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
           reportsRunFailure:(ALOCRError)error {
    switch (error) {
        case ALOCRErrorResultNotValid:
            break;
        case ALOCRErrorConfidenceNotReached:
            break;
        case ALOCRErrorNoLinesFound:
            break;
        case ALOCRErrorNoTextFound:
            break;
        case ALOCRErrorUnkown:
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
