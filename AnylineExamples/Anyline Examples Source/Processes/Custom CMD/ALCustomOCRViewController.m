#import "ALCustomOCRViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"

static NSString * const kConfigFileName = @"cow_tag_config";

@interface ALCustomOCRViewController () <ALScanPluginDelegate>

@end


@implementation ALCustomOCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Custom CMD File (Cattle Tag)";
    self.controllerType = ALScanHistoryCattleTag;

    NSDictionary *configDict = [[self configJSONStrWithFilename:kConfigFileName] asJSONObject];

    NSError *error;
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithJSONDictionary:configDict
                                                                                  error:&error];
    scanViewPlugin.scanPlugin.delegate = self;
    if ([self popWithAlertOnError:error]) {
        return;
    }

    if (!self.scanView) {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                                    error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
    } else {
        [self.scanView setScanViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    }

    [self.scanView startCamera];
    [self startScanning:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScanning:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScanning];
}


// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    NSArray<ALResultEntry*> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];
    __weak UIViewController *weakSelf = self;
    [self anylineDidFindResult:resultDataJSONStr
                 barcodeResult:@""
                         image:scanResult.croppedImage
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;

        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end
