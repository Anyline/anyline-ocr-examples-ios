//
//  ALTINScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 26.08.19.
//

#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"

#import "ALResultEntry.h"
#import "ALResultViewController.h"

// This is the license key for the examples project used to set up Anyline below
NSString * const kTINLicenseKey = kDemoAppLicenseKey;
@interface ALTINScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *tinScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *tinScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALTINScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"TIN";
    ALTINConfig *config = [[ALTINConfig alloc] init];
    
    NSError *error = nil;
    
    self.tinScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                        licenseKey:kTINLicenseKey
                                                          delegate:self
                                                         ocrConfig:config
                                                             error:&error];
    NSAssert(self.tinScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.tinScanPlugin addInfoDelegate:self];
    
    ALScanViewPluginConfig *viewPluginConfig = [ALScanViewPluginConfig defaultTINConfig];
    viewPluginConfig.delayStartScanTime = 2000;
    self.tinScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.tinScanPlugin scanViewPluginConfig:viewPluginConfig];
    NSAssert(self.tinScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.tinScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryTIN;
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
    [self.tinScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.tinScanViewPlugin];
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin
               didFindResult:(ALOCRResult *)result {
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.tinScanViewPlugin completion:^{
        //Display the result
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Tire Identification Number" value:result.result shouldSpellOutValue:YES]];
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
