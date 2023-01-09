
#import "ALBottlecapScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"

NSString * const kBottleCapVC_configJSONFilename = @"bottlecap_config";
@interface ALBottlecapScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@end

@implementation ALBottlecapScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Pepsi Code";
    
    self.controllerType = ALScanHistoryBottleCapPepsi;
    
    [self reloadScanView];
    
    [self setColors];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanViewPlugin startWithError:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanViewPlugin stop];
}

- (void)reloadScanView {
    NSDictionary *configJSONDictionary = [[self configJSONStrWithFilename:kBottleCapVC_configJSONFilename] asJSONObject];
    
    NSError *error;
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithJSONDictionary:configJSONDictionary error:&error];
    
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    scanViewPlugin.scanPlugin.delegate = self;
    
    [self.scanView stopCamera];
    if (self.scanView) {
        [self.scanView removeFromSuperview];
    }
    
    self.scanViewPlugin = scanViewPlugin;
    
    ALScanViewConfig *scanViewConfig = [ALScanViewConfig withJSONDictionary:configJSONDictionary];
    
    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:scanViewPlugin
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

#pragma mark -- ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Pepsi Code" value:scanResult.pluginResult.ocrResult.text shouldSpellOutValue:YES]];
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];
    __weak ALBottlecapScanViewController *weakSelf = self;
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
