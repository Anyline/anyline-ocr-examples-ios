//
//  ALRecordNumberScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALRecordNumberScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALBaseViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"

// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALRecordNumberScanViewController () //<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
//@property (nonatomic, strong) ALOCRScanViewPlugin *recordScanViewPlugin;
//@property (nonatomic, strong) ALOCRScanPlugin *recordScanPlugin;
//@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALRecordNumberScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Record Number";
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
//    ALOCRConfig *config = [[ALOCRConfig alloc] init];
//    config.charHeight = ALRangeMake(22, 105);
//    config.characterWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.";
//    config.minConfidence = 75;
//    config.validationRegex = @"^([A-Z]+\\s*-*\\s*)?[0-9A-Z-\\s\\.]{3,}$";
//    config.scanMode = ALLine;
//    config.removeSmallContours = NO;
//
    NSError *error = nil;
    
//    self.recordScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
//                                                             delegate:self
//                                                            ocrConfig:config
//                                                                error:&error];
//    NSAssert(self.recordScanPlugin, @"Setup Error: %@", error.debugDescription);
//    [self.recordScanPlugin addInfoDelegate:self];
//
//    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"record_number_config" ofType:@"json"];
//    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
//
//    self.recordScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.recordScanPlugin
//                                                           scanViewPluginConfig:scanViewPluginConfig];
//    NSAssert(self.recordScanViewPlugin, @"Setup Error: %@", error.debugDescription);
//    [self.recordScanViewPlugin addScanViewPluginDelegate:self];
//
//    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.recordScanViewPlugin];
    
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
    
    //Start Camera:
    [self.scanView startCamera];
//    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryRecordNumber;
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
//    [self startAnyline];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.recordScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
//- (void)startAnyline {
//    [self startPlugin:self.recordScanViewPlugin];
//    self.startTime = CACurrentMediaTime();
//}

//- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
//    //Update Position of Warning Indicator
//    [self updateWarningPosition:
//     cutoutRect.origin.y +
//     cutoutRect.size.height +
//     self.scanView.frame.origin.y +
//     80];
//}

#pragma mark -- AnylineOCRModuleDelegate
/*
 This is the main delegate method Anyline uses to report its results
 */
//- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin didFindResult:(ALOCRResult *)result {
//    //TODO: (RNR) convert this result to the json string so we have the same types across the scanmodes
//    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.recordScanViewPlugin completion:^{
//        ALBaseViewController *vc = [[ALBaseViewController alloc] init];
//        vc.result = result.result;
//        NSString *url = [NSString stringWithFormat:@"https://www.google.at/search?q=\"%@\" site:discogs.com OR site:musbrainz.org OR site:allmusic.com", result.result];
//        [vc startWebSearchWithURL:url];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//}
//
//- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
//    if ([info.variableName isEqualToString:@"$brightness"]) {
//        [self updateBrightness:[info.value floatValue] forModule:self.recordScanViewPlugin];
//    }
//}


@end
