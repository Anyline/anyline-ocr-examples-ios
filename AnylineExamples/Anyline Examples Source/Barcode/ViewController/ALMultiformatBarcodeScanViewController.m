//
//  ALBarcodeScanViewController.m
//  AnylineExamples
//
//  Created by Matthias Gasser on 22/04/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALMultiformatBarcodeScanViewController.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALSelectionTable.h"
#import "ALBarcodeFormatHelper.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "ALResultViewController.h"

// The controller has to conform to <AnylineBarcodeModuleDelegate> to be able to receive results
@interface ALMultiformatBarcodeScanViewController() <ALBarcodeScanPluginDelegate, ALScanViewPluginDelegate, ALSelectionTableDelegate>
// The Anyline plugin used to scan barcodes
@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

// A debug label to show scanned results
@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) NSArray<NSString *> *defaultReadableSymbologies;

@end

@implementation ALMultiformatBarcodeScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Barcodes";
    CGRect frame = [self scanViewFrame];
    
    //Add Barcode Scan Plugin (Scan Process)
    NSError *error = nil;

    self.barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE" delegate:self error:&error];
    NSAssert(self.barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    [self.barcodeScanPlugin addInfoDelegate:self];
        
    self.defaultReadableSymbologies = [ALBarcodeFormatHelper defaultReadableName];
    
    //Set Barcode Formats
    [self.barcodeScanPlugin setBarcodeFormatOptions:[ALBarcodeFormatHelper formatsForReadableNames:self.defaultReadableSymbologies]];
    //Add Barcode Scan View Plugin (Scan UI)
    
    ALScanViewPluginConfig * config =  [ALScanViewPluginConfig defaultBarcodeConfig];
    config.cutoutConfig.alignment = ALCutoutAlignmentMiddle;
    config.cancelOnResult = YES;

    
    self.barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:self.barcodeScanPlugin scanViewPluginConfig:config];
    NSAssert(self.barcodeScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.barcodeScanViewPlugin addScanViewPluginDelegate:self];
    
    
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
    
    // The resultLabel is used as a debug view to see the scanned results. We set its text
    // in anylineBarcodeModuleView:didFindScanResult:atImage below
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 150, self.view.frame.size.width - 40, 50)];
    self.resultLabel.textAlignment = NSTextAlignmentLeft;
    self.resultLabel.textColor = [UIColor whiteColor];
    self.resultLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.numberOfLines = 0;
    
    [self.view addSubview:self.resultLabel];
    
    self.controllerType = ALScanHistoryBarcode;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showSymbologySelector:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    CGFloat rightPadding = window.safeAreaInsets.right;
    
    UISwitch *multiBarcode = [[UISwitch alloc] init];
    [self.view addSubview:multiBarcode];
    multiBarcode.translatesAutoresizingMaskIntoConstraints = NO;
    [multiBarcode.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-bottomPadding-10].active = YES;
    [multiBarcode.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-rightPadding-10].active = YES;
    [multiBarcode setTintColor:[UIColor AL_examplesBlue]];
    [multiBarcode setOnTintColor:[UIColor AL_examplesBlue]];
    [multiBarcode addTarget:self action:@selector(setMultiBarcode:) forControlEvents:UIControlEventValueChanged];
    [multiBarcode setOn:NO];
    
    UILabel *multiBarcodeLabel = [[UILabel alloc] init];
    [self.view addSubview:multiBarcodeLabel];
    multiBarcodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [multiBarcodeLabel.centerYAnchor constraintEqualToAnchor:multiBarcode.centerYAnchor].active = YES;
    [multiBarcodeLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [multiBarcodeLabel.rightAnchor constraintEqualToAnchor:multiBarcode.leftAnchor constant:-10].active = YES;
    [multiBarcodeLabel.heightAnchor constraintEqualToAnchor:multiBarcode.heightAnchor].active = YES;
    multiBarcodeLabel.text = @"Multi Barcode";
    multiBarcodeLabel.font = [UIFont AL_proximaBoldWithSize:16];
    multiBarcodeLabel.textColor = UIColor.whiteColor;
    multiBarcodeLabel.textAlignment = NSTextAlignmentRight;
}

- (IBAction)setMultiBarcode:(id)sender {
    UISwitch * multiSwitch = sender;
    self.barcodeScanPlugin.multiBarcode = multiSwitch.isOn;
}

- (void)showSymbologySelector:(id)button {
    NSArray<NSString *> *selectedItems = [ALBarcodeFormatHelper readableNameForFormats:self.barcodeScanPlugin.barcodeFormatOptions];
        
    ALSelectionTable* table = [[ALSelectionTable alloc] initWithSelectedItems:selectedItems
                                                                     allItems:[ALBarcodeFormatHelper readableBarcodeNamesDict]
                                                                 headerTitles:[ALBarcodeFormatHelper readableHeaderArray]
                                                                 defaultItems:self.defaultReadableSymbologies
                                                                        title:@"Select Symbologies"
                                                                 singleSelect:NO];
    table.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:table];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)selectionTable:(ALSelectionTable *)selectionTable selectedItems:(NSArray<NSString *> *)selectedItems {
    [self.barcodeScanPlugin setBarcodeFormatOptions:[ALBarcodeFormatHelper
                            formatsForReadableNames:selectedItems]];
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
    usleep(200000);
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


- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info {
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.barcodeScanPlugin];
    }
}


- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin *)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult*)scanResult {
    
    NSMutableString * resultSring = [NSMutableString string];
    [resultSring appendFormat:@"Results: %lu\n", (unsigned long)scanResult.result.count];
    
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    for (ALBarcode* barcodeResult in scanResult.result) {
        NSString * value = barcodeResult.value;
        [resultSring appendString:value];
        [resultSring appendFormat:@"\n"];
        
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Result" value:barcodeResult.value shouldSpellOutValue:YES]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Format" value:barcodeResult.barcodeFormat shouldSpellOutValue:YES]];
    }

    [self anylineDidFindResult:resultSring
                 barcodeResult:@""
                         image:scanResult.image
                    scanPlugin:self.barcodeScanPlugin
                    viewPlugin:self.barcodeScanViewPlugin
                    completion:^{
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
