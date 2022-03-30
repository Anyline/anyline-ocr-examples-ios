//
//  ALUniversalIDScanViewControllerFrontAndBack.h
//  AnylineExamples
//
//  Created by Philipp on 16.09.20.
//

#import "ALUniversalIDScanViewControllerFrontAndBack.h"
#import "AnylineExamples-Swift.h"
#import "ALUniversalIDFieldnameUtil.h"
#import "ALBarcodeResultUtil.h"

NSString * const kScanIDFrontLabelText = @"Scan your ID";
NSString * const kScanIDBackLabelText = @"Turn ID over";

NSString * const kScanViewPluginFrontID = @"IDPluginFront";
NSString * const kScanViewPluginBackID = @"IDPluginBack";

NSString * const kScanViewPluginBarcodeID = @"BarcodePlugin";

NSString * const kScanViewPluginSerialID = @"SerialPlugin";
NSString * const kScanViewPluginParallelID = @"ParallelPlugin";

NSString * const kCameraConfigJSON = @"universal_id_camera_config";
NSString * const kFlashConfigJSON = @"universal_id_flash_config";

NSInteger const kUniversalIDSerialScanTimeout = 10;
NSInteger const kUniversalIDBacksideScanTimeout = 5;
NSInteger const kBarcodeBacksideScanTimeout = 0.7;

@interface ALUniversalIDScanViewControllerFrontAndBack ()<ALIDPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate, ALBarcodeScanPluginDelegate, ALCompositeScanPluginDelegate>

@property (nonatomic, strong) ALIDScanPlugin *scanPluginFront;
@property (nonatomic, strong) ALIDScanViewPlugin *scanViewPluginFront;

@property (nonatomic, strong) ALIDScanPlugin *scanPluginBack;
@property (nonatomic, strong) ALIDScanViewPlugin *scanViewPluginBack;

@property (nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;
@property (nonatomic, strong) ALBarcodeScanViewPlugin *barcodeScanViewPlugin;

@property (nonatomic, strong) ALSerialScanViewPluginComposite *serialScanViewPlugin;
@property (nonatomic, strong) ALParallelScanViewPluginComposite *parallelScanViewPlugin;

@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) NSLayoutConstraint *cutoutGuideYOffsetConstraint;

@property (nullable, nonatomic, strong) NSMutableArray<ALResultEntry *> *resultData;

@property (nullable, nonatomic, strong) UIImage *frontScanImage;
@property (nullable, nonatomic, strong) UIImage *backScanImage;
@property (nullable, nonatomic, strong) UIImage *faceScanImage;

@property (nullable, nonatomic, strong) NSTimer *scanTimeoutFront;
@property (nullable, nonatomic, strong) NSTimer *scanTimeoutBack;

@property (nullable, nonatomic, strong) GifuWrapper *gifImageView;

@property (nonatomic, strong) ALBarcodeResult *detectedBarcode;
@property (nonatomic, strong) NSMutableString *resultHistoryString;

@property (nullable, nonatomic, strong) UIView *hintView;
@property (nullable, nonatomic, strong) UILabel *hintViewLabel;

@end


@implementation ALUniversalIDScanViewControllerFrontAndBack

