#import "ALCompositeScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"

NSString * const kCompositeVC_configJSONFilename = @"parallel_first_vin_barcode";

@interface ALCompositeScanViewController () <ALViewPluginCompositeDelegate>

@property (nonatomic, strong) id<ALViewPluginBase> compositePlugin;

@end

@implementation ALCompositeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIN + Barcode (Parallel First)";
    self.controllerType = ALScanHistoryVIN;
    [self reloadScanView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.compositePlugin startWithError:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.compositePlugin stop];
}

- (void)reloadScanView {

    NSError *error;
    ALScanViewConfig *scanViewConfig = [ALScanViewConfig withJSONString:
                                        [self configJSONStrWithFilename:kCompositeVC_configJSONFilename error:nil] error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

    ALViewPluginComposite *composite = [[ALViewPluginComposite alloc] initWithConfig:scanViewConfig.viewPluginCompositeConfig
                                                                               error:&error];

    if ([self popWithAlertOnError:error]) {
        return;
    }

    composite.delegate = self;

    [self.scanView stopCamera];
    if (self.scanView) {
        [self.scanView removeFromSuperview];
    }

    self.compositePlugin = composite;

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:composite
                                       scanViewConfig:scanViewConfig
                                                error:&error];

    if ([self popWithAlertOnError:error]) {
        return;
    }

    [self installScanView:self.scanView]; // call startCamera and start the plugin outside
    // we've just readded the ScanView, make sure it goes beneath the other views.
    [self.view sendSubviewToBack:self.scanView];
    [self.scanView startCamera];
}

// MARK: - ALViewPluginCompositeDelegate

- (void)viewPluginComposite:(ALViewPluginComposite *)viewPluginComposite allResultsReceived:(NSArray<ALScanResult *> *)scanResults {
    // there will be only one result - this is the way the plugin is configured
    ALScanResult *scanResult = scanResults[0];

    // Locate plugin using the pluginID
    ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)[viewPluginComposite pluginWithID:scanResult.pluginID];
    ALScanPlugin *scanPlugin = scanViewPlugin.scanPlugin;

    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];
    __weak ALCompositeScanViewController *weakSelf = self;
    [self anylineDidFindResult:resultDataJSONStr
                 barcodeResult:@"" // not using this, even though it's for a barcode + VIN
                         image:scanResult.croppedImage
                    scanPlugin:scanPlugin
                    viewPlugin:self.compositePlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;

        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end
