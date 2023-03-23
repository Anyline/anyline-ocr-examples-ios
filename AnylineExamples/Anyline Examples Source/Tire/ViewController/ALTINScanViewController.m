#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALConfigurationDialogViewController.h"
#import "AnylineExamples-Swift.h" // for ALResultEntry
#import "ALPluginResultHelper.h"

#if __has_include("ALContactUsViewController.h")
#import "ALContactUsViewController.h"
#endif

typedef enum {
    ALTINScanModeUniversal = 0,
    ALTINScanModeDOT
} ALTINScanMode;

NSString * const kALTINScanVC_configFilename = @"tire_tin_config";


@interface ALTINScanViewController () <ALScanPluginDelegate, ALConfigurationDialogViewControllerDelegate>

// TODO: most of these can go to a superclass.
@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@property () NSUInteger dialogIndexSelected;


@end

@implementation ALTINScanViewController

- (void)dealloc {
    // NSLog(@"dealloc ALTINScanViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TIN";
    self.controllerType = ALScanHistoryTIN;

    self.dialogIndexSelected = 0;
    [self setupNavigationBar];
    
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:self.scanViewConfigDict error:nil];
    [self setUpScanMode:ALTINScanModeUniversal];
    
    NSError *error;
    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.scanViewPlugin
                                       scanViewConfig:self.scanViewConfig
                                                error:&error];
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    [self installScanView:self.scanView];
    
    [self.scanView startCamera];

    [self setupFlipOrientationButton];

    // starts in landscape mode (APP-383)
    self.isOrientationFlipped = YES;
    [self enableLandscapeOrientation:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanViewPlugin startWithError:nil];
}

// MARK: - Getters and Setters

- (NSDictionary *)scanViewConfigDict {
    return [[self configJSONStrWithFilename:kALTINScanVC_configFilename] asJSONObject];
}

// MARK: - Setup

- (void)setUpScanMode:(ALTINScanMode)scanMode {
    
    NSDictionary *JSONConfigObj = self.scanViewConfigDict;
    
    // Will edit this object before constructing an ALScanViewPlugin with it later
    ALScanViewPluginConfig *scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithJSONDictionary:JSONConfigObj error:nil];
    
    // Change the mode...
    ALTinConfig *tinConfig = scanViewPluginConfig.scanPluginConfig.pluginConfig.tinConfig;
    tinConfig.scanMode = ALTinConfigScanMode.universal;
    switch (scanMode) {
        case ALTINScanModeUniversal:
            tinConfig.scanMode = ALTinConfigScanMode.universal;
            break;
        case ALTINScanModeDOT:
            tinConfig.scanMode = ALTinConfigScanMode.dot; //or .dotStrict?
            break;
        default: break;
    }
    
    // Recreate the ScanViewPlugin. Since this is a different ScanViewPlugin than
    // the previous one, reset the delegate.
    NSError *error;
    self.scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:&error];
    
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    ALScanViewPlugin *scanViewPlugin = self.scanViewPlugin;
    scanViewPlugin.scanPlugin.delegate = self;
}

- (void)changeScanViewMode:(ALTINScanMode)scanMode {
    [self.scanViewPlugin stop];
    [self setUpScanMode:scanMode];
    
    NSError *error;
    if (!self.scanView) {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:self.scanViewPlugin
                                           scanViewConfig:self.scanViewConfig
                                                    error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
        [self.scanView startCamera];
    } else {
        [self.scanView setScanViewPlugin:self.scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self.scanView startCamera];
    }
    [self.scanViewPlugin startWithError:nil];
}

// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    
    [self enableLandscapeOrientation:NO];
    
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:scanResult.pluginResult.tinResult.text
                 barcodeResult:nil
                         image:[scanResult croppedImage]
                    scanPlugin:scanPlugin viewPlugin:self.scanViewPlugin completion:^{
        NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = scanResult.croppedImage;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

// MARK: - Allow changing the scan mode

- (void)showOptionsSelectionDialog {
    NSArray<NSString *> *choices = @[
        @"Universal TIN/DOT",
        @"TIN/DOT (North America only)",
        @"Other tire sidewall information"
    ];
    NSArray<NSNumber *> *selections = @[@(self.dialogIndexSelected)];
    ALConfigurationDialogViewController *vc = [[ALConfigurationDialogViewController alloc]
                                               initWithChoices:choices
                                               selections:selections
                                               secondaryTexts:@[]
                                               showApplyBtn:NO
                                               dialogType:ALConfigDialogTypeScriptSelection];
    vc.delegate = self;
    [vc setSelectionDialogFontSize:16.0];
    [self presentViewController:vc animated:YES completion:nil];
    [self.scanView stopCamera];
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.dialogIndexSelected = index;
            [self changeScanViewMode:ALTINScanModeUniversal];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1:
            self.dialogIndexSelected = index;
            [self changeScanViewMode:ALTINScanModeDOT];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2:
            [self presentContactUsDialog];
            break;
    }
}

// MARK: - Miscellaneous

- (void)setupNavigationBar {
    UIBarButtonItem *scanModeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showOptionsSelectionDialog)];
    self.navigationItem.rightBarButtonItem = scanModeButton;
}

- (void)presentContactUsDialog {
    ALTINScanViewController __weak *weakSelf = self;
#if __has_include("ALContactUsViewController.h")
    [self dismissViewControllerAnimated:YES completion:^{
        ALContactUsViewController *contactVC = [[ALContactUsViewController alloc] init];
        [weakSelf presentViewController:contactVC animated:YES completion:nil];
        [contactVC setPresentationBlock:^{
            [weakSelf.scanView startCamera];
        }];
    }];
#endif
}

@end
