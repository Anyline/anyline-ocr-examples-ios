#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALMRZScanViewController.h"
#import "ALTutorialViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "NSString+Util.h"
#import "ALPluginResultHelper.h"

// The controller has to conform to <AnylineMRZModuleDelegate> to be able to receive results
@interface ALMRZScanViewController () <ALScanPluginDelegate>

// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) id<ALScanViewPluginBase> scanViewPlugin;

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSString *configJSONStr;


@end

@implementation ALMRZScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (self.title && self.title.length > 0) ? self.title : @"MRZ";
    [self setColors];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startMRZScanMode];
}

- (void)startMRZScanMode {
    if (![[[NSBundle mainBundle] bundleIdentifier] localizedCaseInsensitiveContainsString:@"bundle"]) {
        UIBarButtonItem *infoBarItem;
        if (@available(iOS 13.0, *)) {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(infoPressed:)];
        } else {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStylePlain target:self action:@selector(infoPressed:)];
        }
        self.navigationItem.rightBarButtonItem = infoBarItem;
        [self setColors];
    }
    
    id JSONConfigObj = [[self configJSONStrWithFilename:@"mrz_config"] asJSONObject];
    
    NSError *error;
    self.scanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:JSONConfigObj error:&error];
    
    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:JSONConfigObj error:nil];
    
    if (self.scanView) {
        [self.scanView setScanViewPlugin:self.scanViewPlugin error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
    } else {
        self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                           scanViewPlugin:self.scanViewPlugin
                                           scanViewConfig:self.scanViewConfig
                                                    error:&error];
        if ([self popWithAlertOnError:error]) {
            return;
        }
        [self installScanView:self.scanView];
    }
    ALScanViewPlugin *scanViewPlugin = self.scanViewPlugin;
    
    scanViewPlugin.scanPlugin.delegate = self;
    
    [self.scanView startCamera];
    
    self.controllerType = ALScanHistoryMrz;
    
    [self.scanViewPlugin startWithError:nil];
}

- (void)setColors {
    [super setColors];
    UIColor *tintColor = UIColor.blackColor;
    if (self.isDarkMode) {
        tintColor = UIColor.whiteColor;
    }
    self.navigationItem.rightBarButtonItem.tintColor = tintColor;
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanViewPlugin stop];
}

- (IBAction)infoPressed:(id)sender {
    ALTutorialViewController *vc = [[ALTutorialViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];
    NSArray <ALResultEntry *> *resultData = scanResult.pluginResult.mrzResult.resultEntryList;
    NSString *resultJSON = [ALResultEntry JSONStringFromList:resultData];
    
    __weak __block ALMRZScanViewController *weakSelf = self;
    
    [self anylineDidFindResult:resultJSON
                 barcodeResult:nil
                     faceImage:scanResult.faceImage
                        images:@[scanResult.croppedImage]
                    scanPlugin:scanPlugin
                    viewPlugin:self.scanViewPlugin completion:^{
        
        
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imageFace = scanResult.faceImage;
        vc.imagePrimary = scanResult.croppedImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    }];
}

@end