// MARK: - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = (self.title && self.title.length > 0) ? self.title : @"Universal ID";
    
    NSError *error = nil;
    
    // Front ID scan plugin and scan view plugin
    NSDictionary *idScanConfigDict = [[self class] configDictForIDScanPlugin];
    self.scanViewPluginFront = (ALIDScanViewPlugin *)[ALAbstractScanViewPlugin
                                                      scanViewPluginForConfigDict:idScanConfigDict
                                                      delegate:self
                                                      error:&error];
    NSAssert(self.scanViewPluginFront, @"Setup Error: %@", error.debugDescription);
    
    [self.scanViewPluginFront addScanViewPluginDelegate:self];
    
    ALScanViewPluginConfig *configFront = self.scanViewPluginFront.scanViewPluginConfig;
    configFront.cutoutConfig.animation = ALCutoutAnimationFade;
    [self.scanViewPluginFront setScanViewPluginConfig:configFront];
    
    self.scanPluginFront = self.scanViewPluginFront.idScanPlugin;
    [self.scanPluginFront setPluginID:kScanViewPluginFrontID];
    [self.scanPluginFront addInfoDelegate:self];
    
    // Back ID scan and scan view plugin (config is almost identical with that of the front ID)
    self.scanViewPluginBack = (ALIDScanViewPlugin *)[ALAbstractScanViewPlugin
                                                     scanViewPluginForConfigDict:idScanConfigDict
                                                     delegate:self
                                                     error:&error];
    NSAssert(self.scanViewPluginBack, @"Setup Error: %@", error.debugDescription);
    [self.scanViewPluginBack addScanViewPluginDelegate:self];
    ALScanViewPluginConfig *configBack = self.scanViewPluginFront.scanViewPluginConfig;
    configBack.cutoutConfig.animation = ALCutoutAnimationFade;
    [self.scanViewPluginFront setScanViewPluginConfig:configBack];
    
    self.scanPluginBack = self.scanViewPluginBack.idScanPlugin;
    [self.scanPluginBack setPluginID:kScanViewPluginBackID];
    [self.scanPluginBack addInfoDelegate:self];
    
    // Barcode (to be paired with back id in a parallel scan)
    ALBarcodeScanPlugin *barcodeScanPlugin = [[ALBarcodeScanPlugin alloc]
                                              initWithPluginID:kScanViewPluginBarcodeID
                                              delegate:self
                                              error:&error];
    
    [barcodeScanPlugin setBarcodeFormatOptions:@[kCodeTypePDF417]];
    [barcodeScanPlugin setParsePDF417:YES];
    
    self.barcodeScanPlugin = barcodeScanPlugin;
    
    ALBarcodeScanViewPlugin *barcodeScanViewPlugin = [[ALBarcodeScanViewPlugin alloc]
                                                      initWithScanPlugin:barcodeScanPlugin];
    
    self.barcodeScanViewPlugin = barcodeScanViewPlugin;
    
    ALScanViewPluginConfig *barcodeScanViewConfig = [ALScanViewPluginConfig defaultBarcodeConfig];
    barcodeScanViewConfig.cutoutConfig.strokeWidth = 0;
    barcodeScanViewConfig.cutoutConfig.backgroundColor = [UIColor clearColor];
    barcodeScanViewConfig.scanFeedbackConfig.vibrateOnResult = NO;
    barcodeScanViewConfig.scanFeedbackConfig.strokeWidth = 0;
    
    self.barcodeScanViewPlugin.scanViewPluginConfig = barcodeScanViewConfig;
    
    self.parallelScanViewPlugin = [[ALParallelScanViewPluginComposite alloc] initWithPluginID:kScanViewPluginParallelID];
    
    self.parallelScanViewPlugin.optionalTimeoutDelay = @(kBarcodeBacksideScanTimeout);
    [self.parallelScanViewPlugin addDelegate:self];
    
    [self.parallelScanViewPlugin addPlugin:self.scanViewPluginBack];
    
    self.barcodeScanViewPlugin.isOptional = YES;
    [self.parallelScanViewPlugin addPlugin:self.barcodeScanViewPlugin];

    // Combine front and back (which also includes barcode) in a SerialScanViewPlugin
    ALSerialScanViewPluginComposite *serialScanViewPlugin = [[ALSerialScanViewPluginComposite alloc]
                                                             initWithPluginID:kScanViewPluginSerialID];
    
    serialScanViewPlugin.timeout = @(kUniversalIDBacksideScanTimeout);
    [serialScanViewPlugin addPlugin:self.scanViewPluginFront];
    [serialScanViewPlugin addPlugin:self.parallelScanViewPlugin];
    
    self.serialScanViewPlugin = serialScanViewPlugin;
    [serialScanViewPlugin addDelegate:self];
    
    // Create ScanView and add our ScanViewPlugin Composite
    CGRect frame = [self scanViewFrame];

    NSString *configPath = [[NSBundle mainBundle] pathForResource:kCameraConfigJSON ofType:@"json"];
    ALCameraConfig *cameraConfig = [[ALCameraConfig alloc] initWithJsonFilePath:configPath];
    
    configPath = [[NSBundle mainBundle] pathForResource:kFlashConfigJSON ofType:@"json"];
    ALFlashButtonConfig *flashConfig = [[ALFlashButtonConfig alloc] initWithJsonFilePath:configPath];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame
                                       scanViewPlugin:self.serialScanViewPlugin
                                         cameraConfig:cameraConfig
                                    flashButtonConfig:flashConfig];
    
    self.controllerType = ALScanHistoryUniversalID;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    // Start Camera
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    // Add scan hint label
    self.hintView = [[self class] createScanHintViewCenteredInView:self.view];
    [self.view addSubview:self.hintView];
    
    self.hintView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.hintView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    self.cutoutGuideYOffsetConstraint = [self.hintView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    self.cutoutGuideYOffsetConstraint.active = YES;
    
    self.hintViewLabel = [[self class] createScanHintViewLabelWithText:kScanIDFrontLabelText inView:self.hintView margin:7.0f];
    
    [self.hintView.heightAnchor constraintEqualToAnchor:self.hintViewLabel.heightAnchor constant:20].active = YES;
    [self.hintView.widthAnchor constraintEqualToAnchor:self.hintViewLabel.widthAnchor constant:20].active = YES;
    
    self.gifImageView = [[GifuWrapper alloc] init];
    self.gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scanView addSubview:self.gifImageView];
    self.gifImageView.alpha = 0.80;
    self.gifImageView.layer.cornerRadius = 5.0;
    self.gifImageView.layer.masksToBounds = YES;

    CGRect gifFrame =  CGRectMake(0, 0, 500, 310);
    self.gifImageView.frame = gifFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnylineScanner];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSError *error;
    [self.serialScanViewPlugin stopAndReturnError:&error];
    [self resetResultData];
    [super viewWillDisappear:animated];
}

