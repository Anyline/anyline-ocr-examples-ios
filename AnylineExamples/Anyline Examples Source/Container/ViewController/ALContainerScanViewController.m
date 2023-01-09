#import "ALContainerScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "UIColor+ALExamplesAdditions.h"

NSString * const kContainerVC_configJSONFilename = @"horizontal_container_scanner_capture_config";
NSString * const kVerticalContainerVC_configJSONFilename = @"vertical_container_scanner_capture_config";
@interface ALContainerScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;
// @property (nullable, nonatomic, strong) ALScanView *scanView;

@property (assign, nonatomic) BOOL isVertical;

@end

@implementation ALContainerScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isVertical = [self.title localizedCaseInsensitiveContainsString:@"Vertical"];
    if (_isVertical) {
        self.title = @"Vertical Shipping Container";
    } else {
        self.title = @"Horizontal Shipping Container";
    }
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    self.controllerType = ALScanHistoryContainer;

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
    NSDictionary *configJSONDictionary;
    
    if (self.isVertical) {
        configJSONDictionary = [[self configJSONStrWithFilename:kVerticalContainerVC_configJSONFilename] asJSONObject];
    } else {
        configJSONDictionary = [[self configJSONStrWithFilename:kContainerVC_configJSONFilename] asJSONObject];
    }

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
    NSArray <ALResultEntry*> *resultData = scanResult.pluginResult.containerResult.resultEntryList;
    NSString *resultDataJSONStr = [ALResultEntry JSONStringFromList:resultData];
    __weak ALContainerScanViewController *weakSelf = self;
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
