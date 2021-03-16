//
//  ALTINScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 26.08.19.
//

#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>

#import "ALResultEntry.h"
#import "ALResultViewController.h"

#import "ALUmbrella.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALTINScanViewController ()<ALOCRScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline plugin used for OCR
@property (nonatomic, strong) ALOCRScanViewPlugin *tinScanViewPlugin;
@property (nonatomic, strong) ALOCRScanPlugin *tinScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;
@property () BOOL isOrientationFlipped;


@end

@implementation ALTINScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"TIN";
    ALTINConfig *config = [[ALTINConfig alloc] init];
    
    NSError *error = nil;
    
    self.tinScanPlugin = [[ALOCRScanPlugin alloc] initWithPluginID:@"ANYLINE_OCR"
                                                          delegate:self
                                                         ocrConfig:config
                                                             error:&error];
    NSAssert(self.tinScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.tinScanPlugin addInfoDelegate:self];
    
    ALScanViewPluginConfig *viewPluginConfig = [ALScanViewPluginConfig defaultTINConfig];
    viewPluginConfig.delayStartScanTime = 2000;
    self.tinScanViewPlugin = [[ALOCRScanViewPlugin alloc] initWithScanPlugin:self.tinScanPlugin scanViewPluginConfig:viewPluginConfig];
    [self.tinScanViewPlugin addScanViewPluginDelegate:self];
    NSAssert(self.tinScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.tinScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    self.scanView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
       id topGuide = self.topLayoutGuide;
       [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];
    
    self.controllerType = ALScanHistoryTIN;
    
    self.flipOrientationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flipOrientationButton addTarget:self
                                   action:@selector(flipOrientationPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    self.flipOrientationButton.frame = CGRectMake(0, 0, 220, 50);
    UIImage *buttonImage = [UIImage imageNamed:@"baseline_screen_rotation_white_24pt"];
    [self.flipOrientationButton setImage:buttonImage forState:UIControlStateNormal];
    self.flipOrientationButton.imageView.tintColor = UIColor.whiteColor;
    [self.flipOrientationButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0)];
    self.flipOrientationButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.flipOrientationButton.adjustsImageWhenDisabled = NO;
    
    [self.flipOrientationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5.0, 0.0, 5.0)];
    [self.flipOrientationButton setTitle:@"Change Screen Orientation" forState:UIControlStateNormal];
    self.flipOrientationButton.titleLabel.font = [UIFont AL_proximaRegularWithSize:14];
    
    
    [self.view addSubview:self.flipOrientationButton];
    self.flipOrientationButton.layer.cornerRadius = 3;
    self.flipOrientationButton.backgroundColor = [[UIColor AL_examplesBlue] colorWithAlphaComponent:0.85];
    self.isOrientationFlipped = false;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomPadding;
    if (@available(iOS 11, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        bottomPadding = window.safeAreaInsets.bottom;
    } else {
        bottomPadding = 0;
    }

    self.flipOrientationButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height-self.flipOrientationButton.frame.size.height/2-bottomPadding-10);
}

- (void)flipOrientationPressed:(id)sender {
    self.isOrientationFlipped = !self.isOrientationFlipped;
    [self enableLandscapeOrientation:self.isOrientationFlipped];
}

- (void)enableLandscapeOrientation:(BOOL)isLandscape {
    [self enableLandscapeRight:isLandscape];
    
    NSNumber *value;
    if (isLandscape) {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    } else {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(void) enableLandscapeRight:(BOOL)enable {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.enableLandscapeRight = enable;
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self enableLandscapeOrientation:self.isOrientationFlipped];
    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self startAnyline];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tinScanViewPlugin stopAndReturnError:nil];
    [self enableLandscapeOrientation:NO];
}


/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.tinScanViewPlugin];
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
- (void)anylineOCRScanPlugin:(ALOCRScanPlugin *)anylineOCRScanPlugin
               didFindResult:(ALOCRResult *)result {
    
    [self enableLandscapeOrientation:NO];
    // We are done. Cancel scanning
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Tire Identification Number" value:result.result shouldSpellOutValue:YES]];
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:result.image scanPlugin:anylineOCRScanPlugin viewPlugin:self.tinScanViewPlugin completion:^{
        //Display the result
        
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
