//
//  ALPDF417ScanViewController.m
//  AnylineExamples
//
//  Created by Matthias Gasser on 22/04/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALPDF417ScanViewController.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALResultViewController.h"

// The controller has to conform to <AnylineBarcodeModuleDelegate> to be able to receive results
@interface ALPDF417ScanViewController() <ALBarcodeScanPluginDelegate, ALScanViewPluginDelegate>
// The Anyline plugin used to scan barcodes
@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALPDF417ScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"PDF417";
    CGRect frame = [self scanViewFrame];
    
    //Add Barcode Scan Plugin (Scan Process)
    NSError *error = nil;

    self.barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE" delegate:self error:&error];
    NSAssert(self.barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    

    //Set Barcode Format to PDF417 only
    [self.barcodeScanPlugin setBarcodeFormatOptions:@[kCodeTypePDF417]];
    
    
    //Change cutout appearance to fit the PDF417 use case better
    ALScanViewPluginConfig *uiConfig = [ALScanViewPluginConfig defaultBarcodeConfig];
    uiConfig.cutoutConfig.alignment = ALCutoutAlignmentTopHalf;
    uiConfig.cutoutConfig.maxPercentWidth = 0.9;
    uiConfig.cutoutConfig.widthPercent = 0.9;
    uiConfig.cutoutConfig.strokeWidth = 2;
    uiConfig.cutoutConfig.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 250, 90)];
    
    //Add Barcode Scan View Plugin (Scan UI)
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:self.barcodeScanPlugin scanViewPluginConfig:uiConfig];
    NSAssert(self.barcodeScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.barcodeScanViewPlugin addScanViewPluginDelegate:self];
    
    self.controllerType = ALScanHistoryBarcodePDF417;
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.barcodeScanViewPlugin];
    [self.scanView.captureDeviceManager setValue:@(1) forKey:@"disableNative"];
    
    [self.view addSubview:self.scanView];
    [self.scanView startCamera];
    
    self.barcodeScanViewPlugin.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the scanView to the view of this view controller
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startPlugin:self.barcodeScanViewPlugin];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.barcodeScanViewPlugin stopAndReturnError:nil];
}
- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
}

#pragma mark -- AnylineBarcodeModuleDelegate

/*
 The main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin *)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult *)scanResult {
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"PDF417" value:scanResult.result.firstObject.value]];

    [self anylineDidFindResult:@"" barcodeResult:@"" image:scanResult.image scanPlugin:anylineBarcodeScanPlugin viewPlugin:self.barcodeScanViewPlugin completion:^{
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