// MARK: - Plugin Management

- (void)startAnylineScanner {
    NSError *error;
    BOOL success = [self.serialScanViewPlugin startAndReturnError:&error];
    if (!success) {
        
        __weak __block typeof(self) weakSelf = self;
        [self showAlertForScanningError:error completion:^{
            // Prevent the trouble scanning timeout timer from setting off
            //
            // NOTE: this won't help with the exceptional instance of user going to the
            // the univ-id first thing on new install, and the user sitting on the
            // request camera permission alert that comes out. But it will absolutely
            // work when the user had already previously revoked / denied the camera
            // access permission before entering the screen.
            [weakSelf.scanTimeoutFront invalidate];
            [weakSelf.scanTimeoutBack invalidate];
            weakSelf.scanTimeoutFront = nil;
            weakSelf.scanTimeoutBack = nil;
        } dismissHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    [self resetResultData];
    
    self.scanTimeoutFront = [self startTimeout:kUniversalIDSerialScanTimeout
                                scanViewPlugin:self.scanViewPluginFront];
    
}

- (void)prepareForBacksideScanWithDelay:(NSTimeInterval)secondsToDisplay
                             completion:(void (^ __nullable)(void))completion {
    [self updateScanLabelWithStringWithAnimation:kScanIDBackLabelText];
    self.gifImageView.hidden = false;
    [self hideGIFView:false];
    [self.gifImageView startGIFWithGifName:@"flip_id" loopCount:1];
    if (completion == nil) {
        return;
    }
    __weak __block typeof(self) weakSelf = self;
    dispatch_time_t gifTimeout = dispatch_time(DISPATCH_TIME_NOW, secondsToDisplay * NSEC_PER_SEC);
    dispatch_after(gifTimeout, dispatch_get_main_queue(), ^(void){
        [weakSelf.gifImageView stopGIF];
        [weakSelf hideGIFView:true];
        completion();
    });
}

- (NSTimer *)startTimeout:(NSTimeInterval)timeoutInterval scanViewPlugin:(ALAbstractScanViewPlugin *)scanViewPlugin {
    return [NSTimer scheduledTimerWithTimeInterval:timeoutInterval
                                            target:self
                                          selector:@selector(scanningTimedOut:)
                                          userInfo:@{ @"plugin": scanViewPlugin }
                                           repeats:NO];
}


- (void)scanningTimedOut:(NSTimer *)timer {
    ALAbstractScanViewPlugin *scanViewPlugin = [[timer userInfo] valueForKey:@"plugin"];
    [self timer:timer timedOutWithPlugin:scanViewPlugin];
}

// MARK: - Scan View Plugin Delegate Methods

- (void)timer:(NSTimer *)timer timedOutWithPlugin:(ALAbstractScanViewPlugin *)scanViewPlugin {
    if (timer == self.scanTimeoutFront) { // front scan timed out, should move to back side
        __weak __block typeof(self) weakSelf = self;
        [self prepareForBacksideScanWithDelay:0.3 completion:^{
            NSError *error;
            [weakSelf.serialScanViewPlugin startFromID:kScanViewPluginParallelID andReturnError:&error];
            weakSelf.scanTimeoutBack = [weakSelf startTimeout:kUniversalIDBacksideScanTimeout
                                               scanViewPlugin:weakSelf.parallelScanViewPlugin];
        }];
    } else if (timer == self.scanTimeoutBack) {
        [self presentResult];
    }
}

- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite * _Nonnull)anylineCompositeScanPlugin
                     didFindResult:(ALCompositeResult * _Nonnull)scanResult {
    if (anylineCompositeScanPlugin == self.serialScanViewPlugin) {
        [self presentResult];
    }
}

- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin * _Nonnull)anylineBarcodeScanPlugin
                   didFindResult:(ALBarcodeResult * _Nonnull)scanResult {
    self.detectedBarcode = scanResult;
}

