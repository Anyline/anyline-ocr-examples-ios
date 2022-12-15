#import "ALVRCScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"

@interface ALVRCScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@end


NSString * const kALVRCScanVC_configFilename = @"vehicle_registration_cert_config";


@implementation ALVRCScanViewController

- (void)dealloc {
    NSLog(@"dealloc ALVRCScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"VRC";
    self.controllerType = ALScanHistoryVehicleRegistrationCertificate;

    NSError *error;
    self.scanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:self.scanViewConfigDict];
    // check if there are errors

    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:self.scanViewConfigDict error:&error];
    // check if there are errors

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.scanViewPlugin
                                       scanViewConfig:self.scanViewConfig
                                                error:&error];
    // check if there are errors
    
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
    return [[self configJSONStrWithFilename:kALVRCScanVC_configFilename] asJSONObject];
}


// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];

    ALVehicleRegistrationCertificateResult *vrcResult = scanResult.pluginResult.vehicleRegistrationCertificateResult;
    NSArray<ALResultEntry *> *resultData = vrcResult.resultEntryList;

    NSString *resultJSONString = [ALResultEntry JSONStringFromList:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:resultJSONString
                 barcodeResult:nil image:scanResult.croppedImage
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{

        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end


