//
//  ALParallelMeterScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 21.11.19.
//

#import "ALParallelMeterScanViewController.h"

#import "AnylineExamples-Swift.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "UISwitch+ALExamplesAdditions.h"

// In a parallel setup with meter, time allowed to check barcode before results are turned in
const NSTimeInterval kBarcodeInParallelTimeout = 1.0;
NSString * const kMeterScanViewPluginID = @"ENERGY";
NSString * const kBarcodeScanViewPluginID = @"BARCODE";
NSString * const kParallelScanViewPluginID = @"PARALLEL (Energy + Barcode)";

@interface ALParallelMeterScanViewController() <ALMeterScanPluginDelegate, ALCompositeScanPluginDelegate, ALBarcodeScanPluginDelegate>

@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;
@property (nonatomic, strong) ALParallelScanViewPluginComposite *parallelScanViewPlugin;

@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) NSString *barcodeResultStr;
@property (nonatomic, strong) NSString *meterResultStr;
@property (nonatomic, strong) UIImage *meterImage;

@property (nonatomic, strong) UIView *enableBarcodeSwitchView;
@property (nonatomic, strong) UISwitch *enableBarcodeSwitch;
@property (nonatomic, strong) UILabel *enableBarcodeLabel;

@end

@implementation ALParallelMeterScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // ALMeterCollectionViewController can give it its title
    if (!self.title.length) {
        self.title = @"Analog/Digital Meter";
    }

    ALScanMode scanMode = ALAutoAnalogDigitalMeter;
    if ([self.title isEqualToString:@"Digital (APAC)"]) {
        scanMode = ALDigitalMeter2Experimental;
    }
    
    NSError *error = nil;
    ALMeterScanPlugin *meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:kMeterScanViewPluginID
                                                                            delegate:self
                                                                               error:&error];
    NSAssert(meterScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    // Set ScanMode to ALAutoAnalogDigitalMeter
    BOOL success = [meterScanPlugin setScanMode:scanMode error:&error];
    if (!success) {
        __weak __block typeof(self) weakSelf = self;
        [self showAlertWithTitle:@"Set ScanMode Error" message:error.debugDescription completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    self.meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:meterScanPlugin];

    // since barcode cutout region (full screen) doesn't match meter, we will disable have both's cutout
    // BG colors be clear so as to avoid having visible areas where the cutout mask don't intersect while
    // parallel scanning mode is on.
    ALScanViewPluginConfig *meterScanViewPluginConfig = [ALScanViewPluginConfig defaultMeterConfig];
    meterScanViewPluginConfig.cutoutConfig.backgroundColor = [UIColor clearColor];
    self.meterScanViewPlugin.scanViewPluginConfig  = meterScanViewPluginConfig;

    ALBarcodeScanPlugin *barcodeScanPlugin = [[ALBarcodeScanPlugin alloc]
                                              initWithPluginID:kBarcodeScanViewPluginID
                                              delegate:self // we don't needed this, but must
                                              error:&error];

    NSAssert(barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    [barcodeScanPlugin setBarcodeFormatOptions:@[kCodeTypeAll]];
    
    ALScanViewPluginConfig *barcodeScanViewPluginConfig = [self.class barcodeScanViewPluginConfig];
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:barcodeScanPlugin
                                                                scanViewPluginConfig:barcodeScanViewPluginConfig];
    
    // In a parallel scan setup, this means that the scan view will wait only a short period,
    // (i.e., kBarcodeInParallelTimeout) for the barcode to be scanned, before giving up and
    // returning the composite result: in this situation, with only the meter result.
    [self.barcodeScanViewPlugin setIsOptional:YES];
    
    self.parallelScanViewPlugin = [[ALParallelScanViewPluginComposite alloc]
                                   initWithPluginID:kParallelScanViewPluginID];
    [self.parallelScanViewPlugin addPlugin:self.meterScanViewPlugin];
    [self.parallelScanViewPlugin addPlugin:self.barcodeScanViewPlugin];
    [self.parallelScanViewPlugin addDelegate:self];
    [self.parallelScanViewPlugin setOptionalTimeoutDelay:@(kBarcodeInParallelTimeout)];
    
    CGRect frame = [self scanViewFrame];
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:[self selectedPlugin]];
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.scanView enableZoomPinchGesture:YES];
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];

    NSArray *scanViewConstraints = @[
        [self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scanView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
        [self.scanView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
        [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ];
    [self.view addConstraints:scanViewConstraints];
    [NSLayoutConstraint activateConstraints:scanViewConstraints];
    
    // Barcode Switch
    [self.scanView addSubview:[self createBarcodeSwitchView]];
    [self.scanView bringSubviewToFront:self.enableBarcodeSwitchView];
    
    self.controllerType = ALScanHistoryElectricMeter;
    
    [self.scanView startCamera];
}

+ (ALScanViewPluginConfig *)barcodeScanViewPluginConfig {
    ALScanViewPluginConfig *barcodeScanViewPluginConfig = [ALScanViewPluginConfig defaultBarcodeConfig];
    barcodeScanViewPluginConfig.cutoutConfig = [ALCutoutConfig defaultCutoutConfig];
    barcodeScanViewPluginConfig.cutoutConfig.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1024, 1920)];
    barcodeScanViewPluginConfig.cutoutConfig.strokeWidth = 0; // hide this
    barcodeScanViewPluginConfig.cutoutConfig.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    barcodeScanViewPluginConfig.cutoutConfig.cornerRadius = 0;
    barcodeScanViewPluginConfig.cutoutConfig.alignment = ALCutoutAlignmentMiddle;
    barcodeScanViewPluginConfig.scanFeedbackConfig.strokeWidth = 0;
    barcodeScanViewPluginConfig.scanFeedbackConfig.beepOnResult = NO;
    barcodeScanViewPluginConfig.scanFeedbackConfig.vibrateOnResult = NO;
    barcodeScanViewPluginConfig.scanFeedbackConfig.fillColor = [UIColor clearColor];
    barcodeScanViewPluginConfig.scanFeedbackConfig.strokeColor = [UIColor clearColor];
    return barcodeScanViewPluginConfig;
}

