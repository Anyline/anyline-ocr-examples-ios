//
//  ALParallelMeterScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 21.11.19.
//

#import "ALParallelMeterScanViewController.h"
#import "ALAppDemoLicenses.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "UISwitch+ALExamplesAdditions.h"

@interface ALParallelMeterScanViewController ()<ALBarcodeScanPluginDelegate,ALMeterScanPluginDelegate,ALOCRScanPluginDelegate>

// The Anyline plugins used to scan
@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;
@property (nonatomic, strong) ALMeterScanPlugin *meterScanPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;
@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;
@property (nonatomic, strong) ALOCRScanViewPlugin *serialNumberScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *serialNumberScanPlugin;
@property (nonatomic, strong) ALParallelScanViewPluginComposite *parallelScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) NSString *barcodeResult;
@property (nonatomic, strong) NSString *serialNumberResult;
@property (nonatomic, strong) NSString *meterResult;
@property (nonatomic, strong) UIImage *meterImage;

@property (nonatomic, strong) UIView *enableBarcodeView;
@property (nonatomic, strong) UISwitch *enableBarcodeSwitch;
@property (nonatomic, strong) UILabel *enableBarcodeLabel;

@end

@implementation ALParallelMeterScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Analog/Digital Meter";
    
    CGRect frame = [self scanViewFrame];
    
    //Add Meter Scan Plugin (Scan Process)
    NSError *error = nil;
    self.meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:@"ENERGY" licenseKey:kDemoAppLicenseKey delegate:self error:&error];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALLine;
    
    config.validationRegex = @"[A-Z0-9]{4,}";
    self.serialNumberScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                                 licenseKey:kDemoAppLicenseKey
                                                                   delegate:self
                                                                  ocrConfig:config
                                                                      error:&error];
    NSAssert(self.serialNumberScanPlugin, @"Setup Error: %@", error.debugDescription);

    //use the full screen to scan the barcode, with feedback that can easily be distinguished from the meter scan feedback
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"meter_barcode_view_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.serialNumberScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.serialNumberScanPlugin
                                                                 scanViewPluginConfig:scanViewPluginConfig];
    
    NSAssert(self.meterScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    //Add Meter Scan View Plugin (Scan UI)
    self.meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:self.meterScanPlugin];
    
    
    //Set ScanMode to ALAutoAnalogDigitalMeter
    BOOL success = [self.meterScanPlugin setScanMode:ALAutoAnalogDigitalMeter error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [self showAlertWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription];
        
    }
    
    self.barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE" licenseKey:kDemoAppLicenseKey delegate:self error:&error];
    NSAssert(self.barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    //Set Barcode Formats
    [self.barcodeScanPlugin setBarcodeFormatOptions:ALCodeTypeAll];
    
    //Add Barcode Scan View Plugin (Scan UI)
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:self.barcodeScanPlugin scanViewPluginConfig:scanViewPluginConfig];
    
    self.parallelScanViewPlugin = [[ALParallelScanViewPluginComposite alloc] initWithPluginID:@"Energy with meter ID"];
    [self.parallelScanViewPlugin addPlugin:self.meterScanViewPlugin];
    //not adding this one yet as it scans too many things when fullscreen
    //[self.parallelScanViewPlugin addPlugin:self.serialNumberScanViewPlugin];
    [self.parallelScanViewPlugin addPlugin:self.barcodeScanViewPlugin];
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:[self selectedPlugin]]; //selectedPlugin when the switch doesn't exist yet is the same as when the switch is set to 'off'
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    //Adding the scanView
    [self.view addSubview:self.scanView];
    [self.scanView startCamera];
    
    BOOL enableReporting = [NSUserDefaults AL_reportingEnabled];
    [self.meterScanPlugin enableReporting:enableReporting];
    self.meterScanViewPlugin.translatesAutoresizingMaskIntoConstraints = NO;
    
    //After setup is complete we add the module to the view of this view controller
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];

    
    self.controllerType = ALScanHistoryElectricMeter;

    [self.view sendSubviewToBack:self.scanView];
    [self.scanView addSubview:[self createBarcodeSwitchView]];
    [self.scanView bringSubviewToFront:self.enableBarcodeView];
}

- (ALAbstractScanViewPlugin *)selectedPlugin {
    if (self.enableBarcodeSwitch.on) {
        return self.parallelScanViewPlugin;
    } else {
        return self.meterScanViewPlugin;
    }
}

- (void)setAsCurrentPlugin:(ALAbstractScanViewPlugin *)plugin {
    self.scanView.scanViewPlugin = plugin;
    [self stopPlugin:plugin]; //just in case it is already running for some reason
    [self startPlugin:plugin];
    [self.scanView bringSubviewToFront:self.enableBarcodeView];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAsCurrentPlugin:[self selectedPlugin]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
        
    [self updateLayoutBarcodeSwitchView];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.parallelScanViewPlugin stopAndReturnError:nil];
    [self.meterScanViewPlugin stopAndReturnError:nil];
}

