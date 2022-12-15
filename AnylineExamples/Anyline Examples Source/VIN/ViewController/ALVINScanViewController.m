#import "ALVINScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"

@interface ALVINScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@end


NSString * const kALVINScanVC_configFilename = @"ocr_config_vin";


@implementation ALVINScanViewController

- (void)dealloc {
    NSLog(@"dealloc ALVINScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"VIN";
    self.controllerType = ALScanHistoryVIN;
    
    NSError *error;
    self.scanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:self.scanViewConfigDict];
    
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:self.scanViewConfigDict error:&error];

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.scanViewPlugin
                                       scanViewConfig:self.scanViewConfig
                                                error:&error];
    
    [self installScanView:self.scanView];

    ALScanViewPlugin *scanViewPlugin = self.scanViewPlugin;
    scanViewPlugin.scanPlugin.delegate = self;

    [self.scanView startCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSError *error;
    [self.scanViewPlugin startWithError:&error]; // could check the error
}

// MARK: - Getters and Setters

- (NSDictionary *)scanViewConfigDict {
    return [[self configJSONStrWithFilename:kALVINScanVC_configFilename] asJSONObject]; // could check the error
}


// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];

    ALVinResult *vinResult = scanResult.pluginResult.vinResult;
    NSArray<ALResultEntry *> *resultData = vinResult.resultEntryList;
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

