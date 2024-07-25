#import "ALLicensePlateScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"


NSString * const kLicensePlateScanVC_configEU = @"license_plate_eu_config";
NSString * const kLicensePlateScanVC_configUS = @"license_plate_us_config";
NSString * const kLicensePlateScanVC_configAF = @"license_plate_af_config";

static const NSUInteger kChoicesCount = 3;

static NSString *kChoiceTitles[kChoicesCount] = { // NOTE: A C-array
    @"Europe",
    @"United States",
    @"Africa"
};

static NSString *kConfigs[3] = {
    kLicensePlateScanVC_configEU,
    kLicensePlateScanVC_configUS,
    kLicensePlateScanVC_configAF,
};

@interface ALLicensePlateScanViewController () <ALScanPluginDelegate, ALConfigurationDialogViewControllerDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSString *configJSONStr;

@property (nonatomic, assign) NSUInteger dialogIndexSelected;

@end


@implementation ALLicensePlateScanViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dialogIndexSelected = 0;
    self.controllerType = ALScanHistoryLicensePlates;

    // self.title would have been set based on values from ALLicensePlateManager
    NSString *licensePlateConfigJSONFile = kLicensePlateScanVC_configEU;
    if ([self.title isEqualToString:@"US License Plate"]) {
        licensePlateConfigJSONFile = kLicensePlateScanVC_configUS;
    } else if ([self.title isEqualToString:@"African License Plate"] || [self.title isEqualToString:@"AF License Plate"]) {
        licensePlateConfigJSONFile = kLicensePlateScanVC_configAF;
    } else {
        // not previously assigned, give it a fallback (would already use the EU config)
        self.title = @"License Plate";
    }
    [self updateConfigWithName:licensePlateConfigJSONFile];
    [self setupModeToggle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    NSError *error;
    [self startScanning:&error];

    [self.scanView startCamera];
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];
    NSArray <ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
    NSString *resultString = [ALResultEntry JSONStringFromList:resultData];
    UIImage *image = scanResult.croppedImage;
    
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:resultString
                 barcodeResult:nil
                         image:image
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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

- (void)updateConfigWithName:(NSString *)configName {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:configName ofType:@"json"];

    if (!self.scanView) {
        self.scanView = [ALScanViewFactory withConfigFilePath:path delegate:self error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
    } else {
        
        ALScanViewConfig *scanViewConfig = [ALScanViewConfig withJSONString:[self configJSONStrWithFilename:configName error:nil] error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }

        ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewConfig.viewPluginConfig error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }

        [self.scanView setViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }

        [scanViewPlugin.scanPlugin setDelegate:self];
    }
    [self startScanning:nil];
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {
    [self.scanView startCamera];
}

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    self.dialogIndexSelected = index;
    [self.modeSelectButton setTitle:kChoiceTitles[index] forState:UIControlStateNormal];
    [self updateConfigWithName:kConfigs[index]];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scanView startCamera];
        });
    }];
}

@end
