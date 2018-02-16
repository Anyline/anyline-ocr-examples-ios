//
//  ALDrivingLicenseScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18.12.17.
//

#import "ALDrivingLicenseScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"
#import "ALEUDrivingLicenseView.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kDrivingLicenseLicenseKey = kDemoAppLicenseKey;
@interface ALDrivingLicenseScanViewController ()<AnylineOCRModuleDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;

@property (nonatomic, strong) ALEUDrivingLicenseView *drivingLicenseView;

@end

@implementation ALDrivingLicenseScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"AT Driver License";
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.ocrModuleView = [[AnylineOCRModuleView alloc] initWithFrame:frame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    
    NSString *engTraineddata = [[NSBundle mainBundle] pathForResource:@"eng_no_dict" ofType:@"traineddata"];
    NSString *deuTraineddata = [[NSBundle mainBundle] pathForResource:@"deu" ofType:@"traineddata"];
    config.languages = @[deuTraineddata, engTraineddata];
    
    NSString *cmdFile = [[NSBundle mainBundle] pathForResource:@"anyline_austrian_driving_license" ofType:@"ale"];
    config.customCmdFilePath = cmdFile;
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.ocrModuleView setupWithLicenseKey:kDrivingLicenseLicenseKey
                                                  delegate:self
                                                 ocrConfig:config
                                                     error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"drivinglicense_capture_config" ofType:@"json"];
    ALUIConfiguration *drivingConf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.ocrModuleView.currentConfiguration = drivingConf;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.ocrModuleView];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDriverLicenseView:)];
    
    self.drivingLicenseView = [[ALEUDrivingLicenseView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/1.4)];
    
    [self.drivingLicenseView addGestureRecognizer:gr];
    self.drivingLicenseView.center = self.view.center;
    [self.view insertSubview:self.drivingLicenseView belowSubview:self.ocrModuleView];
    
    self.drivingLicenseView.alpha = 0;
    
    self.controllerType = ALScanHistoryScrabble;
    
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
    [self.ocrModuleView cancelScanningAndReturnError:nil];
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
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
}

/*
 Dismiss the view if the user taps the screen
 */
-(void)didTapDriverLicenseView:(id) sender {
    if(self.drivingLicenseView.alpha == 1.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.4 animations:^{
                self.drivingLicenseView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                self.drivingLicenseView.alpha = 0;
            } completion:^(BOOL finished) {
                // We start scanning again once the animation completed
                [self startAnyline];
            }];
        });
    }
}

/*
 A little animation for the user to see the scanned document.
 */
-(void)animateScanDidComplete {
    [self.view bringSubviewToFront:self.drivingLicenseView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.drivingLicenseView.center = self.view.center;
        self.drivingLicenseView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.drivingLicenseView.alpha = 1.0;
            self.drivingLicenseView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
            self.drivingLicenseView.transform = CGAffineTransformMakeScale(0.87, 0.87);
            self.drivingLicenseView.center = self.view.center;
        } completion:^(BOOL finished) {
        }];
    });
}


#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
               didFindResult:(ALOCRResult *)result {
    
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image module:anylineOCRModuleView completion:^{
        
        NSArray<NSString *> *comps = [result.result componentsSeparatedByString:@"|"];
        
        NSString *name = comps[0];
        NSString *birthdateID = comps[1];
        
        NSArray<NSString *> *nameComps = [name componentsSeparatedByString:@" "];
        
        if (nameComps.count == 3) {
            self.drivingLicenseView.surname.text = nameComps[0];
            self.drivingLicenseView.surname2.text = nameComps[1];
            self.drivingLicenseView.givenNames.text = nameComps[2];
        } else {
            self.drivingLicenseView.surname.text = nameComps[0];
            self.drivingLicenseView.givenNames.text = nameComps[1];
            self.drivingLicenseView.surname2.text = @"";
        }
        
        NSArray<NSString *> *birthdateIDComps = [birthdateID componentsSeparatedByString:@" "];
        
        NSString *birthday = birthdateIDComps[0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"ddMMyyyy";
        NSDate *date = [formatter dateFromString:birthday];
        
        if (!date) {
            formatter.dateFormat = @"yyyyMMdd";
            date = [formatter dateFromString:birthday];
        }
        
        formatter.dateFormat = @"yyyy-MM-dd";
        
        self.drivingLicenseView.birthdate.text = [formatter stringFromDate:date];
        self.drivingLicenseView.idNumber.text = birthdateIDComps[1];
        
        [self animateScanDidComplete];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