- (void)anylineIDScanPlugin:(ALIDScanPlugin *)idScanPlugin didFindResult:(ALIDResult *)scanResult {
    
    ALUniversalIDIdentification *identification = (ALUniversalIDIdentification *)scanResult.result;
    ALLayoutDefinition *layoutDefinition = identification.layoutDefinition;
    
    if (idScanPlugin == self.scanPluginFront) {
        
        [self.scanTimeoutFront invalidate];
        self.scanTimeoutFront = nil;
        
        [self.resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil addIDSubResult:identification titleSuffix:@"" resultHistoryString:self.resultHistoryString]];
        [self.resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Country" value:layoutDefinition.country]];
        [self.resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Type" value:layoutDefinition.type]];
        
        self.frontScanImage = scanResult.image;
        self.faceScanImage = [scanResult.result faceImage];
        
        __weak __block typeof(self) weakSelf = self;
        [self prepareForBacksideScanWithDelay:0.3 completion:^{
            weakSelf.scanTimeoutBack = [weakSelf startTimeout:kUniversalIDBacksideScanTimeout
                                               scanViewPlugin:weakSelf.parallelScanViewPlugin];
        }];
    
    } else if (idScanPlugin == self.scanPluginBack) {
        [self.resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil
                                              addIDSubResult:identification
                                              titleSuffix:@" Back"
                                              resultHistoryString:self.resultHistoryString]];
        [self.resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Country" value:layoutDefinition.country]];
        [self.resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Type"
                                                                  value:layoutDefinition.type]];
        self.backScanImage = scanResult.image;
    }
}

- (void)anylineScanPlugin:(ALAbstractScanPlugin *)anylineScanPlugin reportInfo:(ALScanInfo *)info {
    if ([info.variableName isEqualToString:@"$brightness"]) {
        [self updateBrightness:[info.value floatValue] forModule:self.scanViewPluginFront];
    }
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    // Update Position of warning indicator
    [self updateWarningPosition:cutoutRect.origin.y + cutoutRect.size.height + self.scanView.frame.origin.y + 80];
    [self updateHintPosition:cutoutRect.origin.y + self.scanView.frame.origin.y - 50];
    self.gifImageView.frame = CGRectMake(cutoutRect.origin.x, cutoutRect.origin.x, cutoutRect.size.width * 0.9, cutoutRect.size.height * 0.9);
    self.gifImageView.center = CGPointMake(cutoutRect.origin.x + cutoutRect.size.width/2, cutoutRect.origin.y + cutoutRect.size.height/2);
}

