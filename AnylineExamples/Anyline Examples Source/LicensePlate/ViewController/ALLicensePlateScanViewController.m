#import "ALLicensePlateScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALPluginResultHelper.h"

@interface ALLicensePlateScanViewController () <ALScanPluginDelegate>

@property (nonatomic, strong) id<ALScanViewPluginBase> scanViewPlugin;

@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, readonly) NSString *configJSONStr;

@end


NSString * const kLicensePlateScanVC_configEU = @"vehicle_config_license_plate_eu";
NSString * const kLicensePlateScanVC_configUS = @"vehicle_config_license_plate_us";
NSString * const kLicensePlateScanVC_configAF = @"vehicle_config_license_plate_af";

@implementation ALLicensePlateScanViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.title would have been set based on values from ALLicensePlateManager
    NSString *licensePlateConfigJSONFile = kLicensePlateScanVC_configEU;
    if ([self.title isEqualToString:@"US License Plate"]) {
        licensePlateConfigJSONFile = kLicensePlateScanVC_configUS;
    } else if ([self.title isEqualToString:@"African License Plate"] || [self.title isEqualToString:@"AF License Plate"]) {
        licensePlateConfigJSONFile = kLicensePlateScanVC_configAF;
    }
    
    id JSONConfigObj = [[self configJSONStrWithFilename:licensePlateConfigJSONFile] asJSONObject];

    self.scanViewPlugin = [ALScanViewPluginFactory withJSONDictionary:JSONConfigObj];
    
    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:JSONConfigObj error:nil];

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.scanViewPlugin
                                       scanViewConfig:self.scanViewConfig
                                                error:nil];
    
    [self installScanView:self.scanView];

    ALScanViewPlugin *scanViewPlugin = self.scanViewPlugin;

    scanViewPlugin.scanPlugin.delegate = self;

    [self.scanView startCamera];
    
    self.controllerType = ALScanHistoryLicensePlates;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self.scanViewPlugin startWithError:nil];
}


// MARK: - Handle & present results

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    [self enableLandscapeOrientation:NO];
    ALLicensePlateResult *result = scanResult.pluginResult.licensePlateResult;

    NSArray <ALResultEntry *> *resultData = result.resultEntryList;
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

// TODO: (ACO) decide if we still need them
//- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
//    if ([info.variableName isEqualToString:@"$brightness"]) {
//        [self updateBrightness:[info.value floatValue] forModule:self.licensePlateScanViewPlugin];
//    } else if ([info.variableName isEqualToString:@"$square"] && info.value) {
//        //the visual feedback shows we have found a potential license plate, so let's give some feedback on VoiceOver too.
//        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"License Plate");
//    }
//
//}

@end
