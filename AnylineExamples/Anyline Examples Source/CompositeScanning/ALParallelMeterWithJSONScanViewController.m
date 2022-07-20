#import "ALParallelMeterWithJSONScanViewController.h"
#import "UIViewController+ALExamplesAdditions.h"

const bool parallel_scan_view_uses_json_config_for_setup = true;
NSString * const parallel_scan_plugin_config_json_filename = @"meter_barcode_parallel"; // without the .json extension

@interface ALParallelMeterWithJSONScanViewController () <ALBarcodeScanPluginDelegate, ALMeterScanPluginDelegate, ALCompositeScanPluginDelegate>

@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;

@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;

@property (nonatomic, strong) ALParallelScanViewPluginComposite *parallelScanViewPlugin;

@property (nonatomic, strong) ALScanView *scanView;

@end


@implementation ALParallelMeterWithJSONScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Parallel Meter and Barcode Scanning";
    [self setupAndStartPlugins];
}

- (void)setupAndStartPlugins {

    if (parallel_scan_view_uses_json_config_for_setup) {
        [self setupPluginsWithJSON];
    } else {
        [self setupPluginsWithManually];
    }

    NSAssert(self.parallelScanViewPlugin, @"parallelScanViewPlugin was not set up properly!");

    self.scanView = [[ALScanView alloc] initWithFrame:[self scanViewFrame]
                                       scanViewPlugin:self.parallelScanViewPlugin];

    [self.view addSubview:self.scanView];

    [self.scanView startCamera];

    [self.parallelScanViewPlugin startAndReturnError:nil];
}

- (void)setupPluginsWithJSON {

    NSError *error = nil;

    // NOTE: we made an assumption here that the JSON is an appropriately-defined config of
    // a parallel scan view with two members: a barcode scan plugin and a meter scan plugin.

    self.parallelScanViewPlugin = (ALParallelScanViewPluginComposite *)[ALAbstractScanViewPluginComposite
                                   scanViewPluginForConfigDict:self.configDict
                                   delegate:self
                                   error:&error];

    for (ALAbstractScanViewPlugin *scanPlugin in self.parallelScanViewPlugin.childPlugins) {
        if ([scanPlugin isKindOfClass:ALBarcodeScanViewPlugin.class]) {
            self.barcodeScanViewPlugin = (ALBarcodeScanViewPlugin *)scanPlugin;
        } else if ([scanPlugin isKindOfClass:ALMeterScanViewPlugin.class]) {
            self.meterScanViewPlugin = (ALMeterScanViewPlugin *)scanPlugin;
        }
    }

    // (Optional) If desired, you may set scan delegates for individual scan view plugins,
    // allowing you to read scan results individually as they detected:
    NSAssert(self.barcodeScanViewPlugin != nil, @"barcodeScanViewPlugin should not be nil");
    NSAssert(self.meterScanViewPlugin != nil, @"meterScanViewPlugin should not be nil");

    [self.barcodeScanViewPlugin.barcodeScanPlugin addDelegate:self];
    [self.meterScanViewPlugin.meterScanPlugin addDelegate:self];

}

