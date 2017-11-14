//
//  ALAnalogMeterScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Mueller on 24/11/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALSerialNumberScanViewController.h"
#import "ALMeterScanResultViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kSerialNumberScanLicenseKey = kDemoAppLicenseKey;

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALSerialNumberScanViewController ()<AnylineEnergyModuleDelegate, AnylineNativeBarcodeDelegate>

// The Anyline module used to scan
@property (nonatomic, strong) AnylineEnergyModuleView *anylineEnergyView;

@property (nonatomic, strong) NSMutableDictionary *barcodeResults;

@property (nonatomic, strong) UIView *enableBarcodeView;
@property (nonatomic, strong) UISwitch *enableBarcodeSwitch;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ALSerialNumberScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Serial Number";
    // Initializing the energy module. Its a UIView subclass. We set its frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.anylineEnergyView = [[AnylineEnergyModuleView alloc] initWithFrame:frame];
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // once we start receiving results.
    BOOL success = [self.anylineEnergyView setupWithLicenseKey:kSerialNumberScanLicenseKey delegate:self error:&error];
    
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Setup Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    self.anylineEnergyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Set ScanMode to ALAnalogMeter
    success = [self.anylineEnergyView setScanMode:ALSerialNumber error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.anylineEnergyView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.anylineEnergyView}]];
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.anylineEnergyView, @"topGuide" : topGuide}]];

    self.barcodeResults = [NSMutableDictionary new];
    //Add UISwitch for toggling barcode scanning
    self.enableBarcodeView = [[UIView alloc] init];
    self.enableBarcodeView.frame = CGRectMake(0, 0, 150, 50);
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.label.text = @"Detect Barcodes";
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.label.font = font;
    self.label.numberOfLines = 0;
    
    self.label.textColor = [UIColor whiteColor];
    [self.label sizeToFit];
    
    self.enableBarcodeSwitch = [[UISwitch alloc] init];
    [self.enableBarcodeSwitch setOn:false];
    self.enableBarcodeSwitch.onTintColor = [UIColor whiteColor];
    [self.enableBarcodeSwitch setOnTintColor:[UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.enableBarcodeSwitch addTarget:self action:@selector(toggleBarcodeScanning:) forControlEvents:UIControlEventValueChanged];
    
    [self.enableBarcodeView addSubview:self.label];
    [self.enableBarcodeView addSubview:self.enableBarcodeSwitch];
    [self.anylineEnergyView addSubview:self.enableBarcodeView];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*
     This is the place where we tell Anyline to start receiving and displaying images from the camera.
     Success/error tells us if everything went fine.
     */
    NSError *error = nil;
    BOOL success = [self.anylineEnergyView startScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Start Scanning Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.label.center = CGPointMake(self.label.frame.size.width/2, self.enableBarcodeView.frame.size.height/2);
    self.enableBarcodeSwitch.center = CGPointMake(self.label.frame.size.width + self.enableBarcodeSwitch.frame.size.width/2 + 7, self.enableBarcodeView.frame.size.height/2);
    
    CGFloat width = self.enableBarcodeSwitch.frame.size.width + 7 + self.label.frame.size.width;
    self.enableBarcodeView.frame = CGRectMake(self.anylineEnergyView.frame.size.width-width-15, self.anylineEnergyView.frame.size.height-self.enableBarcodeView.frame.size.height-5, width, 50);
   
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.anylineEnergyView cancelScanningAndReturnError:nil];
}

- (IBAction)toggleBarcodeScanning:(id)sender {
    
    if (self.anylineEnergyView.captureDeviceManager.barcodeDelegate) {
        self.enableBarcodeSwitch.on = false;
        [self.anylineEnergyView.captureDeviceManager setBarcodeDelegate:nil];
        //reset found barcodes
        self.barcodeResults = [NSMutableDictionary new];
    } else {
        self.enableBarcodeSwitch.on = true;
        //Use this line if you want to use/actvitave the simultaneous barcode
        //set delegate for nativeBarcodeScanning => simultaneous barcode scanning
        [self.anylineEnergyView.captureDeviceManager setBarcodeDelegate:self];
    }
}


#pragma mark - AnylineControllerDelegate methods
/*
 The main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineEnergyModuleView:(AnylineEnergyModuleView *)anylineEnergyModuleView didFindResult:(ALEnergyResult *)scanResult {
        ALMeterScanResultViewController *vc = [[ALMeterScanResultViewController alloc] init];
        /*
         To present the scanned result to the user we use a custom view controller.
         */
        vc.scanMode = scanResult.scanMode;
        vc.meterImage = scanResult.image;
        vc.result = scanResult.result;
        vc.barcodeResults = self.barcodeResults;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        //reset found barcodes
        self.barcodeResults = [NSMutableDictionary new];
}

#pragma mark - AnylineNativeBarcodeDelegate methods
/*
 An additional delegate which will add all found, and unique, barcodes to a Dictionary simultaneously.
 */
- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager
               didFindBarcodeResult:(NSString *)scanResult
                               type:(NSString *)barcodeType {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self.barcodeResults objectForKey:scanResult]) {
            [self.barcodeResults setObject:barcodeType forKey:scanResult];
        }
        
    });
}

@end
