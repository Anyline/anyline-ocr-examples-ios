//
//  ALNLDrivingLicenseScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 01.08.2019.
//

#import "ALNLDrivingLicenseScanViewController.h"
#import "ALAppDemoLicenses.h"
#import "ALResultViewController.h"
#import <Anyline/Anyline.h>


// This is the license key for the examples project used to set up Anyline below
NSString * const kNLDrivingLicenseLicenseKey = kDemoAppLicenseKey;
@interface ALNLDrivingLicenseScanViewController ()<ALIDPluginDelegate, ALInfoDelegate>
// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) ALIDScanViewPlugin *drivingLicenseScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *drivingLicenseScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALNLDrivingLicenseScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"NL Driving License";
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALDrivingLicenseConfig *drivingLicenseConfig = [[ALDrivingLicenseConfig alloc] init];
    drivingLicenseConfig.scanMode = ALDrivingLicenseNL;
    
    NSError *error = nil;
    self.drivingLicenseScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" licenseKey:kNLDrivingLicenseLicenseKey delegate:self idConfig:drivingLicenseConfig error:&error];
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
    
    NSMutableString * result = [NSMutableString string];
    [result appendString:[NSString stringWithFormat:@"Document Number: %@\n", [identification documentNumber]]];
    [result appendString:[NSString stringWithFormat:@"Last Name: %@\n", [identification surname]]];
    [result appendString:[NSString stringWithFormat:@"First Name: %@\n", [identification givenNames]]];
    [result appendString:[NSString stringWithFormat:@"Date of Birth: %@", [identification dateOfBirth]]];
    ;
    [super anylineDidFindResult:result barcodeResult:@"" image:scanResult.image scanPlugin:anylineIDScanPlugin viewPlugin:self.drivingLicenseScanViewPlugin completion:^{
        
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];

        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification surname]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification givenNames]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Birth" value:[identification dateOfBirth]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[identification documentNumber]]];
       
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

        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image optionalImageTitle:@"Detected Face Image" optionalImage:[scanResult.result faceImage]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.drivingLicenseScanViewPlugin startAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
