//
//  ALCattleTagScanViewController.m
//  AnylineExamples
//
//  Created by Philipp on 12.03.2019.
//

#import "ALCattleTagScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"

#import "ALResultEntry.h"
#import "ALResultViewController.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kCattleTagLicenseKey = kDemoAppLicenseKey;
@interface ALCattleTagScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *cattleTagScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *cattleTagScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALCattleTagScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Cattle Tag";
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    
    config.scanMode = ALAuto;
    NSString *cattleTagAny = [[NSBundle mainBundle] pathForResource:@"USNr" ofType:@"any"];
    [config setLanguages:@[cattleTagAny] error:nil];
    
    NSString *cmdFile = [[NSBundle mainBundle] pathForResource:@"cow_tag_scanner" ofType:@"ale"];
    config.customCmdFilePath = cmdFile;
    
    NSError *error = nil;
    
    self.cattleTagScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                        licenseKey:kCattleTagLicenseKey
                                                          delegate:self
                                                         ocrConfig:config
                                                             error:&error];
    NSAssert(self.cattleTagScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.cattleTagScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"cow_tag_capture_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.cattleTagScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.cattleTagScanPlugin
                                                        scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.cattleTagScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.cattleTagScanViewPlugin];

    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryCattleTag;
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
    [self.cattleTagScanViewPlugin stopAndReturnError:nil];
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
    BOOL success = [self.cattleTagScanViewPlugin startAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin
               didFindResult:(ALOCRResult *)result {
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.cattleTagScanViewPlugin completion:^{
        //Display the result
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Cattle Tag Number" value:result.result]];
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
@end
