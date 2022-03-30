//
//  ALTINScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 26.08.19.
//

#import "ALTINScanViewController.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"
#import "ALUmbrella.h"
#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"
#import "ALConfigurationDialogViewController.h"
#if __has_include("ALContactUsViewController.h")
#import "ALContactUsViewController.h"
#endif

@interface ALTINScanViewController ()<ALTireScanPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate, ALConfigurationDialogViewControllerDelegate>

@property (nonatomic, strong) ALTireScanViewPlugin *tinScanViewPlugin;
@property (nonatomic, strong) ALTireScanPlugin *tinScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nullable, nonatomic, strong) UIButton *flipOrientationButton;
@property () BOOL isOrientationFlipped;
@property () NSUInteger dialogIndexSelected;


@end

@implementation ALTINScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor AL_BackgroundColor];
    self.title = @"TIN";
    self.dialogIndexSelected = 0;
    [self setupScanner:ALTINUniversal];
    
    [self setupConstraints];
    
    self.controllerType = ALScanHistoryTIN;
    
    [self setupFlipOrientationButton];
    [self setupNavigationBar];
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

- (void)enableLandscapeRight:(BOOL)enable {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.enableLandscapeRight = enable;
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewDidAppear:(BOOL)animated {
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

#pragma mark - Custom Actions

- (void)setupScanner:(ALTINScanMode)scanMode {
    [self.scanView removeFromSuperview];
    self.scanView = nil;
    
    ALTINConfig *config = [[ALTINConfig alloc] init];
    [config setScanMode:scanMode];
    NSError *error = nil;
    
    self.tinScanPlugin = [[ALTireScanPlugin alloc] initWithPluginID:@"TIRE"
                                                           delegate:self
                                                         tireConfig:config
                                                              error:&error];

    NSAssert(self.tinScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.tinScanPlugin addInfoDelegate:self];
    
    ALScanViewPluginConfig *viewPluginConfig = [ALScanViewPluginConfig defaultTINConfig];
    viewPluginConfig.delayStartScanTime = 2000;
    self.tinScanViewPlugin = [[ALTireScanViewPlugin alloc] initWithScanPlugin:self.tinScanPlugin scanViewPluginConfig:viewPluginConfig];

    [self.tinScanViewPlugin addScanViewPluginDelegate:self];
    NSAssert(self.tinScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    self.scanView = [[ALScanView alloc] initWithFrame:self.view.bounds scanViewPlugin:self.tinScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
}

- (void)setupConstraints {
    self.scanView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = @[[self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                             [self.scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                             [self.scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                             [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
    
    
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupFlipOrientationButton {
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

- (void)setupNavigationBar {
    UIBarButtonItem *scanModeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showOptionsSelectionDialog)];
    
    self.navigationItem.rightBarButtonItem = scanModeButton;
}

- (void)changeScanViewMode:(ALTINScanMode)scanMode {
    [self.tinScanViewPlugin stopAndReturnError:nil];
    [self setupScanner:scanMode];
    [self setupConstraints];
    [self.view bringSubviewToFront:self.flipOrientationButton];
    [self.tinScanViewPlugin startAndReturnError:nil];
}

- (void)showOptionsSelectionDialog {
    NSArray<NSString *> *choices = @[ @"Universal TIN/DOT", @"TIN/DOT (North America only)", @"Other tire sidewall information" ];
    NSArray<NSNumber *> *selections = @[@(self.dialogIndexSelected)];
    ALConfigurationDialogViewController *vc = [[ALConfigurationDialogViewController alloc]
                                               initWithChoices:choices
                                               selections:selections
                                               secondaryTexts:@[]
                                               showApplyBtn:NO
                                               dialogType:ALConfigDialogTypeScriptSelection];
    vc.delegate = self;
    [vc setSelectionDialogFontSize:16.0];
    [self presentViewController:vc animated:YES completion:nil];
    [self dialogStarted];
}

- (void)dialogStarted {
    [self startCamera:NO];
}

- (void)dialogCancelled {
    [self startCamera:YES];
}

- (void)startCamera:(BOOL)start {
    if (start) {
        [self.scanView startCamera];
    } else {
        [self.scanView stopCamera];
    }
}

- (void)presentContactUsDialog {
    ALTINScanViewController __weak *weakself = self;
#if __has_include("ALContactUsViewController.h")
    [self dismissViewControllerAnimated:YES completion:^{
        ALContactUsViewController *contactVC = [[ALContactUsViewController alloc] init];
        [weakself presentViewController:contactVC animated:YES completion:nil];
        [contactVC setPresentationBlock:^{
            [weakself dialogCancelled];
        }];
    }];
#endif
}

// MARK: - ALTireScanPluginDelegate

- (void)anylineTireScanPlugin:(ALTireScanPlugin * _Nonnull)anylineTireScanPlugin
                didFindResult:(ALTireResult * _Nonnull)result {

    [self enableLandscapeOrientation:NO];

    NSMutableArray <ALResultEntry*> *resultData = [NSMutableArray array];

    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Tire Identification Number"
                                                         value:result.result
                                           shouldSpellOutValue:YES]];

    NSString *jsonString = [self jsonStringFromResultData:resultData];
    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString barcodeResult:@""
                         image:result.image
                    scanPlugin:anylineTireScanPlugin
                    viewPlugin:self.tinScanViewPlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc]
                                      initWithResults:resultData];
        vc.imagePrimary = result.image;

        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

// MARK: - ALConfigurationDialogViewControllerDelegate

- (void)configDialog:(ALConfigurationDialogViewController *)dialog selectedIndex:(NSUInteger)index {
    switch (index) {
        case 0: //universal
            self.dialogIndexSelected = index;
            [self changeScanViewMode:ALTINUniversal];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1: //standart
            self.dialogIndexSelected = index;
            [self changeScanViewMode:ALTINDot];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2: // popup
            [self presentContactUsDialog];
            break;
    }
}

- (void)configDialogCommitted:(BOOL)commited dialog:(ALConfigurationDialogViewController *)dialog {}

- (void)configDialogCancelled:(ALConfigurationDialogViewController *)dialog {}


@end
