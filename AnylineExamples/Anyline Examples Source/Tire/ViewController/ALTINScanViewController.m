#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALConfigurationDialogViewController.h"
#import "AnylineExamples-Swift.h" // for ALResultEntry
#import "ALPluginResultHelper.h"
#import "ALTinScanRecalledDOTs.h"

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

NSString * const kALTINUniversalScanVC_configFilename = @"tire_tin_universal_uifeedback_config";
NSString * const kALTINNAScanVC_configFilename = @"tire_tin_na_uifeedback_config";


@interface ALTINScanViewController () <ALScanPluginDelegate, ALConfigurationDialogViewControllerDelegate>

// TODO: most of these can go to a superclass.
@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, assign) NSUInteger dialogIndexSelected;

@property (nonatomic, readonly) NSArray<NSString *> *recalledDOTs;

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
    
    self.scanViewConfig = [ALScanViewConfig withJSONDictionary:[self scanViewConfigDict:ALTINScanModeUniversal] error:nil];

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

- (NSDictionary *)scanViewConfigDict:(ALTINScanMode)scanMode {
    switch (scanMode) {
        case ALTINScanModeUniversal:
            return [[self configJSONStrWithFilename:kALTINUniversalScanVC_configFilename error:nil] asJSONObject];
            break;
        case ALTINScanModeDOT:
            return [[self configJSONStrWithFilename:kALTINNAScanVC_configFilename error:nil] asJSONObject];
            break;
        default: break;
    }
    return [[self configJSONStrWithFilename:kALTINUniversalScanVC_configFilename error:nil] asJSONObject];
}

- (BOOL)isRegionUnitedStates {
    // checking device region settings. If it's US, the TIN/DOT option needs to be shown.
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return [countryCode isEqualToString:@"US"];
}

// MARK: - Setup

- (ALScanViewPlugin *)scanViewPluginForScanMode:(ALTINScanMode)scanMode {
    NSDictionary *JSONConfigObj = [self scanViewConfigDict:scanMode];
    
    NSError *error;
    ALScanViewConfig *scanViewConfig = [ALScanViewConfig withJSONDictionary:JSONConfigObj error:&error];

    if ([self popWithAlertOnError:error]) {
        return nil;
    }

    // Will edit this object before constructing an ALScanViewPlugin with it later

    ALViewPluginConfig *viewPluginConfig = scanViewConfig.viewPluginConfig;
    // TODO: test that scanViewPluginConfig is not null, otherwise, read the error and handle it and/or return nil
    
    // Change the mode...
    ALTinConfig *tinConfig = viewPluginConfig.pluginConfig.tinConfig;
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
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:viewPluginConfig error:&error];
    
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
        [self.scanView setViewPlugin:scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    }
    [self startScanning:nil];
}

- (void)reloadScanView {
    [self changeScanViewMode:(ALTINScanMode)self.dialogIndexSelected];
}

// MARK: - Getters

+ (NSArray<NSString *> *)recalledDOTs {
    return kRecalledDOTs;
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:scanResult.pluginResult.tinResult.text
                 barcodeResult:nil
                         image:[scanResult croppedImage]
                    scanPlugin:scanPlugin viewPlugin:self.scanViewPlugin completion:^{
        NSArray<ALResultEntry *> *resultData = [self.class resultDataFromScanResult:scanResult];
        
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        weakSelf.isOrientationFlipped = NO;
        [weakSelf enableLandscapeOrientation:NO];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

+ (NSArray<ALResultEntry *> *)resultDataFromScanResult:(ALScanResult *)scanResult {
    NSMutableArray *resultEntries = [NSMutableArray arrayWithArray:scanResult.pluginResult.fieldList.resultEntries];
    // would add a Tire on Recall entry if the result falls in one of the few values hardcoded here.
    BOOL needsRecalledEntry = NO;
    for (ALResultEntry *res in resultEntries) {
        if ([res.title isEqualToString:@"Tire Identification Number"]) {
            // if result somehow split the scan result string with spaces, remove them first.
            NSString *tin = [res.value stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([[self.class recalledDOTs] containsObject:tin]) {
                needsRecalledEntry = YES;
            }
        }
    }
    if (needsRecalledEntry) {
        // add it above the first entry
        [resultEntries insertObject:[ALResultEntry withTitle:@"Tire on Recall" value:@"YES"] atIndex:0];
    }
    return resultEntries;
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
        if (![self presentContactUsDialog]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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

- (BOOL)presentContactUsDialog {
#if __has_include("ALToolbarViewController.h")

    ALTINScanViewController __weak *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        ALSalesforceWebViewController *contactVC = [[ALSalesforceWebViewController alloc] initWithFormType:ALSalesforceFormTypeContactUs];
        contactVC.modalPresentationStyle = UIModalPresentationCurrentContext;
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
    return YES;

#endif
    return NO;
}



@end
