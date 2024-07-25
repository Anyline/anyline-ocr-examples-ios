#import "ALUniversalSerialNumberScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALBaseViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"


NSString * const kUniversalSerialNumberScanVC_configJSONFilename = @"serial_number_view_config";
@interface ALUniversalSerialNumberScanViewController () <ALScanPluginDelegate>

@end

@implementation ALUniversalSerialNumberScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Meter Serial Number";
    self.controllerType = ALScanHistoryBarcode;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSettings:)];
    
    [self setColors];

    self.controllerType = ALScanHistorySerial;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadScanView];
    [self startScanning:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScanning];
}

- (void)reloadScanView {
    NSError *error;
    ALScanViewPlugin *scanViewPlugin = [self.class scanViewPluginWithUpdatedSettings:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    scanViewPlugin.scanPlugin.delegate = self;

    if (!self.scanView) {

        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                           scanViewConfig:[self.class scanViewConfig]
                                                    error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
    } else {
        [self.scanView setViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    }
    [self.scanView startCamera];
    [self.view bringSubviewToFront:self.scanView];
}

// MARK: - Serial Settings

+ (ALViewPluginConfig *)defaultViewPluginConfig {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:kUniversalSerialNumberScanVC_configJSONFilename
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    NSError *error;
    ALScanViewConfig *ret = [ALScanViewConfig withJSONString:configStr error:&error];
    return ret.viewPluginConfig;
}

+ (ALScanViewConfig *)scanViewConfig {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:kUniversalSerialNumberScanVC_configJSONFilename
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    return [ALScanViewConfig withJSONDictionary:configStr.asJSONObject error:nil];
}

+ (ALScanViewPlugin *)scanViewPluginWithUpdatedSettings:(NSError **)error {
    ALViewPluginConfig *viewPluginConfig = [self.class defaultViewPluginConfig];

    ALPluginConfig *newPluginConfig = viewPluginConfig.pluginConfig;
    newPluginConfig.ocrConfig = [self.class ocrConfig];
    
    NSDictionary *newCutoutConfigDictionary = [CutoutSettings.shared customizedCutoutConfigFrom:viewPluginConfig.cutoutConfig];
    ALCutoutConfig *newCutoutConfig = [ALCutoutConfig withJSONDictionary:newCutoutConfigDictionary error:nil];

    ALViewPluginConfig *newViewPluginConfig = [ALViewPluginConfig withJSONDictionary:@{
        @"pluginConfig": [[newPluginConfig asJSONString] asJSONObject],
        @"cutoutConfig": [[newCutoutConfig asJSONString] asJSONObject],
        @"scanFeedbackConfig": [[viewPluginConfig.scanFeedbackConfig asJSONString] asJSONObject],
    } error:error];

    return [[ALScanViewPlugin alloc] initWithConfig:newViewPluginConfig error:error];
}

+ (ALOcrConfig *)ocrConfig {
    return [[SerialNumberSettings shared] toOCRConfig];
}

- (IBAction)showSettings:(id)sender {
    SerialNumberSettingsViewController *controller = [[SerialNumberSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];
    __weak ALUniversalSerialNumberScanViewController *weakSelf = self;
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
