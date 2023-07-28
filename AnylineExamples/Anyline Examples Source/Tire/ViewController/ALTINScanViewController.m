#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALConfigurationDialogViewController.h"
#import "AnylineExamples-Swift.h" // for ALResultEntry
#import "ALPluginResultHelper.h"

#if __has_include("ALContactUsViewController.h")
#import "ALContactUsViewController.h"
#endif

static const NSUInteger kChoicesCount = 3; // synced with ALTINScanMode

typedef enum {
    ALTINScanModeUniversal = 0,
    ALTINScanModeDOT,
    ALTINScanModeOtherInfo
} ALTINScanMode;

static NSString *kChoiceTitles[kChoicesCount] = { // NOTE: A C-array
    @"Universal TIN/DOT",
    @"TIN/DOT (North America only)",
    @"Other tire sidewall information"
};

NSString * const kALTINScanVC_configFilename = @"tire_tin_config";


@interface ALTINScanViewController () <ALScanPluginDelegate, ALConfigurationDialogViewControllerDelegate>

// TODO: most of these can go to a superclass.
@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@property (nonatomic, assign) NSUInteger dialogIndexSelected;

@end


@implementation ALTINScanViewController

- (void)dealloc {
    // NSLog(@"dealloc ALTINScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tire DOT/TIN";
    self.controllerType = ALScanHistoryTIN;

    self.dialogIndexSelected = 0;
    
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:self.scanViewConfigDict error:nil];

    if (self.isRegionUnitedStates) {
        // https://anyline.atlassian.net/browse/APP-406
        self.dialogIndexSelected = 1;
    }

    [self reloadScanView];
    
    [self setupModeToggle];

    [self setupFlipOrientationButton];

    [self.scanView startCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // starts in landscape mode (APP-383)
    self.isOrientationFlipped = YES;
    [self enableLandscapeOrientation:YES];

    [self startScanning:nil];
}

// detect when a rotation is done
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    __weak __block typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {}
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (weakSelf.scanViewPlugin.isStarted) {
            [weakSelf reloadScanView];
        }
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

// MARK: - Getters and Setters

- (NSDictionary *)scanViewConfigDict {
    return [[self configJSONStrWithFilename:kALTINScanVC_configFilename] asJSONObject];
}

- (BOOL)isRegionUnitedStates {
    // checking device region settings. If it's US, the TIN/DOT option needs to be shown.
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return [countryCode isEqualToString:@"US"];
}

// MARK: - Setup

- (ALScanViewPlugin *)scanViewPluginForScanMode:(ALTINScanMode)scanMode {
    NSDictionary *JSONConfigObj = self.scanViewConfigDict;
    
    // Will edit this object before constructing an ALScanViewPlugin with it later
    ALScanViewPluginConfig *scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithJSONDictionary:JSONConfigObj error:nil];
    
    // Change the mode...
    ALTinConfig *tinConfig = scanViewPluginConfig.pluginConfig.tinConfig;
    tinConfig.scanMode = ALTinConfigScanMode.universal;
    switch (scanMode) {
        case ALTINScanModeUniversal:
            tinConfig.scanMode = ALTinConfigScanMode.universal;
            break;
        case ALTINScanModeDOT:
            tinConfig.scanMode = ALTinConfigScanMode.dot;
            break;
        default: break;
    }
    
    // Recreate the ScanViewPlugin. Since this is a different ScanViewPlugin than
    // the previous one, reset the delegate.
    NSError *error;
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:&error];
    
    if ([self popWithAlertOnError:error]) {
        return nil;
    }
    
    scanViewPlugin.scanPlugin.delegate = self;
    return scanViewPlugin;
}

- (void)changeScanViewMode:(ALTINScanMode)scanMode {
    [self stopScanning];
    ALScanViewPlugin *scanViewPlugin = [self scanViewPluginForScanMode:scanMode];
    
    NSError *error;
    if (!self.scanView) {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:scanViewPlugin
                                           scanViewConfig:self.scanViewConfig
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
    [self startScanning:nil];
}

- (void)reloadScanView {
    [self changeScanViewMode:(ALTINScanMode)self.dialogIndexSelected];
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:scanResult.pluginResult.tinResult.text
                 barcodeResult:nil
                         image:[scanResult croppedImage]
                    scanPlugin:scanPlugin viewPlugin:self.scanViewPlugin completion:^{
        NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        weakSelf.isOrientationFlipped = NO;
        [weakSelf enableLandscapeOrientation:NO];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

// MARK: - Allow changing the scan mode

- (void)showOptionsSelectionDialog {
    NSArray *choices = [NSArray arrayWithObjects:kChoiceTitles count:kChoicesCount];
    ALConfigurationDialogViewController *vc = [ALConfigurationDialogViewController singleSelectDialogWithChoices:choices
                                                                                                   selectedIndex:self.dialogIndexSelected
                                                                                                        delegate:self];
    [self presentViewController:vc animated:YES completion:nil];
    [self.scanView stopCamera];
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {
    [self.scanView startCamera];
}

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {

    if (index == ALTINScanModeOtherInfo) {
        [self presentContactUsDialog];
        return;
    }
    self.dialogIndexSelected = index;
    [self.modeSelectButton setTitle:kChoiceTitles[index] forState:UIControlStateNormal];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.scanView startCamera];
    }];
    
    [self reloadScanView];
}

// MARK: - Miscellaneous

- (void)setupModeToggle {
    __weak __block typeof(self) weakSelf = self;
    [self addModeSelectButtonWithTitle:kChoiceTitles[self.dialogIndexSelected] buttonPressed:^{
        [weakSelf showOptionsSelectionDialog];
    }];
}

- (void)presentContactUsDialog {
#if __has_include("ALContactUsViewController.h")
    ALTINScanViewController __weak *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{

        ALContactUsViewController *contactVC = [[ALContactUsViewController alloc] init];
        contactVC.modalPresentationStyle = UIModalPresentationFormSheet;

        [weakSelf presentViewController:contactVC animated:NO completion:^{
            // undo forced landscape mode (APP-383)
            weakSelf.isOrientationFlipped = NO;
            [weakSelf enableLandscapeOrientation:NO];
        }];

        [contactVC setPresentationBlock:^{ // what happens when dismissed
            // undo forced landscape mode (APP-383)
            weakSelf.isOrientationFlipped = YES;
            [weakSelf enableLandscapeOrientation:YES];

            [weakSelf.scanView startCamera];
        }];
    }];
#endif
}

@end
