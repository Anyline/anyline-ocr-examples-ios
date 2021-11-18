//
//  ALDialMeterScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Mueller on 03/07/17.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//


#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALDialMeterScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultViewController.h"
#import "UISwitch+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

static const NSInteger padding = 7;

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALDialMeterScanViewController ()<ALMeterScanPluginDelegate, ALBarcodeScanPluginDelegate>

// The Anyline plugins used to scan
@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;
@property (nonatomic, strong) ALMeterScanPlugin *meterScanPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;
@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;
@property (nonatomic, strong) ALParallelScanViewPluginComposite *parallelScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

//Native barcode scanning properties
@property (nonatomic, strong) NSString *barcodeResult;
@property (nonatomic, strong) NSString *meterResult;
@property (nonatomic, strong) UIImage *meterImage;

@property (nonatomic, strong) UIView *enableBarcodeView;
@property (nonatomic, strong) UISwitch *enableBarcodeSwitch;
@property (nonatomic, strong) UILabel *enableBarcodeLabel;

@end

@implementation ALDialMeterScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Dial Meter";
    CGRect frame = [self scanViewFrame];
    
    //Add Meter Scan Plugin (Scan Process)
    NSError *error = nil;
    self.meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:@"ENERGY" delegate:self error:&error];
    NSAssert(self.meterScanPlugin, @"Setup Error: %@", error.debugDescription);
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"meter_barcode_view_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    //Add Meter Scan View Plugin (Scan UI)
    self.meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:self.meterScanPlugin];
    
    
    //Set ScanMode to ALAutoAnalogDigitalMeter
    BOOL success = [self.meterScanPlugin setScanMode:ALDialMeter error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [self showAlertWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription];
        
    }
    
    self.barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE" delegate:self error:&error];
    NSAssert(self.barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    //Set Barcode Formats
    [self.barcodeScanPlugin setBarcodeFormatOptions:@[kCodeTypeAll]];
    
    //Add Barcode Scan View Plugin (Scan UI)
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:self.barcodeScanPlugin scanViewPluginConfig:scanViewPluginConfig];
    
    self.parallelScanViewPlugin = [[ALParallelScanViewPluginComposite alloc] initWithPluginID:@"Energy with meter ID"];
    [self.parallelScanViewPlugin addPlugin:self.meterScanViewPlugin];
    [self.parallelScanViewPlugin addPlugin:self.barcodeScanViewPlugin];
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:[self selectedPlugin]];
    
    //Adding the scanView
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    NSArray *scanViewConstraints = @[[self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                     [self.scanView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
                                     [self.scanView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
                                     [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
    [self.view addConstraints:scanViewConstraints];
    [NSLayoutConstraint activateConstraints:scanViewConstraints];
    
    [self.scanView startCamera];
    
    BOOL enableReporting = [NSUserDefaults AL_reportingEnabled];
    [self.meterScanPlugin enableReporting:enableReporting];
    self.meterScanViewPlugin.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the scanView to the view of this view controller
    self.controllerType = ALScanHistoryElectricMeter;
    [self.scanView addSubview:[self createBarcodeSwitchView]];
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
    [super viewWillDisappear:animated];
    [[self selectedPlugin] stopAndReturnError:nil];
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

- (void)stopPlugin:(ALAbstractScanViewPlugin *)plugin {
    NSError *error = nil;
    [plugin stopAndReturnError:&error];
     if (error) {
         [self showAlertWithTitle:@"Error stopping scanning"
                                     message:error.debugDescription];
     }
}

#pragma mark - IBAction methods

- (IBAction)toggleBarcodeScanning:(id)sender {
    UISwitch * switcher = sender;
    switcher.enabled = NO;
    switcher.alpha = 0.5;
    
    if (self.enableBarcodeSwitch.on) {
        [self stopPlugin:self.meterScanViewPlugin];
        [self stopPlugin:self.barcodeScanViewPlugin]; //in some rare cases this can still be running, which stops the parallel scan view plugin from starting
        [self setAsCurrentPlugin:self.parallelScanViewPlugin];
    } else {
        //we probably don't want to keep these values from when the switch was previously enabled
        self.barcodeResult = nil;
        [self stopPlugin:self.parallelScanViewPlugin];
        if ([self.meterResult length]) {
            //if we already have a meter result, and we no longer need a barcode, display the results immediately rather than trying to scan the meter again.
            [self displayResultsIfPresent];
        } else {
            [self setAsCurrentPlugin:self.meterScanViewPlugin];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switcher.enabled = YES;
        switcher.alpha = 1;
    });
}

#pragma mark - Barcode View layouting
- (UIView *)createBarcodeSwitchView {
    //Add UISwitch for toggling barcode scanning
    self.enableBarcodeView = [[UIView alloc] init];
    self.enableBarcodeView.frame = CGRectMake(0, 0, 150, 50);
    
    self.enableBarcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.enableBarcodeLabel.text = @"Barcode Detection";
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.enableBarcodeLabel.font = font;
    self.enableBarcodeLabel.numberOfLines = 0;
    
    self.enableBarcodeLabel.textColor = [UIColor whiteColor];
    [self.enableBarcodeLabel sizeToFit];
    
    self.enableBarcodeSwitch = [[UISwitch alloc] init];
    [self.enableBarcodeSwitch setOn:false];
    [self.enableBarcodeSwitch setOnTintColor:[UIColor AL_NonSelectedToolBarItem]];
    [self.enableBarcodeSwitch useHighContrast];
    [self.enableBarcodeSwitch addTarget:self action:@selector(toggleBarcodeScanning:) forControlEvents:UIControlEventValueChanged];
    
    [self.enableBarcodeView addSubview:self.enableBarcodeLabel];
    [self.enableBarcodeView addSubview:self.enableBarcodeSwitch];
    
    return self.enableBarcodeView;
}

- (void)updateLayoutBarcodeSwitchView {
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

- (void)displayResultsIfPresent {
    if ([self.meterResult length]) {
        if (!self.enableBarcodeSwitch.on || self.barcodeResult) {
            [self displayResults];
        }
    }
}

- (void)displayResults {
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Meter Reading" value:self.meterResult]];
    if (self.barcodeResult) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode" value:self.barcodeResult shouldSpellOutValue:YES]];
    }
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    [self anylineDidFindResult:jsonString barcodeResult:self.barcodeResult image:self.meterImage scanPlugin:self.meterScanPlugin viewPlugin:self.meterScanViewPlugin  completion:^{
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:self.meterImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //reset found barcodes
    self.barcodeResult = @"";
}

#pragma mark - ALMeterScanPluginDelegate methods
/*
 The main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineMeterScanPlugin:(ALMeterScanPlugin * _Nonnull)anylineMeterScanPlugin didFindResult:(ALMeterResult * _Nonnull)scanResult {
    self.meterResult = scanResult.result;
    self.meterImage = scanResult.image;
    [self displayResultsIfPresent];
}


- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult * _Nonnull)scanResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (scanResult.result) {
            self.barcodeResult = [[scanResult.result firstObject] value];
        } else {
            //if we get a nil barcode result for some reason, we don't want to just be stuck on the screen with no scanners running.
            self.barcodeResult = @"";
        }
        [self displayResultsIfPresent];
    });
}



@end
