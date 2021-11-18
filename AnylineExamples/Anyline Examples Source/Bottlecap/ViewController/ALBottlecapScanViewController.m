//
//  ALBottleCapScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALBottlecapScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALResultViewController.h"

// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALBottlecapScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *bottlecapScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *bottlecapvinScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALBottlecapScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Pepsi Code";

    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALGrid;

    NSString *alePath = [[NSBundle mainBundle] pathForResource:@"pepsi_code_scanner" ofType:@"ale"];
    [config setCustomCmdFilePath:alePath];
    
    NSError *languagesError = nil;
    NSString *anyPath = [[NSBundle mainBundle] pathForResource:@"PepsiCo" ofType:@"any"];
    [config setLanguages:@[anyPath,] error:&languagesError];
    NSAssert(!languagesError, @"SetLanguages Error: %@", languagesError.debugDescription);
    
    
    NSError *error = nil;
    
    CGRect frame = [self scanViewFrame];
    
    self.bottlecapvinScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                                   delegate:self
                                                                  ocrConfig:config
                                                                      error:&error];
    NSAssert(self.bottlecapvinScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"bottlecap_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.bottlecapScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.bottlecapvinScanPlugin
                                                              scanViewPluginConfig:scanViewPluginConfig];
    
    NSAssert(self.bottlecapScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.bottlecapScanViewPlugin addScanViewPluginDelegate:self];
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.bottlecapScanViewPlugin];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    NSArray *scanViewConstraints = @[[self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                     [self.scanView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
                                     [self.scanView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
                                     [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
    [self.view addConstraints:scanViewConstraints];
    [NSLayoutConstraint activateConstraints:scanViewConstraints];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryBottleCapPepsi;
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
    [self.bottlecapScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.bottlecapScanViewPlugin];
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
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
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin
               didFindResult:(ALOCRResult *)result {
    // We are done. Cancel scanning
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Pepsi Code" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.bottlecapScanViewPlugin completion:^{
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.bottlecapScanViewPlugin];
    }
    
}

@end
