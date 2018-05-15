//
//  ALDrivingLicenseScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18.12.17.
//

#import "ALDrivingLicenseScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"
#import "ALResultViewController.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kDrivingLicenseLicenseKey = kDemoAppLicenseKey;
@interface ALDrivingLicenseScanViewController ()<AnylineOCRModuleDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;


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


#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineOCRModuleView:(AnylineOCRModuleView *)anylineOCRModuleView
               didFindResult:(ALOCRResult *)result {
    
    // We are done. Cancel scanning
    [self anylineDidFindResult:result.result barcodeResult:@"" image:result.image module:anylineOCRModuleView completion:^{
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        
        NSArray<NSString *> *comps = [result.result componentsSeparatedByString:@"|"];
        
        NSString *surNames = comps[0];
        NSString *givenNames = comps[1];
        NSString *birthdateID = comps[2];
        NSString *idNumber = comps[3];
        
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
        
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Last Name" value:surNames]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"First Name" value:givenNames]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Birth" value:[formatter stringFromDate:date]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:idNumber]];
        
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:result.image];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
