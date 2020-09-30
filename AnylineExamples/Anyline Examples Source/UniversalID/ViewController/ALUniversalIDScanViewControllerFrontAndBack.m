//
//  ALUniversalIDScanViewControllerFrontAndBack.h
//  AnylineExamples
//
//  Created by Philipp on 16.09.20.
//

#import "ALUniversalIDScanViewControllerFrontAndBack.h"
#import "ALAppDemoLicenses.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"

#import "AnylineExamples-Swift.h"

#import "ALUniversalIDFieldnameUtil.h"



// This is the license key for the examples project used to set up Anyline below
NSString * const kUniversalIDLicenseFrontAndBackKey = kDemoAppLicenseKey;

NSString * const kScanIDFrontLabelText = @"Scan your ID";
NSString * const kScanIDBackLabelText = @"Turn ID over";

NSString * const kScanViewPluginFrontID = @"IDPluginFront";
NSString * const kScanViewPluginBackID = @"IDPluginBack";

@interface ALUniversalIDScanViewControllerFrontAndBack ()<ALIDPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate, AnylineNativeBarcodeDelegate>

@property (nonatomic, strong) ALIDScanPlugin *scanPluginFront;
@property (nonatomic, strong) ALIDScanViewPlugin *scanViewPluginFront;

@property (nonatomic, strong) ALIDScanPlugin *scanPluginBack;
@property (nonatomic, strong) ALIDScanViewPlugin *scanViewPluginBack;
@property (nonatomic, strong) ALSerialScanViewPluginComposite *serialScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nullable, nonatomic, strong) NSMutableArray<ALResultEntry *> *resultData;
@property (nullable, nonatomic, strong) UIImage *frontScanImage;
@property (nullable, nonatomic, strong) UIImage *backScanImage;
@property (nullable, nonatomic, strong) NSTimer *scanTimeout;
@property (nullable, nonatomic, strong) NSTimer *frontScanTimeout;
@property (nullable, nonatomic, strong) GifuWrapper *gifImageView;

@property (nonatomic, strong) NSString *detectedBarcode;
@property (nonatomic, strong) NSMutableString *resultHistoryString;

@property (nullable, nonatomic, strong) UIView *hintView;
@property (nullable, nonatomic, strong) UILabel *hintViewLabel;

@end

@implementation ALUniversalIDScanViewControllerFrontAndBack



- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = (self.title && self.title.length > 0) ? self.title : @"Universal ID";

    CGFloat hintMargin = 7;
    
    CGRect frame = [self scanViewFrame];

    // First we load our Universal ID config
    NSError *error = nil;
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"universal_id_config" ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:jsonFilePath];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:jsonFile
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    
    // Then Initializing our first scan mode (ScanPlugin + ScanViewPlugin).
    self.scanViewPluginFront = (ALIDScanViewPlugin *)[ALAbstractScanViewPlugin scanViewPluginForConfigDict:configDict
                                                                                           licenseKey:kUniversalIDLicenseFrontAndBackKey
                                                                                             delegate:self error:&error];

    [self.scanViewPluginFront addScanViewPluginDelegate:self];
    ALScanViewPluginConfig *configFront = self.scanViewPluginFront.scanViewPluginConfig;
    configFront.cutoutConfig.animation = ALCutoutAnimationFade;
    [self.scanViewPluginFront setScanViewPluginConfig:configFront];
    
    
    NSAssert(self.scanViewPluginFront, @"Setup Error: %@", error.debugDescription);
    self.scanPluginFront = self.scanViewPluginFront.idScanPlugin;
    [self.scanPluginFront setPluginID:kScanViewPluginFrontID];
    
    [self.scanPluginFront addInfoDelegate:self];
    
    // Now we need our second scan mode
    self.scanViewPluginBack = (ALIDScanViewPlugin *)[ALAbstractScanViewPlugin scanViewPluginForConfigDict:configDict
                                                                                           licenseKey:kUniversalIDLicenseFrontAndBackKey
                                                                                             delegate:self error:&error];

    [self.scanViewPluginBack addScanViewPluginDelegate:self];
    ALScanViewPluginConfig *configBack = self.scanViewPluginFront.scanViewPluginConfig;
    configBack.cutoutConfig.animation = ALCutoutAnimationFade;
    [self.scanViewPluginFront setScanViewPluginConfig:configBack];
    
    
    NSAssert(self.scanViewPluginBack, @"Setup Error: %@", error.debugDescription);
    self.scanPluginBack = self.scanViewPluginBack.idScanPlugin;
    [self.scanPluginBack setPluginID:kScanViewPluginBackID];
    
    [self.scanPluginBack addInfoDelegate:self];
    
    
    // Combine them in a SerialScanViewPlugin
    ALSerialScanViewPluginComposite *serialScanViewPlugin = [[ALSerialScanViewPluginComposite alloc] initWithPluginID:@"UniversalID_frontAndBack"];
    [serialScanViewPlugin addPlugin:self.scanViewPluginFront];
    [serialScanViewPlugin addPlugin:self.scanViewPluginBack];
    
    self.serialScanViewPlugin = serialScanViewPlugin;
    
    // Create ScanView and add our ScanViewPlugin Composite
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.serialScanViewPlugin];
    
    // Setup nativeBarcode Scanner for only PDF417
    [self.scanView.captureDeviceManager addBarcodeDelegate:self error:nil];
    [self.scanView.captureDeviceManager setNativeBarcodeFormats: @[AVMetadataObjectTypePDF417Code]];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryUniversalID;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    
    // Add scan hint label
    self.hintView = [self createScanHintView:hintMargin];
    [self.view addSubview:self.hintView];

    self.gifImageView = [[GifuWrapper alloc] init];
    self.gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scanView addSubview:self.gifImageView];
    self.gifImageView.alpha = 0.80;
    self.gifImageView.layer.cornerRadius = 5.0;
    self.gifImageView.layer.masksToBounds = YES;

    CGRect gifFrame =  CGRectMake(0, 0, 500, 310);
    self.gifImageView.frame = gifFrame;
//    [self.gifImageView setGIFWithGifName:@"turn_card_over_animation.gif" loopCount:1 frame:gifFrame];
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
    [self.serialScanViewPlugin stopAndReturnError:nil];
    
    [self resetResultData];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {

    NSError *error;
    BOOL success = [self.serialScanViewPlugin startAndReturnError:&error];
    if( !success ) {
        //sometimes this alert will show, sometimes the slightly-less-friendly one from the SDK will show instead.
        [self showAlertWithTitle:@"Could not start scanning" message:error.localizedDescription];
    }
        
    [self resetResultData];
}


- (UIView *)createScanHintView:(CGFloat)hintMargin {
    UILabel * hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView * hintView = [[UILabel alloc] initWithFrame:CGRectZero];
    hintViewLabel.text = kScanIDFrontLabelText;
    [hintViewLabel sizeToFit];
    [hintView addSubview:hintViewLabel];
    hintView.frame = UIEdgeInsetsInsetRect(hintViewLabel.frame, UIEdgeInsetsMake(-hintMargin, -hintMargin, -hintMargin, -hintMargin));
    hintView.center = CGPointMake(self.view.center.x, 0);
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor constant:0].active = YES;
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor constant:0].active = YES;
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = true;
    hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hintViewLabel.textColor = [UIColor whiteColor];
    
    //We shouldn't do this here:
    self.hintViewLabel = hintViewLabel;
    
    return hintView;
}

- (void)updateHintPosition:(CGFloat)newPosition {
    self.hintView.center = CGPointMake(self.hintView.center.x, newPosition);
}


- (void)prepareForBacksideScanning {
    if (self.frontScanTimeout) {
        [self.frontScanTimeout invalidate];
    }
    [self.serialScanViewPlugin stopAndReturnError:nil];
    
    [self updateScanLabelWithStringWithAnimation:kScanIDBackLabelText];
    
    self.gifImageView.hidden = false;
    [self hideGIFView:false];
    
    [self.gifImageView startGIFWithGifName:@"flip_id" loopCount:1];
    dispatch_time_t gifTimeout = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
    dispatch_after(gifTimeout, dispatch_get_main_queue(), ^(void){
        [self.gifImageView stopGIF];
        [self hideGIFView:true];
    });
    
    
    
    double delayInSeconds = 2000; // set the time
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.serialScanViewPlugin startFromID:kScanViewPluginBackID andReturnError:nil];
    });
}


        