// MARK: - Handle Results

- (void)presentResult {
    
    NSError *error;
    
    [self.serialScanViewPlugin stopAndReturnError:&error];
    
    [self.scanTimeoutFront invalidate];
    [self.scanTimeoutBack invalidate];
    self.scanTimeoutFront = nil;
    self.scanTimeoutBack = nil;

    NSString *barcodeString = @"";
    if (self.detectedBarcode != nil) {
        if (self.detectedBarcode.result.count > 0) {
            barcodeString = [ALBarcodeResultUtil strValueFromBarcode:self.detectedBarcode.result[0]];
        }
        [self.resultData addObjectsFromArray:[ALBarcodeResultUtil barcodeResultDataFromBarcodeResult:self.detectedBarcode]];
    }

    ALResultViewController *vc;

    if (self.resultData.count > 0) {
        // Write result in history
        [super anylineDidFindResult:self.resultHistoryString
                      barcodeResult:barcodeString
                              image:self.frontScanImage
                         scanPlugin:self.scanViewPluginFront.idScanPlugin
                         viewPlugin:self.serialScanViewPlugin completion:^{
        }];
    } else {
        // We couldn't read the back side of the ID
        ALResultEntry *barcodeResult = [[ALResultEntry alloc] initWithTitle:@"Result Data" value:@"This ID is either not supported yet or the scan wasn't captured properly.\n\nPlease try again." isAvailable:NO];
        [self.resultData addObject:barcodeResult];
    }

    vc = [[ALResultViewController alloc] initWithResults:self.resultData];
    vc.imagePrimary = self.frontScanImage;
    vc.imageSecondary = self.backScanImage;
    vc.imageFace = self.faceScanImage;

    [self resetResultData];    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetResultData {
    self.resultData = [NSMutableArray array];
    self.resultHistoryString = [NSMutableString string];
    self.detectedBarcode = nil;
    self.backScanImage = nil;
    self.frontScanImage = nil;
    self.faceScanImage = nil;
    self.scanTimeoutFront = nil;
    self.scanTimeoutBack = nil;
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

// MARK: - Manage Onscreen Guides

- (void)updateScanLabelWithStringWithAnimation:(NSString *)labelText {
    self.hintViewLabel.text = labelText;
    self.hintViewLabel.transform = CGAffineTransformScale(self.hintViewLabel.transform, .25, .25);
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

- (void)updateHintPosition:(CGFloat)newPosition {
    self.cutoutGuideYOffsetConstraint.constant = newPosition;
}

- (void)hideGIFView:(BOOL)willBeHidden {
    [UIView transitionWithView:self.gifImageView duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        self.gifImageView.hidden = willBeHidden;
    } completion:nil];
}


// MARK: - Miscellaneous

+ (NSDictionary *)configDictForIDScanPlugin {
    NSError *error = nil;
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"universal_id_config" ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:jsonFilePath];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:jsonFile
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    return configDict;
}

+ (UIView *)createScanHintViewCenteredInView:(UIView * _Nonnull)view {
    UIView *hintView = [[UILabel alloc] init];
    hintView.center = CGPointMake(view.center.x, 0);
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = true;
    hintView.backgroundColor = [[UIColor darkTextColor] colorWithAlphaComponent:0.6];
    return hintView;
}

+ (UILabel *)createScanHintViewLabelWithText:(NSString *)text inView:(UIView * _Nonnull)hintView margin:(CGFloat)margin {
    UILabel *hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    hintViewLabel.text = text;
    hintViewLabel.textColor = [UIColor lightTextColor];
    [hintViewLabel sizeToFit];
    
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintView addSubview:hintViewLabel];
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor].active = YES;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor].active = YES;
    
    return hintViewLabel;
}

@end