- (void)setupPluginsWithManually {

    // you can set up the parallel scan without a JSON config file, if you wish.
    NSError *error = nil;

    // Meter Plugin
    ALMeterScanPlugin *meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:@"METER"
                                                                            delegate:self
                                                                               error:&error];
    self.meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:meterScanPlugin];

    // Barcode Plugin
    ALBarcodeScanPlugin *barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE"
                                                                                  delegate:self
                                                                                     error:&error];
    [barcodeScanPlugin setBarcodeFormatOptions:@[ kCodeTypeAll ]];
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc]
                                  initWithScanPlugin:barcodeScanPlugin];

    // Parallel Scan View Plugin
    self.parallelScanViewPlugin = [[ALParallelScanViewPluginComposite alloc]
                                   initWithPluginID:@"Energy and Meter Parallel"];

    // (Optional) - make certain child plugins return without a scan result after a timeout
    //
    // A timeout delay determines how long the parallel plugin waits for any "optional"
    // child plugins to be scanned, before ignoring them. After all non-optional child plugins
    // have already been scanned, the parallel scan plugin waits for an extra, predetermined
    // time period (the so-called timeout delay), and then returns with all the results gathered
    // up to that point through its delegate. NOTE: To use it, at least one child plugin must
    // have been marked as optional when adding to it. Otherwise all child plugins are waited
    // on before the delegate callback is invoked.

    // When not explicitly set, the default delay is 3.0 seconds.
    self.parallelScanViewPlugin.optionalTimeoutDelay = @3.5;

    // You can make a member ScanViewPlugin (in this case, for the barcode) by setting its
    // isOptional property to YES. (NOTE: make sure to set this BEFORE it is added to the
    // parallel plugin.)
    self.barcodeScanViewPlugin.isOptional = YES;

    // Add the component plugins.
    [self.parallelScanViewPlugin addPlugin:self.meterScanViewPlugin];
    [self.parallelScanViewPlugin addPlugin:self.barcodeScanViewPlugin];

    // make oneself a ALCompositeScanPluginDelegate (for the aggregated results)
    [self.parallelScanViewPlugin addDelegate:self];
}

- (void)displayResults:(NSString *)resultsMsg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Results"
                                                                             message:resultsMsg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak __block typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf.parallelScanViewPlugin startAndReturnError:nil];
    }]];

    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (NSDictionary * _Nonnull)configDict {
    // read the JSON config file
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:parallel_scan_plugin_config_json_filename
                                                             ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonFilePath];

    NSError *error = nil;
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    NSAssert(configDict != nil, @"unable to read configuration JSON file!");
    return configDict;
}

// MARK: - ALCompositeScanPluginDelegate

- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite * _Nonnull)anylineCompositeScanPlugin
                     didFindResult:(ALCompositeResult * _Nonnull)scanResult {

    // this method is executed when all 'required' component plugins have
    // been scanned.

    NSMutableArray<NSString *> *resultStrs = [NSMutableArray arrayWithCapacity:2];
    for (NSString *key in scanResult.result.allKeys) {
        id res = scanResult.result[key];
        if ([res isKindOfClass:ALMeterResult.class]) {
            [resultStrs addObject:
             [NSString stringWithFormat:@"meter result: %@",
              [(ALMeterResult *)res result]]
            ];
        } else if ([res isKindOfClass:ALBarcodeResult.class]) {
            [resultStrs addObject:
             [NSString stringWithFormat:@"barcode result: %@",
              [(ALBarcodeResult *)res result].firstObject.value]
            ];
        }
    }
    NSString *message = [resultStrs componentsJoinedByString:@" | "];
    NSLog(@"Parallel Scan: aggregate result: %@", message);
    [self displayResults:message];
}

// MARK: - ALBarcodeScanPluginDelegate

- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin
                   didFindResult:(ALBarcodeResult * _Nonnull)scanResult {
    NSString *barcodeResultStr = [[scanResult.result firstObject] value];

    // by setting a ALBarcodeScanPluginDelegate you can detect a barcode scan before the
    // composite (parallel) plugin delegate is called.
    NSLog(@"Parallel Scan: barcode result: %@", barcodeResultStr);
}


// MARK: - ALMeterScanPluginDelegate

- (void)anylineMeterScanPlugin:(ALMeterScanPlugin * _Nonnull)anylineMeterScanPlugin
                 didFindResult:(ALMeterResult * _Nonnull)scanResult {

    // by setting a ALMeterScanPluginDelegate you can detect a meter scan before the
    // composite (parallel) plugin delegate is called.
    NSString *meterResultStr = scanResult.result;
    NSLog(@"Parallel Scan: meter result: %@", meterResultStr);
}

@end
