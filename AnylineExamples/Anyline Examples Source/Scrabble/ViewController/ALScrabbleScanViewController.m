//
//  ALScrabbleScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALScrabbleScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALScrabbleViewController.h"
#import "ALCustomBarButton.h"
#import "ScanHistory.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kScrabbleLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALScrabbleScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *scrabbleScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *scrabbleScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

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
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALAuto;
    NSString *anylineTraineddata = [[NSBundle mainBundle] pathForResource:@"scrabble" ofType:@"traineddata"];
    [config setLanguages:@[anylineTraineddata] error:nil];
    config.charWhiteList = @"ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ";
    config.validationRegex = @"^[A-ZÄÜÖ]{7,10}$";
    
    NSError *error = nil;
    
    self.scrabbleScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                             licenseKey:kScrabbleLicenseKey
                                                               delegate:self
                                                              ocrConfig:config
                                                                  error:&error];
    NSAssert(self.scrabbleScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.scrabbleScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"scrabble_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.scrabbleScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.scrabbleScanPlugin
                                                             scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.scrabbleScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.scrabbleScanViewPlugin];
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryScrabble;
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self startAnyline];
    
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     self.scrabbleScanViewPlugin.cutoutRect.origin.y +
     self.scrabbleScanViewPlugin.cutoutRect.size.height +
     self.scrabbleScanViewPlugin.frame.origin.y +
     120];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scrabbleScanViewPlugin stopAndReturnError:nil];
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
    BOOL success = [self.scrabbleScanViewPlugin startAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
    
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.scrabbleScanPlugin.isRunning) {
        [self.scrabbleScanViewPlugin stopAndReturnError:nil];
    }
}

#pragma mark -- AnylineOCRModuleDelegate
/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin didFindResult:(ALOCRResult *)result {
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.scrabbleScanViewPlugin completion:^{
        [self stopAnyline];
        ALScrabbleViewController *vc = [[ALScrabbleViewController alloc] init];
        [vc setResult:result.result];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.scrabbleScanViewPlugin];
    }
    
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin runSkipped:(ALRunSkippedReason *)runSkippedReason {
    switch (runSkippedReason.reason) {
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