#pragma mark - Barcode View layout
- (UIView *)createBarcodeSwitchView {
    //Add UISwitch for toggling barcode scanning
    self.enableBarcodeView = [[UIView alloc] init];
    self.enableBarcodeView.frame = CGRectMake(100, 100, 250, 50);
    
    self.enableBarcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.enableBarcodeLabel.text = @"Multi-field Detection\nBarcode";
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.enableBarcodeLabel.font = font;
    self.enableBarcodeLabel.numberOfLines = 0;
    
    self.enableBarcodeLabel.textColor = [UIColor whiteColor];
    [self.enableBarcodeLabel sizeToFit];
    
    self.enableBarcodeSwitch = [[UISwitch alloc] init];
    [self.enableBarcodeSwitch setOn:false];
    [self.enableBarcodeSwitch setOnTintColor:[UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.enableBarcodeSwitch useHighContrast];
    [self.enableBarcodeSwitch addTarget:self action:@selector(toggleBarcodeScanning:) forControlEvents:UIControlEventValueChanged];
    
    [self.enableBarcodeView addSubview:self.enableBarcodeLabel];
    [self.enableBarcodeView addSubview:self.enableBarcodeSwitch];
    
    return self.enableBarcodeView;
}

- (void)updateLayoutBarcodeSwitchView {
    NSInteger padding = 7;
    self.enableBarcodeLabel.center = CGPointMake(self.enableBarcodeLabel.frame.size.width/2,
                                                 self.enableBarcodeView.frame.size.height/2);

    self.enableBarcodeSwitch.center = CGPointMake(self.enableBarcodeLabel.frame.size.width + self.enableBarcodeSwitch.frame.size.width/2 + padding,
                                                  self.enableBarcodeView.frame.size.height/2);

    CGFloat width = self.enableBarcodeSwitch.frame.size.width + padding + self.enableBarcodeLabel.frame.size.width;
    self.enableBarcodeView.frame = CGRectMake(self.scanView.frame.size.width-width-15,
                                              self.scanView.frame.size.height-self.enableBarcodeView.frame.size.height-55,
                                              width,
                                              50);
}

- (void)displayResults {
    //stop scanning, since we don't need to scan the serial and the barcode, only one of them
    [self anylineDidFindResult:self.meterResult barcodeResult:self.barcodeResult image:self.meterImage scanPlugin:self.meterScanPlugin viewPlugin:self.parallelScanViewPlugin completion:^{
        //Display the result
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Meter Reading" value:self.meterResult]];
        if (self.barcodeResult) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode" value:self.barcodeResult]];
        } else if (self.serialNumberResult) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Serial Number" value:self.barcodeResult]];
        }
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:self.meterImage];
        NSError *error;
        [self.parallelScanViewPlugin stopAndReturnError:&error];
        [self.meterScanViewPlugin stopAndReturnError:&error];
        [self.navigationController pushViewController:vc animated:YES];

        //reset results (needs to be run inside the closure in case there is a delay from showing an award view)
        self.barcodeResult = nil;
        self.serialNumberResult = nil;
        self.meterResult = @"";
        self.meterImage = nil;
    }];
}

- (void)displayResultsIfPresent {
    if ([self.meterResult length]) {
        if (!self.enableBarcodeSwitch.on || self.barcodeResult || self.serialNumberResult) {
            [self displayResults];
        }
    }
}

- (void)stopPlugin:(ALAbstractScanViewPlugin *)plugin {
    NSError *error = nil;
    [plugin stopAndReturnError:&error];
     if (error) {
         [self showAlertWithTitle:@"Error stopping scanning"
                                     message:error.debugDescription];
     }
}

 - (IBAction)toggleBarcodeScanning:(id)sender {
     if (self.enableBarcodeSwitch.on) {
         [self stopPlugin:self.meterScanViewPlugin];
         [self stopPlugin:self.barcodeScanViewPlugin]; //in some rare cases this can still be running, which stops the parallel scan view plugin from starting
         [self setAsCurrentPlugin:self.parallelScanViewPlugin];
     } else {
         //we probably don't want to keep these values from when the switch was previously enabled
         self.barcodeResult = nil;
         self.serialNumberResult = nil;
         [self stopPlugin:self.parallelScanViewPlugin];
         if ([self.meterResult length]) {
             //if we already have a meter result, and we no longer need a barcode, display the results immediately rather than trying to scan the meter again.
             [self displayResultsIfPresent];
         } else {
             [self setAsCurrentPlugin:self.meterScanViewPlugin];
         }
     }
 }

- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult * _Nonnull)scanResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (scanResult.result) {
            self.barcodeResult = scanResult.result;
        } else {
            //if we get a nil barcode result for some reason, we don't want to just be stuck on the screen with no scanners running.
            self.barcodeResult = @"";
        }
        [self displayResultsIfPresent];
    });
}

- (void)anylineMeterScanPlugin:(ALMeterScanPlugin * _Nonnull)anylineMeterScanPlugin didFindResult:(ALMeterResult * _Nonnull)scanResult {
    self.meterResult = scanResult.result;
    self.meterImage = scanResult.image;
    [self displayResultsIfPresent];
}

- (void)anylineOCRScanPlugin:(ALOCRScanPlugin * _Nonnull)anylineOCRScanPlugin didFindResult:(ALOCRResult * _Nonnull)scanResult {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (scanResult.result) {
            self.serialNumberResult = scanResult.result;
        } else {
            self.serialNumberResult = @"";
        }
        [self displayResultsIfPresent];
    });
}


@end
