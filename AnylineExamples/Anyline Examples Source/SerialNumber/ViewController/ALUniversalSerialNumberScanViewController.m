#import "ALUniversalSerialNumberScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALBaseViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"

NSString * const kUniversalSerailNumberScanVC_configJSONFilename = @"serial_number_view_config";
@interface ALUniversalSerialNumberScanViewController () <ALScanPluginDelegate>

@end

@implementation ALUniversalSerialNumberScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Universal Serial Number";
    self.controllerType = ALScanHistoryBarcode;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    
    [self setColors];

    self.controllerType = ALScanHistorySerial;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadScanView];
    [self.scanViewPlugin startWithError:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanViewPlugin stop];
}

- (void)reloadScanView {
    ALScanViewPlugin *scanViewPlugin = [self.class scanViewPluginWithUpdatedSettings];
    scanViewPlugin.scanPlugin.delegate = self;

    self.scanViewPlugin = scanViewPlugin;

    if (!self.scanView) {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                                    error:nil];
        [self installScanView:self.scanView];


    } else {
        [self.scanView setScanViewPlugin:scanViewPlugin error:nil];
    }
    [self.scanView startCamera];
    [self.view bringSubviewToFront:self.scanView];
}

// MARK: - Serial Settings

+ (ALScanViewPluginConfig *)defaultScanViewPluginConfig {
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:kUniversalSerailNumberScanVC_configJSONFilename
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    return [[ALScanViewPluginConfig alloc] initWithJSONDictionary:[configStr asJSONObject] error:nil];
}

+ (ALScanViewPlugin *)scanViewPluginWithUpdatedSettings {
    ALScanViewPluginConfig *scanViewPluginConfig = [self.class defaultScanViewPluginConfig];
    
    ALPluginConfig *newPluginConfig = scanViewPluginConfig.scanPluginConfig.pluginConfig;
    newPluginConfig.ocrConfig = [self.class ocrConfig];
    
    ALScanPluginConfig *newScanPluginConfig = [[ALScanPluginConfig alloc] initWithPluginConfig:newPluginConfig];
    
    NSDictionary *newCutoutConfigDictionary = [CutoutSettings.shared customizedCutoutConfigFrom:scanViewPluginConfig.cutoutConfig];
    ALCutoutConfig *newCutoutConfig = [[ALCutoutConfig alloc] initWithJSONDictionary:newCutoutConfigDictionary error:nil];
    
    ALScanViewPluginConfig *newScanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithScanPluginConfig:newScanPluginConfig cutoutConfig:newCutoutConfig scanFeedbackConfig:scanViewPluginConfig.scanFeedbackConfig error:nil];
    
    return [[ALScanViewPlugin alloc] initWithConfig:newScanViewPluginConfig error:nil];
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
    NSArray <ALResultEntry*> *resultData = scanResult.pluginResult.ocrResult.resultEntryList;
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
