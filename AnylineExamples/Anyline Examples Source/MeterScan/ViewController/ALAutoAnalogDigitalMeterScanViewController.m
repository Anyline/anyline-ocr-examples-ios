//
//  ALAutoAnalogDigitalMeterScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Mueller on 24/11/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//


#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAutoAnalogDigitalMeterScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultEntry.h"
#import "ALResultViewController.h"

//This example shows how the native barcode scanning can be used in conjunction with any other plugin. It has been replaced in the example app with a parallel composite plugin which runs an Anyline barcode scanner at the same time as a meter scanner and serial number scanner. However, this single plugin + native barcode strategy can still be used in simpler cases.

static const NSInteger padding = 7;

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALAutoAnalogDigitalMeterScanViewController ()<ALMeterScanPluginDelegate, AnylineNativeBarcodeDelegate>

// The Anyline plugins used to scan
@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;
@property (nonatomic, strong) ALMeterScanPlugin *meterScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

//Native barcode scanning properties
@property (nonatomic, strong) NSString *barcodeResult;

@property (nonatomic, strong) UIView *enableBarcodeView;
@property (nonatomic, strong) UISwitch *enableBarcodeSwitch;
@property (nonatomic, strong) UILabel *enableBarcodeLabel;

@end

@implementation ALAutoAnalogDigitalMeterScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Analog/Digital Meter";
    
    CGRect frame = [self scanViewFrame];
    
    //Add Meter Scan Plugin (Scan Process)
    NSError *error = nil;
    self.meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:@"ENERGY" delegate:self error:&error];
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
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.meterScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
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

    
    self.controllerType = ALScanHistoryElectricMeter;

    self.barcodeResult = @"";
    
    [self.scanView addSubview:[self createBarcodeSwitchView]];
    [self.scanView bringSubviewToFront:self.enableBarcodeView];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startPlugin:self.meterScanViewPlugin];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateLayoutBarcodeSwitchView];
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

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.meterScanViewPlugin stopAndReturnError:nil];
}

#pragma mark - IBAction methods


- (IBAction)toggleBarcodeScanning:(id)sender {
    UISwitch * switcher = sender;
    switcher.enabled = NO;
    switcher.alpha = 0.5;
    if (self.scanView.captureDeviceManager.barcodeDelegates.count > 0) {
        self.enableBarcodeSwitch.on = false;
        [self.scanView.captureDeviceManager removeBarcodeDelegate:self];
        //reset found barcode
        self.barcodeResult = @"";
    } else {
        self.enableBarcodeSwitch.on = true;
        [self.scanView.captureDeviceManager addBarcodeDelegate:self error:nil];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switcher.enabled = YES;
        switcher.alpha = 1;
    });
}

#pragma mark - Barcode View layout
- (UIView *)createBarcodeSwitchView {
    //Add UISwitch for toggling barcode scanning
    self.enableBarcodeView = [[UIView alloc] init];
    self.enableBarcodeView.frame = CGRectMake(100, 100, 150, 50);
    
    self.enableBarcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.enableBarcodeLabel.text = @"Barcode Detection";
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.enableBarcodeLabel.font = font;
    self.enableBarcodeLabel.numberOfLines = 0;
    
    self.enableBarcodeLabel.textColor = [UIColor whiteColor];
    [self.enableBarcodeLabel sizeToFit];
    
    self.enableBarcodeSwitch = [[UISwitch alloc] init];
    [self.enableBarcodeSwitch setOn:false];
    self.enableBarcodeSwitch.onTintColor = [UIColor whiteColor];
    [self.enableBarcodeSwitch setOnTintColor:[UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.enableBarcodeSwitch addTarget:self action:@selector(toggleBarcodeScanning:) forControlEvents:UIControlEventValueChanged];
    
    [self.enableBarcodeView addSubview:self.enableBarcodeLabel];
    [self.enableBarcodeView addSubview:self.enableBarcodeSwitch];
    
    return self.enableBarcodeView;
}

#pragma mark - ALMeterScanPluginDelegate methods
/*
 The main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineMeterScanPlugin:(ALMeterScanPlugin *)anylineMeterScanPlugin
                 didFindResult:(ALMeterResult *)scanResult {
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Meter Reading" value:scanResult.result]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode" value:self.barcodeResult shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    [self anylineDidFindResult:jsonString barcodeResult:self.barcodeResult image:(UIImage*)scanResult.image scanPlugin:anylineMeterScanPlugin viewPlugin:self.meterScanViewPlugin  completion:^{
        //Display the result
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //reset found barcodes
    self.barcodeResult = @"";
}

#pragma mark - AnylineNativeBarcodeDelegate methods
/*
 An additional delegate which will add all found, and unique, barcodes to a Dictionary simultaneously.
 */
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager didFindBarcodeResult:(NSString *)scanResult type:(NSString *)barcodeType {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([scanResult length] > 0 && ![self.barcodeResult isEqualToString:scanResult]) {
            self.barcodeResult = scanResult;
        }
    });
}


@end
