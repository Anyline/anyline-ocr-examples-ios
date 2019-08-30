//
//  ALISBNScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALISBNScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALISBNViewController.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kISBNLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <ALOCRScanPluginDelegate> to be able to receive results
@interface ALISBNScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *isbnScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *isbnScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALISBNScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"ISBN";
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    NSString *engTraineddata = [[NSBundle mainBundle] pathForResource:@"eng_no_dict" ofType:@"traineddata"];
    NSString *deuTraineddata = [[NSBundle mainBundle] pathForResource:@"deu" ofType:@"traineddata"];
    [config setLanguages:@[engTraineddata,deuTraineddata] error:nil];
    
    config.charWhiteList = @"ISBN0123456789<>-X";
    config.validationRegex = @"^ISBN((-)?\\s*(13|10))?:?\\s*((978|979){1}-?\\s*)*[0-9]{1,5}-?\\s*[0-9]{2,7}-?\\s*[0-9]{2,7}-?\\s*[0-9X]$";
    config.scanMode = ALAuto;
    
    NSError *error = nil;
    
    self.isbnScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                         licenseKey:kISBNLicenseKey
                                                           delegate:self
                                                          ocrConfig:config
                                                              error:&error];
    NSAssert(self.isbnScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.isbnScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"isbn_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.isbnScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.isbnScanPlugin
                                                         scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.isbnScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.isbnScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.isbnScanViewPlugin];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryIsbn;
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
    [self.isbnScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.isbnScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.isbnScanPlugin.isRunning) {
        [self.isbnScanViewPlugin stopAndReturnError:nil];
    }
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
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin didFindResult:(ALOCRResult *)result {
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.isbnScanViewPlugin completion:^{
        [self stopAnyline];
        ALISBNViewController *vc = [[ALISBNViewController alloc] init];
        NSString *isbn = result.result;
        isbn = [isbn stringByReplacingOccurrencesOfString:@"-" withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@" " withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN10" withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN13" withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN" withString:@""];
        isbn = [isbn stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        [vc setResult:isbn];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.isbnScanViewPlugin];
    }
    
}

@end
