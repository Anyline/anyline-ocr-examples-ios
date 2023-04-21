#import "ALVRCScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"

@interface ALVRCScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@end


NSString * const kALVRCScanVC_configFilename = @"vrc_config";


@implementation ALVRCScanViewController

- (void)dealloc {
    // NSLog(@"dealloc ALVRCScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Vehicle Registration Certificate";
    self.controllerType = ALScanHistoryVehicleRegistrationCertificate;

    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:kALVRCScanVC_configFilename ofType:@"json"];
    self.scanView = [ALScanViewFactory withConfigFilePath:path delegate:self error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

    [self installScanView:self.scanView];

    [self setupFlipOrientationButton];
    [self.scanView startCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSError *error;
    [self startScanning:&error];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopScanning];
    [super viewWillDisappear:animated];
}

// detect when a rotation is done
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    __weak __block typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {}
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (weakSelf.scanViewPlugin.isStarted) {
            [weakSelf.scanView setScanViewPlugin:self.scanViewPlugin error:nil];
            [weakSelf.scanView startCamera];
            [weakSelf startScanning:nil];
        }
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {

    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;

    NSString *resultJSONString = [ALResultEntry JSONStringFromList:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:resultJSONString
                 barcodeResult:nil image:scanResult.croppedImage
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{

        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;

        [weakSelf enableLandscapeOrientation:NO];
        weakSelf.isOrientationFlipped = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end


