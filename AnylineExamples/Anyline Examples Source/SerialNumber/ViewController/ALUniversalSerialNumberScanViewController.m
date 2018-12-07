//
//  ALUniversalSerialNumberScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Mueller on 24/11/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//


#import "ALUniversalSerialNumberScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALBaseViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kUniversalSerialNumberScanLicenseKey = kDemoAppLicenseKey;

static const NSInteger padding = 7;

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALUniversalSerialNumberScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *serialNumberScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *serialNumberScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALUniversalSerialNumberScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Universal Serial Number";
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALAuto;
    
    NSString *serialNumberAny = [[NSBundle mainBundle] pathForResource:@"USNr" ofType:@"any"];
    [config setLanguages:@[serialNumberAny] error:nil];
    
    config.validationRegex = @"[A-Z0-9]{4,}";
    
    NSError *error = nil;
    
    self.serialNumberScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                                 licenseKey:kUniversalSerialNumberScanLicenseKey
                                                                   delegate:self
                                                                  ocrConfig:config
                                                                      error:&error];
    NSAssert(self.serialNumberScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.serialNumberScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"serial_number_view_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.serialNumberScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.serialNumberScanPlugin
                                                                 scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.serialNumberScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.serialNumberScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.serialNumberScanViewPlugin];
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistorySerial;
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
    [self.serialNumberScanViewPlugin stopAndReturnError:nil];
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
    BOOL success = [self.serialNumberScanViewPlugin startAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
    
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
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin
               didFindResult:(ALOCRResult *)result {
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.serialNumberScanViewPlugin completion:^{
        //Display the result
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Universal Serial Number" value:result.result]];
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.serialNumberScanViewPlugin];
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
