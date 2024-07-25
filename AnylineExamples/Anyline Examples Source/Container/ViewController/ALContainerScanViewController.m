#import "ALContainerScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "UIColor+ALExamplesAdditions.h"

NSString * const kContainerVC_configName_horiz = @"horizontal_container_scanner_capture_config";
NSString * const kContainerVC_configName_vert = @"vertical_container_scanner_capture_config";

static const NSUInteger kChoicesCount = 2;

// NOTE: This is a C array
static NSString *kChoiceTitles[kChoicesCount] = {
    @"Horizontal",
    @"Vertical"
};

static NSString *kConfigs[kChoicesCount] = {
    kContainerVC_configName_horiz,
    kContainerVC_configName_vert,
};


@interface ALContainerScanViewController () <ALScanPluginDelegate, ALConfigurationDialogViewControllerDelegate>

@property (assign, nonatomic) BOOL isVertical;

@property (nonatomic, assign) NSUInteger dialogIndexSelected;

@end


@implementation ALContainerScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isVertical = [self.title localizedCaseInsensitiveContainsString:@"Vertical"];
    if (_isVertical) {
        self.title = @"Container Number (Vertical)";
    } else {
        self.title = @"Container Number";
    }
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    self.controllerType = ALScanHistoryContainer;

    [self reloadScanView];

    [self setColors];

    [self setupModeToggle];

    [self.scanView startCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScanning:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopScanning];
}

- (void)reloadScanView {
    NSString *configJSON;

    if (self.isVertical) {
        configJSON = [self configJSONStrWithFilename:kContainerVC_configName_vert error:nil];
    } else {
        configJSON = [self configJSONStrWithFilename:kContainerVC_configName_horiz error:nil];
    }

    NSError *error;

    ALScanViewConfig *scanViewConfig = [ALScanViewConfig withJSONString:configJSON error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewConfig.viewPluginConfig error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }

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
        [self.scanView setViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    }
    [self startScanning:nil];
}

// MARK: - Allow changing the scan mode

- (void)setupModeToggle {
    __weak __block typeof(self) weakSelf = self;
    [self addModeSelectButtonWithTitle:kChoiceTitles[self.dialogIndexSelected] buttonPressed:^{
        [weakSelf showOptionsSelectionDialog];
    }];
}

- (void)showOptionsSelectionDialog {
    NSArray *choices = [NSArray arrayWithObjects:kChoiceTitles count:kChoicesCount];
    ALConfigurationDialogViewController *vc = [ALConfigurationDialogViewController singleSelectDialogWithChoices:choices
                                                                                                   selectedIndex:self.dialogIndexSelected
                                                                                                        delegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    [self.scanView stopCamera];
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    NSArray<ALResultEntry*> *resultData = scanResult.pluginResult.fieldList.resultEntries;
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

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {
    [self.scanView startCamera];
}

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    self.dialogIndexSelected = index;
    [self.modeSelectButton setTitle:kChoiceTitles[index] forState:UIControlStateNormal];
    self.isVertical = index == 1;
    [self reloadScanView];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.scanView startCamera];
    }];
}

@end
