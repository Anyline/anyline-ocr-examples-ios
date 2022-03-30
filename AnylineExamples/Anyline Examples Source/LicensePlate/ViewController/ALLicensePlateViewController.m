//
//  ALLicensePlateViewController.m
//  AnylineExamples
//
//  Created by Matthias Gasser on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALLicensePlateViewController.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"

// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALLicensePlateViewController ()<ALLicensePlateScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) ALLicensePlateScanViewPlugin *licensePlateScanViewPlugin;
@property (nonatomic, strong) ALLicensePlateScanPlugin *licensePlateScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALLicensePlateViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"EU License Plate";
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];

    NSError *error = nil;
    
    self.licensePlateScanPlugin = [[ALLicensePlateScanPlugin alloc] initWithPluginID:@"LICENSE_PLATE" delegate:self error:&error];
    NSAssert(self.licensePlateScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.licensePlateScanPlugin setScanMode:ALLicensePlateAuto error:nil];
    [self.licensePlateScanPlugin addInfoDelegate:self];
    
    
    //Set a delayed scan start time in the scanViewPluginConfig
    ALScanViewPluginConfig *viewPluginConfig = [ALScanViewPluginConfig defaultLicensePlateConfig];
    
    
    self.licensePlateScanViewPlugin = [[ALLicensePlateScanViewPlugin alloc] initWithScanPlugin:self.licensePlateScanPlugin scanViewPluginConfig:viewPluginConfig];
    NSAssert(self.licensePlateScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.licensePlateScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.licensePlateScanViewPlugin];
    
    self.controllerType = ALScanHistoryLicensePlates;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    NSArray *scanViewConstraints = @[[self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                     [self.scanView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
                                     [self.scanView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
                                     [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
    [self.view addConstraints:scanViewConstraints];
    [NSLayoutConstraint activateConstraints:scanViewConstraints];
    
    // Enable zoom gesture for scanView
    [self.scanView enableZoomPinchGesture:true];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self startAnyline];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.licensePlateScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.licensePlateScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
}

#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */

- (void)anylineLicensePlateScanPlugin:(ALLicensePlateScanPlugin *)anylineLicensePlateScanPlugin
                        didFindResult:(ALLicensePlateResult *)result {

    NSMutableArray<ALResultEntry *> *resultData = [[NSMutableArray alloc] init];

    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"License Plate"
                                                         value:result.result
                                           shouldSpellOutValue:YES]];

    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Country"
                                                         value:result.country]];

    NSString *jsonString = [self jsonStringFromResultData:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString
                 barcodeResult:@""
                         image:result.image
                    scanPlugin:anylineLicensePlateScanPlugin
                    viewPlugin:self.licensePlateScanViewPlugin
                    completion:^{

        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = result.image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.licensePlateScanViewPlugin];
    } else if ([info.variableName isEqualToString:@"$square"] && info.value) {
        //the visual feedback shows we have found a potential license plate, so let's give some feedback on VoiceOver too.
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"License Plate");
    }
    
}

@end
