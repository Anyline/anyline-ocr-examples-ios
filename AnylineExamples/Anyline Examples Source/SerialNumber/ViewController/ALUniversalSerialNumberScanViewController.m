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
#import "AnylineExamples-Swift.h"

// The controller has to conform to <ALOCRScanPluginDelegate> to be able to receive results
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
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALOCRConfig *config = [self ocrConfig];
    
    NSError *error = nil;
    
    self.serialNumberScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR" 
                                                                   delegate:self
                                                                  ocrConfig:config
                                                                      error:&error];
    NSAssert(self.serialNumberScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.serialNumberScanPlugin addInfoDelegate:self];
    
    ALScanViewPluginConfig *scanViewPluginConfig = [self scanViewPluginConfig];
    
    self.serialNumberScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.serialNumberScanPlugin
                                                                 scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.serialNumberScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.serialNumberScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.serialNumberScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
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
    
    self.controllerType = ALScanHistorySerial;
}

- (ALOCRConfig *)ocrConfig {
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    
    config.scanMode = ALAuto;
    
    config.validationRegex = @"[A-Z0-9]{4,}";
    return config;
}

- (ALScanViewPluginConfig *)scanViewPluginConfig {
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"serial_number_view_config" ofType:@"json"];
     return [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
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
    [self startPlugin:self.serialNumberScanViewPlugin];
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
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Universal Serial Number" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString
                 barcodeResult:@""
                         image:result.image
                    scanPlugin:anylineOCRScanPlugin
                    viewPlugin:self.serialNumberScanViewPlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = result.image;

        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.serialNumberScanViewPlugin];
    }
    
}


@end