// MARK: - UIViewController Lifecycle Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAsCurrentPlugin:[self selectedPlugin]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateLayoutBarcodeSwitchView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.parallelScanViewPlugin stopAndReturnError:nil];
    [self.meterScanViewPlugin stopAndReturnError:nil];
    [self.barcodeScanViewPlugin stopAndReturnError:nil];
}

// MARK: - Plugin Control

- (ALAbstractScanViewPlugin *)selectedPlugin {
    if (self.enableBarcodeSwitch.on) {
        return self.parallelScanViewPlugin;
    } else {
        return self.meterScanViewPlugin;
    }
}

- (void)setAsCurrentPlugin:(ALAbstractScanViewPlugin *)plugin {
    [self stopPlugin:plugin];
    self.scanView.scanViewPlugin = plugin;
    [self startPlugin:plugin];
    [self.scanView bringSubviewToFront:self.enableBarcodeSwitchView];
}

- (void)stopPlugin:(ALAbstractScanViewPlugin *)plugin {
    NSError *error = nil;
    [plugin stopAndReturnError:&error];
    if (error) {
        [self showAlertWithTitle:@"Error stopping scanning"
                         message:error.debugDescription
                      completion:nil];
    }
}

#pragma mark - View Layout

- (UIView *)createBarcodeSwitchView {
    // Add UISwitch for toggling barcode scanning
    self.enableBarcodeSwitchView = [[UIView alloc] init];
    self.enableBarcodeSwitchView.frame = CGRectMake(100, 100, 250, 50);
    
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.enableBarcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.enableBarcodeLabel.font = font;
    self.enableBarcodeLabel.text = @"Barcode Detection";
    self.enableBarcodeLabel.numberOfLines = 0;
    self.enableBarcodeLabel.textColor = [UIColor whiteColor];
    [self.enableBarcodeLabel sizeToFit];
    
    self.enableBarcodeSwitch = [[UISwitch alloc] init];
    [self.enableBarcodeSwitch setOn:false];
    [self.enableBarcodeSwitch setOnTintColor:[UIColor colorWithRed:0.0/255.0
                                                             green:153.0/255.0
                                                              blue:255.0/255.0
                                                             alpha:1.0]];
    [self.enableBarcodeSwitch useHighContrast];
    [self.enableBarcodeSwitch addTarget:self action:@selector(toggleBarcodeScanning:)
                       forControlEvents:UIControlEventValueChanged];
    
    [self.enableBarcodeSwitchView addSubview:self.enableBarcodeLabel];
    [self.enableBarcodeSwitchView addSubview:self.enableBarcodeSwitch];
    
    return self.enableBarcodeSwitchView;
}