- (void)hideGIFView:(BOOL)willBeHidden {
    
    [UIView transitionWithView:self.gifImageView
                      duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void){
                        self.gifImageView.hidden = willBeHidden;
                    }
                    completion:nil];
}

#pragma mark -- AnylineIDPlugin Delegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin
              didFindResult:(ALIDResult *)scanResult {
    [self.serialScanViewPlugin stopAndReturnError:nil];
    
    
    
    ALUniversalIDIdentification *identification = (ALUniversalIDIdentification *)scanResult.result;
    ALLayoutDefinition *layoutDefinition = identification.layoutDefinition;
    
    if ([anylineIDScanPlugin.pluginID isEqualToString:kScanViewPluginFrontID]) {
        [self.resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil addIDSubResult:identification titleSuffix:@"" resultHistoryString:self.resultHistoryString]];
        [self addResultAtIndex:[[ALResultEntry alloc] initWithTitle:@"Detected Country" value:layoutDefinition.country] forFieldName:@"layoutDefinition.country" withOffset:0];
        [self addResultAtIndex:[[ALResultEntry alloc] initWithTitle:@"Detected Type" value:layoutDefinition.type] forFieldName:@"layoutDefinition.type" withOffset:0];
        
        self.frontScanImage = scanResult.image;
        
        [self prepareForBacksideScanning];
    }
    
    
    if ([anylineIDScanPlugin.pluginID isEqualToString:kScanViewPluginBackID]) {
        [self.scanTimeout invalidate];
        
        //TODO: fix this quick fix...
        NSUInteger resultDataLength = [self.resultData count];
        [self.resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil addIDSubResult:identification titleSuffix:@" Back" resultHistoryString:self.resultHistoryString]];
        NSUInteger resultDataLength2 = [self.resultData count];
        NSUInteger resultDataDelta = (resultDataLength > 0) ? resultDataLength2 - resultDataLength : 0;
        
        [self addResultAtIndex:[[ALResultEntry alloc] initWithTitle:@"Detected Country Back" value:layoutDefinition.country] forFieldName:@"layoutDefinition.country" withOffset:resultDataDelta];
        [self addResultAtIndex:[[ALResultEntry alloc] initWithTitle:@"Detected Type Back" value:layoutDefinition.type] forFieldName:@"layoutDefinition.type" withOffset:resultDataDelta];

        self.backScanImage = scanResult.image;
        
        [self presentResult];
    }
}

- (void)presentResult {
    if (self.scanTimeout) {
        [self.scanTimeout invalidate];
    }
    
    if (self.detectedBarcode.length > 0) {
        //Add barcode result to our final result array
        ALResultEntry *barcodeResult = [[ALResultEntry alloc] initWithTitle:@"Barcode Result" value:self.detectedBarcode];
        [self.resultData addObject:barcodeResult];
    }

    ALResultViewController *vc;

    if (self.resultData.count > 0 || self.detectedBarcode.length > 0) {
        // Write result in history
        [super anylineDidFindResult:self.resultHistoryString barcodeResult:self.detectedBarcode image:self.frontScanImage scanPlugin:self.scanViewPluginFront.idScanPlugin viewPlugin:self.serialScanViewPlugin completion:^{
        }];
    } else {
        // We couldn't read the back side of the ID
        ALResultEntry *barcodeResult = [[ALResultEntry alloc] initWithTitle:@"Result Data" value:@"This ID is either not supported yet or the scan wasn't\ncaptured properly. Please try again." isAvailable:NO];
        [self.resultData addObject:barcodeResult];
    }

    vc = [[ALResultViewController alloc] initWithResultData:self.resultData
                                                      image:self.frontScanImage
                                         optionalImageTitle:@"ID Backside Image"
                                              optionalImage:self.backScanImage];
  
    [self.navigationController pushViewController:vc animated:YES];
    
    [self resetResultData];
}


