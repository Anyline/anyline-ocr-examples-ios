//
//  ALLicensePlateViewController.m
//  AnylineExamples
//
//  Created by Matthias Gasser on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALLicensePlateViewController.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"
#import "Anyline/ALMeterScanPlugin.h"
#import "Anyline/ALMeterScanViewPlugin.h"

//#import "Anyline/AnylineLicensePlateModuleView.h"


// This is the license key for the examples project used to set up Aynline below
NSString * const kLicensePlateLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALLicensePlateViewController ()<ALLicensePlateScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) ALLicensePlateScanViewPlugin *licensePlateScanViewPlugin;
@property (nonatomic, strong) ALLicensePlateScanPlugin *licensePlateScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

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

    NSError *error = nil;
    
    self.licensePlateScanPlugin = [[ALLicensePlateScanPlugin alloc] initWithPluginID:@"LICENSE_PLATE" licenseKey:kDemoAppLicenseKey delegate:self error:&error];
    NSAssert(self.licensePlateScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.licensePlateScanPlugin addInfoDelegate:self];
    
    
    //Set a delayed scan start time in the scanViewPluginConfig
    ALScanViewPluginConfig *viewPluginConfig = [ALScanViewPluginConfig defaultLicensePlateConfig];
    viewPluginConfig.delayStartScanTime = 2000;
    
    
    self.licensePlateScanViewPlugin = [[ALLicensePlateScanViewPlugin alloc] initWithScanPlugin:self.licensePlateScanPlugin scanViewPluginConfig:viewPluginConfig];
    NSAssert(self.licensePlateScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.licensePlateScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.licensePlateScanViewPlugin];
    
    self.controllerType = ALScanHistoryLicensePlates;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    // Enable zoom gesture for scanView
    [self.scanView enableZoomPinchGesture:true];
    
    //Start Camera:
    [self.scanView startCamera];
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
    [self.licensePlateScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.licensePlateScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */

- (void)anylineLicensePlateScanPlugin:(ALLicensePlateScanPlugin *)anylineLicensePlateScanPlugin
                        didFindResult:(ALLicensePlateResult *)result {
    //build a string with country+result for the ScanHistory model -- if country==nil only take result
    NSString *formattedScanResult = (result.country.length) ? [NSString stringWithFormat:@"%@-%@", result.country, result.result] : result.result;
    [self anylineDidFindResult:formattedScanResult barcodeResult:@"" image:result.image scanPlugin:anylineLicensePlateScanPlugin viewPlugin:self.licensePlateScanViewPlugin completion:^{
        //Display the result
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"License Plate" value:result.result]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Country" value:result.country]];
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
