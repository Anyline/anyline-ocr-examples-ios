//
//  ALSerialScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 30.07.19.
//

#import <Anyline/Anyline.h>
#import "ALResultEntry.h"
#import "ALResultViewController.h"
#import "ALSerialScanViewController.h"

@interface ALSerialScanViewController () <ALCompositeScanPluginDelegate>

@property (nonatomic, strong) ALSerialScanViewPluginComposite *serialScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALSerialScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Serial Scanning";
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    NSError *error = nil;
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"serialscanconfig" ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:confPath];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData: jsonFile options: NSJSONReadingMutableContainers error: &error];
    self.serialScanViewPlugin = [ALSerialScanViewPluginComposite scanViewPluginForConfigDict:configDict delegate:self error:&error];
    //this should happen within the SDK, but doesn't yet
    [self.serialScanViewPlugin addDelegate:self];
    NSAssert(self.serialScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.serialScanViewPlugin];
    
    //Enable Zoom Gesture
    [self.scanView enableZoomPinchGesture:YES];
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
    
    //Enable Zoom Gesture for the scanView
    [self.scanView enableZoomPinchGesture:YES];
    
    self.controllerType = ALScanHistoryContainer;
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
    [self.serialScanViewPlugin stopAndReturnError:nil];
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
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Start Scanning Error: %@", error.debugDescription);
    }
}

- (NSArray <ALResultEntry*> *)resultDataForDrivingLicenseResult:(ALDrivingLicenseIdentification *)identification {
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
    return resultData;
}

- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite * _Nonnull)anylineCompositeScanPlugin didFindResult:(ALCompositeResult * _Nonnull)result {
    NSMutableDictionary *resultDataDict = [[NSMutableDictionary alloc] init];
    UIImage *lastImage=nil;
    UIImage *firstImage=nil;
    for (NSString *key in result.result.allKeys) {
        NSArray <ALResultEntry*> *resultData = nil;
        id pluginResult = result.result[key].result;
        if ([pluginResult isKindOfClass:[NSString class]]) {
            resultData = [NSArray arrayWithObject:[[ALResultEntry alloc] initWithTitle:@"Result" value:result.result[key].result]];
        } else if ([pluginResult isKindOfClass:[ALDrivingLicenseIdentification class]]) {
            resultData=[self resultDataForDrivingLicenseResult:pluginResult];
        }
        [resultDataDict setObject:resultData forKey:key];
        if (result.result[key].image != nil) {
            lastImage = result.result[key].image;
            if (firstImage == nil) {
                firstImage = lastImage;
            }
        }
    }
    //we could have any number of images, but ALResultViewController can handle at least one and at most two, so for simplicity let's show the first and last.
    
    ALResultViewController *vc = [[ALResultViewController alloc] initWithResultDataDictionary:resultDataDict
                                                                                        image:lastImage
                                                                                optionalImage:firstImage
                                                                                    faceImage:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
