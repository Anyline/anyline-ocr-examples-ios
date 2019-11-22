//
//  ALGermanIDFrontScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 12.03.18.
//

#import "ALGermanIDFrontScanViewController.h"
#import "ALAppDemoLicenses.h"
#import "ALResultViewController.h"
#import <Anyline/Anyline.h>


// This is the license key for the examples project used to set up Anyline below
NSString * const kGermanIDFrontLicenseKey = kDemoAppLicenseKey;
@interface ALGermanIDFrontScanViewController ()<ALIDPluginDelegate, ALInfoDelegate>
// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) ALIDScanViewPlugin *germanIDFrontScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *germanIDFrontScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALGermanIDFrontScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"German ID Front";
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    ALGermanIDFrontConfig *germanIDFrontConfig = [[ALGermanIDFrontConfig alloc] init];
    
    ALGermanIDFrontFieldScanOptions *options = [[ALGermanIDFrontFieldScanOptions alloc] init];
    
    NSError *error = nil;
    self.germanIDFrontScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" licenseKey:kGermanIDFrontLicenseKey delegate:self idConfig:germanIDFrontConfig error:&error];
    NSAssert(self.germanIDFrontScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.germanIDFrontScanPlugin addInfoDelegate:self];
    
    self.germanIDFrontScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.germanIDFrontScanPlugin];
    NSAssert(self.germanIDFrontScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.germanIDFrontScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryGermanIDFront;
    
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
    [self.germanIDFrontScanViewPlugin stopAndReturnError:nil];
}

/*
 This method is used to tell Anyline to start scanning. It gets called in
 viewDidAppear to start scanning the moment the view appears. Once a result
 is found scanning will stop automatically (you can change this behaviour
 with cancelOnResult:). When the user dismisses self.identificationView this
 method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.germanIDFrontScanViewPlugin];
}


#pragma mark -- AnylineOCRModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin
              didFindResult:(ALIDResult *)scanResult {
    [self.germanIDFrontScanViewPlugin stopAndReturnError:nil];
    
    ALGermanIDFrontIdentification *identification = (ALGermanIDFrontIdentification *)scanResult.result;
    
    NSMutableString * result = [NSMutableString string];
    [result appendString:[NSString stringWithFormat:@"Document Number: %@\n", [identification documentNumber]]];
    [result appendString:[NSString stringWithFormat:@"Surname: %@\n", [identification surname]]];
    [result appendString:[NSString stringWithFormat:@"Given Names: %@\n", [identification givenNames]]];
    [result appendString:[NSString stringWithFormat:@"Date of Birth: %@", [identification dateOfBirth]]];
    ;
    [super anylineDidFindResult:result barcodeResult:@"" image:scanResult.image scanPlugin:anylineIDScanPlugin viewPlugin:self.germanIDFrontScanViewPlugin completion:^{
        
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];

        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification surname]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification givenNames]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Birth" value:[identification dateOfBirth]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[identification documentNumber]]];
       
        if ([identification placeOfBirth]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Place of Birth" value:[identification placeOfBirth]]];
        }
        
        if ([(ALGermanIDFrontIdentification *)scanResult.result dateOfExpiry]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Expiry" value:[identification dateOfExpiry]]];
        }
        if ([identification nationality]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:[identification nationality]]];
        }
        
        if ([identification cardAccessNumber]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Card Access Number" value:[identification cardAccessNumber]]];
        }

        //Display the result
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image optionalImageTitle:@"Detected Face Image" optionalImage:[scanResult.result faceImage]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
