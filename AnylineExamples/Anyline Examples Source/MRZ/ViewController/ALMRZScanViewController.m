#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALMRZScanViewController.h"
#import "ALTutorialViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "NSString+Util.h"
#import "ALPluginResultHelper.h"

// The controller has to conform to <AnylineMRZModuleDelegate> to be able to receive results
@interface ALMRZScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSString *configJSONStr;

@end


@implementation ALMRZScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (self.title && self.title.length > 0) ? self.title : @"MRZ";
    self.controllerType = ALScanHistoryMrz;

    [self setupUI];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"mrz_config" ofType:@"json"];

    NSError *error;
    self.scanView = [ALScanViewFactory withConfigFilePath:path delegate:self error:&error];
    [self installScanView:self.scanView];
    [self.scanView startCamera];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScanning:nil];
}

- (void)setupUI {
    if (![[[NSBundle mainBundle] bundleIdentifier] localizedCaseInsensitiveContainsString:@"bundle"]) {
        UIBarButtonItem *infoBarItem;
        if (@available(iOS 13.0, *)) {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(infoPressed:)];
        } else {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(infoPressed:)];
        }
        self.navigationItem.rightBarButtonItem = infoBarItem;
        [self setColors];
    }
}

- (void)setColors {
    [super setColors];
    UIColor *tintColor = UIColor.blackColor;
    if (self.isDarkMode) {
        tintColor = UIColor.whiteColor;
    }
    self.navigationItem.rightBarButtonItem.tintColor = tintColor;
}

- (IBAction)infoPressed:(id)sender {
    ALTutorialViewController *vc = [[ALTutorialViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];
    NSArray<ALResultEntry *> *resultData = scanResult.pluginResult.fieldList.resultEntries;
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
