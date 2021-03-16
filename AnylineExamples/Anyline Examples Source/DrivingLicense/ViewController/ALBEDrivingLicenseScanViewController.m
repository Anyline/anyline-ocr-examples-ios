//
//  ALBEDrivingLicenseScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 01.08.2019.
//

#import "ALBEDrivingLicenseScanViewController.h"
#import "ALResultViewController.h"
#import "ALUniversalIDFieldnameUtil.h"
#import <Anyline/Anyline.h>

@interface ALBEDrivingLicenseScanViewController ()<ALIDPluginDelegate, ALInfoDelegate>
// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) ALIDScanViewPlugin *drivingLicenseScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *drivingLicenseScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALBEDrivingLicenseScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"BE Driving License";
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALDrivingLicenseConfig *drivingLicenseConfig = [[ALDrivingLicenseConfig alloc] init];
    drivingLicenseConfig.scanMode = ALDrivingLicenseBE;
    
    NSError *error = nil;
    self.drivingLicenseScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" delegate:self idConfig:drivingLicenseConfig error:&error];
    NSAssert(self.drivingLicenseScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.drivingLicenseScanPlugin addInfoDelegate:self];
    
    self.drivingLicenseScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.drivingLicenseScanPlugin];
    NSAssert(self.drivingLicenseScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.drivingLicenseScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryDrivingLicense;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
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
    [self.drivingLicenseScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.drivingLicenseScanViewPlugin];
}


#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin
              didFindResult:(ALIDResult *)scanResult {
    [self.drivingLicenseScanViewPlugin stopAndReturnError:nil];
    
    ALDrivingLicenseIdentification *identification = (ALDrivingLicenseIdentification *)scanResult.result;
    
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];

    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification surname]]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification givenNames]]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Birth" value:[identification dateOfBirth]]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[identification documentNumber] shouldSpellOutValue:YES]];
   
    if ([identification placeOfBirth]) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Place of Birth" value:[identification placeOfBirth]]];
    }
    if ([identification dateOfIssue]) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Issue" value:[identification dateOfIssue]]];
    }
    if ([identification dateOfExpiry]) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Expiry" value:[identification dateOfExpiry]]];
    }
    if ([identification authority]) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Authority" value:[identification authority]]];
    }
    if ([identification categories]) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Categories" value:[identification categories]]];
    }
    resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    
    [self anylineDidFindResult:jsonString barcodeResult:@"" image:scanResult.image scanPlugin:anylineIDScanPlugin viewPlugin:self.drivingLicenseScanViewPlugin completion:^{
        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData
                                                                                  image:scanResult.image
                                                                          optionalImage:[scanResult.result documentBackImage]
                                                                              faceImage:[scanResult.result faceImage]
                                                                   shouldShowDisclaimer:YES];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
