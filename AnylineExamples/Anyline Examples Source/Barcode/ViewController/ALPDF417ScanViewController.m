#import "ALPDF417ScanViewController.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"
#import "ALBarcodeResultUtil.h"

NSString * const kBarcodePDF417_configJSONFilename = @"barcode_pdf417_config";

@interface ALPDF417ScanViewController() <ALScanPluginDelegate>


@end

@implementation ALPDF417ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PDF417";
    
    NSString *configStr = [self configJSONStrWithFilename:kBarcodePDF417_configJSONFilename error:nil];
    NSError *error;
    ALScanViewConfig *config = [ALScanViewConfig withJSONString:configStr error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }
    if ([self popWithAlertOnError:error]) {
        return;
    }

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewConfig:config
                                                error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

    ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)self.scanView.viewPlugin;
    scanViewPlugin.scanPlugin.delegate = self;

    [self installScanView:self.scanView];
    
    [self.scanView startCamera];
    
    self.controllerType = ALScanHistoryBarcodePDF417;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScanning:nil];
}

+ (ALViewPluginConfig *)defaultScanViewPluginConfig {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:kBarcodePDF417_configJSONFilename
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    return [ALViewPluginConfig withJSONString:configStr error:nil];
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    
    if (!scanResult.croppedImage) { // reject any result that doesn't come with an image.
        // ACO this is a known bug in the core (at the moment)
        // In doing this, the plugin config (on JSON) needs `cancelOnResult` to be false.
        return;
    }
    
    NSArray<ALBarcode *> *barcodes = scanResult.pluginResult.barcodeResult.barcodes;
    if (barcodes.count < 1) {
        return;
    }
    
    [self showResultControllerWithResults:scanResult];
}

- (void)showResultControllerWithResults:(ALScanResult *)scanResult {
    
    [self stopScanning];
    
    // copy the barcodes array and image before clearing
    NSArray<ALBarcode *> *barcodesFound = [NSArray arrayWithArray:scanResult.pluginResult
                                           .barcodeResult.barcodes];
    UIImage *image = [scanResult.croppedImage copy];
    
    NSAssert(barcodesFound.count > 0, @"no barcodes found");
    
    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];

    ALScanPlugin *scanPlugin = nil;
    if ([self.scanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        scanPlugin = [(ALScanViewPlugin *)self.scanViewPlugin scanPlugin];
    }

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:resultDataJSONStr
                 barcodeResult:barcodesFound[0].value
                         image:image
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

@end

