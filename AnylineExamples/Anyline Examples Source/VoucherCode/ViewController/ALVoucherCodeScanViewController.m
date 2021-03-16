//
//  ALVoucherCodeScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALVoucherCodeScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALResultViewController.h"

// The controller has to conform to <ALOCRScanPluginDelegate> to be able to receive results
@interface ALVoucherCodeScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *voucherScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *voucherScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALVoucherCodeScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Voucher Code";
    
    CGRect frame = [self scanViewFrame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.characterWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    config.validationRegex = @"[A-Z0-9]{8}$";
    config.scanMode = ALLine;
    
    NSError *error = nil;
    
    self.voucherScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                              delegate:self
                                                             ocrConfig:config
                                                                 error:&error];
    NSAssert(self.voucherScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.voucherScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"voucher_code_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.voucherScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.voucherScanPlugin
                                                            scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.voucherScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.voucherScanViewPlugin addScanViewPluginDelegate:self];
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.voucherScanViewPlugin];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryIban;

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
 Cancel scanning to allow the scan view plugin to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.voucherScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.voucherScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.voucherScanPlugin.isRunning) {
        [self.voucherScanViewPlugin stopAndReturnError:nil];
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

#pragma mark -- ALOCRScanPluginDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin didFindResult:(ALOCRResult *)result {
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Voucher Code" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.voucherScanViewPlugin completion:^{
        [self stopAnyline];
        //Display the result
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.voucherScanViewPlugin];
    }
    
}

@end
