#import "ALTINScanWithUIFeedbackViewController.h"

#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h" // for ALResultEntry
#import "ALTinScanRecalledDOTs.h"

NSString * const kALTINScanVC_uiFeedback_configFilename = @"tire_tin_universal_uifeedback_config";

@interface ALTINScanWithUIFeedbackViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSDictionary *scanViewConfigDict;

@property (nonatomic, readonly) NSArray<NSString *> *recalledDOTs;

@end


@implementation ALTINScanWithUIFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Universal Tire (DOT/TIN)";
    self.controllerType = ALScanHistoryTIN;

    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:self.scanViewConfigDict error:nil];

    [self reloadScanView];

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
    return [[self configJSONStrWithFilename:kALTINScanVC_uiFeedback_configFilename] asJSONObject];
}

// MARK: - Setup

- (ALScanViewPlugin *)getScanViewPlugin {
    NSDictionary *JSONConfigObj = self.scanViewConfigDict;
    
    // Will edit this object before constructing an ALScanViewPlugin with it later
    NSError *error;
    ALScanViewPluginConfig *scanViewPluginConfig = [[ALScanViewPluginConfig alloc] initWithJSONDictionary:JSONConfigObj error:&error];
    if ([self popWithAlertOnError:error]) {
        return nil;
    }

    // Recreate the ScanViewPlugin. Since this is a different ScanViewPlugin than
    // the previous one, reset the delegate.
    ALScanViewPlugin *scanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:&error];
    if ([self popWithAlertOnError:error]) {
        return nil;
    }
    
    scanViewPlugin.scanPlugin.delegate = self;
    return scanViewPlugin;
}

- (void)reloadScanView {
    [self stopScanning];
    ALScanViewPlugin *scanViewPlugin = [self getScanViewPlugin];

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

@end
