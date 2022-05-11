//
//  ALShippingContainerScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 09.04.18.
//

#import "ALVerticalContainerScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"

@interface ALVerticalContainerScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *containerScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *containerScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALVerticalContainerScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Vertical Shipping Container";
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALContainerConfig *config = [[ALContainerConfig alloc] init];
    config.scanMode = ALVertical;
    
    NSError *error = nil;
    
    self.containerScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                                delegate:self
                                                               ocrConfig:config
                                                                   error:&error];
    NSAssert(self.containerScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.containerScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"vertical_container_scanner_capture_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.containerScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.containerScanPlugin
                                                              scanViewPluginConfig:scanViewPluginConfig];
    [self.containerScanViewPlugin addScanViewPluginDelegate:self];
    NSAssert(self.containerScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.containerScanViewPlugin];
    
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
    
    //Enable Zoom Gesture for the scanView
    [self.scanView enableZoomPinchGesture:YES];
    
    self.controllerType = ALScanHistoryContainer;
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
    [self.containerScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.containerScanViewPlugin];
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
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Shipping Container Number" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.containerScanViewPlugin completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = result.image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end