- (void)anylineCaptureDeviceManager:(ALCaptureDeviceManager *)captureDeviceManager
               didFindBarcodeResult:(NSString *)scanResult
                               type:(NSString *)barcodeType {
    self.detectedBarcode = scanResult;
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info{
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.scanViewPluginFront];
    }
    
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
               runSkipped:(ALRunSkippedReason * _Nonnull)runSkippedReason {
    if (runSkippedReason.reason == ALRunFailureIDTypeNotSupported) {
//        [self updateScanWarnings:ALWarningStateIDNotSupported];
        
        [self triggerTimeOutWithPluginID:anylineScanPlugin.pluginID];
    }
}


- (void)resetResultData {
    self.resultData = [[NSMutableArray alloc] init];
    self.resultHistoryString = [NSMutableString string];
    self.detectedBarcode = nil;
    
    self.backScanImage = nil;
    self.frontScanImage = nil;
    [self.scanTimeout invalidate];
    self.scanTimeout = nil;
    [self.frontScanTimeout invalidate];
    self.frontScanTimeout = nil;
    self.hintViewLabel.text = kScanIDFrontLabelText;
    [self.hintViewLabel sizeToFit];
    
    [self hideGIFView:true];
    [self.gifImageView stopGIF];
}

- (NSUInteger)getOrderedIndexForFieldName:(NSString *)fieldName withOffset:(NSUInteger)offset {
    NSUInteger idx = [[ALUniversalIDFieldnameUtil fieldNamesOrderArray] indexOfObject:fieldName];
    
    if (idx == NSNotFound || idx >= ([self.resultData count]+offset)) {
        return [self.resultData count];
    }
    return idx+offset;
}

- (void)addResultAtIndex:(ALResultEntry *)entry forFieldName:(NSString *)fieldName withOffset:(NSUInteger)offset {

    [self.resultData insertObject:entry atIndex:[self getOrderedIndexForFieldName:fieldName withOffset:offset]];
}

- (void)triggerTimeOutWithPluginID:(NSString *)pluginID {
    double timeoutTime = 4.2;
    
    
    if ([pluginID isEqualToString:kScanViewPluginFrontID]) {
        if (!self.frontScanTimeout.valid) {
                self.frontScanTimeout = self.scanTimeout = [NSTimer scheduledTimerWithTimeInterval:timeoutTime
                                                                                            target:self
                                                                                          selector:@selector(prepareForBacksideScanning)
                                                                                          userInfo:nil
                                                                                           repeats:NO];
        }
    } else if ([pluginID isEqualToString:kScanViewPluginBackID]) {
        if (!self.scanTimeout.valid) {
            self.scanTimeout = [NSTimer scheduledTimerWithTimeInterval:timeoutTime
                                                                target:self
                                                              selector:@selector(presentResult)
                                                              userInfo:nil
                                                               repeats:NO];
        }
    }
    
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
    [self updateHintPosition:cutoutRect.origin.y +
    self.scanView.frame.origin.y -
    50];
    
    self.gifImageView.frame = CGRectMake(cutoutRect.origin.x, cutoutRect.origin.x, cutoutRect.size.width * 0.9, cutoutRect.size.height * 0.9);
    self.gifImageView.center = CGPointMake(cutoutRect.origin.x + cutoutRect.size.width/2, cutoutRect.origin.y + cutoutRect.size.height/2);
}

- (void)updateScanLabelWithStringWithAnimation:(NSString *)labelText {
    self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, .25, .25);

    self.hintViewLabel.text = labelText;
    [UIView animateWithDuration:0.4 animations:^{
        self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 4.5, 4.5);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 0.875, 0.875);
            
        } completion:^(BOOL finished) {
            
            self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, 1.0, 1.0);
            [self.hintViewLabel sizeToFit];
        
        }];
    
    }];
}

@end
