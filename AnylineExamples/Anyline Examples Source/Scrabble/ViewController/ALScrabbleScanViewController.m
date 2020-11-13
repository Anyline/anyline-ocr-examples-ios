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

// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALScrabbleScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

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
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALAuto;
    config.characterWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ";
    config.validationRegex = @"^[A-ZÄÜÖ]{7,10}$";
    
    NSError *error = nil;
    
    self.scrabbleScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
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
    [self.scrabbleScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.scrabbleScanViewPlugin];
    
    // After setup is complete we add the scanView to the view of this view controller
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
    [self startPlugin:self.scrabbleScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.scrabbleScanPlugin.isRunning) {
        [self.scrabbleScanViewPlugin stopAndReturnError:nil];
    }
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
        case ALRunFailureUnknown:
            break;
        default:
            break;
    }
}

@end