- (void)updateLayoutBarcodeSwitchView {
    CGFloat padding = 7.0f;
    
    self.enableBarcodeLabel.center = CGPointMake(self.enableBarcodeLabel.frame.size.width / 2,
                                                 self.enableBarcodeSwitchView.frame.size.height / 2);
    
    self.enableBarcodeSwitch.center = CGPointMake(self.enableBarcodeLabel.frame.size.width +
                                                  self.enableBarcodeSwitch.frame.size.width / 2 + padding,
                                                  self.enableBarcodeSwitchView.frame.size.height / 2);
    
    CGFloat width = (self.enableBarcodeSwitch.frame.size.width +
                     padding +
                     self.enableBarcodeLabel.frame.size.width);
    
    self.enableBarcodeSwitchView.frame = CGRectMake(self.scanView.frame.size.width - width - 15,
                                              self.scanView.frame.size.height - self.enableBarcodeSwitchView.frame.size.height - 55,
                                              width, 50);
}

// MARK: - Results Handling

- (void)displayResults {
    
    NSMutableArray<ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Meter Reading" value:self.meterResultStr]];
    if (self.barcodeResultStr) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode" value:self.barcodeResultStr
                                               shouldSpellOutValue:YES]];
    }

    NSString *jsonString = [self jsonStringFromResultData:resultData];

    __weak __block typeof(self) weakSelf = self;
    // stop scanning, since we don't need to scan the serial and the barcode, only one of them
    [self anylineDidFindResult:jsonString
                 barcodeResult:self.barcodeResultStr
                         image:self.meterImage
                    scanPlugin:self.meterScanViewPlugin.meterScanPlugin
                    viewPlugin:self.parallelScanViewPlugin completion:^{

        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = weakSelf.meterImage;

        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSError *error;
        [self.parallelScanViewPlugin stopAndReturnError:&error];
        [self.meterScanViewPlugin stopAndReturnError:&error];
        [self.barcodeScanViewPlugin stopAndReturnError:&error];
        
        // reset results (needs to be run inside the closure in case there is a delay
        // from showing an award view)
        self.barcodeResultStr = nil;
        self.meterResultStr = @"";
        self.meterImage = nil;
    }];
}

// MARK: - ScanViewPluginDelegate Methods

// Meter can go alone or with barcode in a parallel (hence shall need its own delegate),
// but barcode when returned by a delegate is always as child of parallel
- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite *)compositeScanPlugin
                     didFindResult:(ALCompositeResult *)scanResult {
    NSDictionary *composite = (NSDictionary *)scanResult.result;
    ALBarcode *barcodeResult = [[composite[@"BARCODE"] result] firstObject];
    ALMeterResult *meterResult = composite[@"ENERGY"];
    
    if (!meterResult) { // it's fine for barcode to be nil because it's optional
        return;
    }
    
    [self stopPlugin:compositeScanPlugin];
    
    self.barcodeResultStr = [barcodeResult value];
    if (self.barcodeResultStr == nil) {
        // if we can't get barcode from this delegate we are going to make that known
        // explicitly on the results
        self.barcodeResultStr = @"";
    }
    
    self.meterResultStr = meterResult.result;
    self.meterImage = meterResult.image;
    
    [self displayResults];
}

- (void)anylineMeterScanPlugin:(ALMeterScanPlugin * _Nonnull)anylineMeterScanPlugin
                 didFindResult:(ALMeterResult * _Nonnull)scanResult {
    
    if (self.enableBarcodeSwitch.on) {
        return;
    }
    
    self.meterResultStr = scanResult.result;
    self.meterImage = scanResult.image;
    
    [self displayResults];
}

- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult*_Nonnull)scanResult {
    // do nothing here - barcode result handling should now be exclusively handled by
    // `anylineCompositeScanPlugin:didFindResult:`.
}

// MARK: - IBActions

- (IBAction)toggleBarcodeScanning:(id)sender {
    UISwitch *switcher = sender;
    switcher.enabled = NO;
    switcher.alpha = 0.5;
    
    if (self.enableBarcodeSwitch.on) {
        // going to use parallel scanning (meter and barcode)
        [self stopPlugin:self.meterScanViewPlugin];
        [self stopPlugin:self.barcodeScanViewPlugin];
        [self setAsCurrentPlugin:self.parallelScanViewPlugin];
    } else {
        // revert to simple old meter scanning
        self.barcodeResultStr = nil;
        [self stopPlugin:self.parallelScanViewPlugin];
        if ([self.meterResultStr length]) {
            // if we already have a meter result, and we no longer need a barcode, display
            // the results immediately rather than trying to scan the meter again.
            [self displayResults];
        } else {
            [self setAsCurrentPlugin:self.meterScanViewPlugin];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switcher.enabled = YES;
        switcher.alpha = 1;
    });
}

@end
