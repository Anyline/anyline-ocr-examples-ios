#import "ALVINScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"

@interface ALVINScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@end


NSString * const kALVINScanVC_configFilename = @"vin_ocr_config";


@implementation ALVINScanViewController

- (void)dealloc {
    // NSLog(@"dealloc ALVINScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VIN";
    self.controllerType = ALScanHistoryVIN;
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:kALVINScanVC_configFilename ofType:@"json"];
    self.scanView = [ALScanViewFactory withConfigFilePath:path delegate:self error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

    [self installScanView:self.scanView];
    [self.scanView startCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSError *error;
    [self startScanning:&error];
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];
    
    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *JSONResultString = [ALResultEntry JSONStringFromList:resultData];
    
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:JSONResultString
                 barcodeResult:nil
                         image:scanResult.croppedImage
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{
        
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end

