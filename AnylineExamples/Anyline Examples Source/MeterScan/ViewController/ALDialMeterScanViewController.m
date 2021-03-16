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
@interface ALDialMeterScanViewController ()<ALMeterScanPluginDelegate, AnylineNativeBarcodeDelegate>

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
    
    //Add Meter Scan View Plugin (Scan UI)
    self.meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:self.meterScanPlugin];
    
    
    //Set ScanMode to ALAutoAnalogDigitalMeter
    BOOL success = [self.meterScanPlugin setScanMode:ALDialMeter error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [self showAlertWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription];
        
    }
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.meterScanViewPlugin];
    
    [self.view addSubview:self.scanView];
    [self.scanView startCamera];
    
    BOOL enableReporting = [NSUserDefaults AL_reportingEnabled];
    [self.meterScanPlugin enableReporting:enableReporting];
    self.meterScanViewPlugin.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the scanView to the view of this view controller
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];
    
    
    self.controllerType = ALScanHistoryElectricMeter;
    
    [self.view sendSubviewToBack:self.scanView];
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

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.meterScanViewPlugin stopAndReturnError:nil];
}

#pragma mark - IBAction methods

- (IBAction)toggleBarcodeScanning:(id)sender {
    
    if (self.scanView.captureDeviceManager.barcodeDelegates.count > 0) {
        self.enableBarcodeSwitch.on = false;
        [self.scanView.captureDeviceManager removeBarcodeDelegate:self];
        //reset found barcode
        self.barcodeResult = @"";
    } else {
        self.enableBarcodeSwitch.on = true;
        [self.scanView.captureDeviceManager addBarcodeDelegate:self error:nil];
    }
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
