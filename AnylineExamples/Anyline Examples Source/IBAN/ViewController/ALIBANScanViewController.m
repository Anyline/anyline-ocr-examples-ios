//
//  ALIBANScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALIBANScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALResultOverlayView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "AnylineExamples-Swift.h"

// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALIBANScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *ibanScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *ibanScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALIBANScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"IBAN";
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.scanMode = ALLine;
    config.charHeight = ALRangeMake(25, 65);
    config.minConfidence = 70;
    config.characterWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    config.validationRegex = @"^[A-Z]{2}([0-9A-Z]\\s*){13,32}$";
    config.scanMode = ALLine;
    
    NSError *error = nil;
    
    self.ibanScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                           delegate:self
                                                          ocrConfig:config
                                                              error:&error];
    NSAssert(self.ibanScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.ibanScanPlugin addInfoDelegate:self];
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"iban_config" ofType:@"json"];
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig configurationFromJsonFilePath:confPath];
    
    self.ibanScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.ibanScanPlugin
                                                         scanViewPluginConfig:scanViewPluginConfig];
    NSAssert(self.ibanScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.ibanScanViewPlugin addScanViewPluginDelegate:self];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.ibanScanViewPlugin];
    
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
    [self startListeningForMotion];
    
    self.controllerType = ALScanHistoryIban;
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
    [self.ibanScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.ibanScanViewPlugin];
    
    self.startTime = CACurrentMediaTime();
}

- (void)stopAnyline {
    if (self.ibanScanPlugin.isRunning) {
        [self.ibanScanViewPlugin stopAndReturnError:nil];
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
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"IBAN" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.ibanScanViewPlugin completion:^{
        [self stopAnyline];
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
        vc.imagePrimary = result.image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.ibanScanViewPlugin];
    }
    
}

- (NSString *)formattedIbanText:(NSString*)originalString {
    NSMutableString *resultString = [NSMutableString string];
    
    for(int i = 0; i<[originalString length]/4; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [originalString length] - fromIndex;
        if (len > 4) {
            len = 4;
        }
        
        [resultString appendFormat:@"%@ ",[originalString substringWithRange:NSMakeRange(fromIndex, len)]];
    }
    return resultString;
}

@end
