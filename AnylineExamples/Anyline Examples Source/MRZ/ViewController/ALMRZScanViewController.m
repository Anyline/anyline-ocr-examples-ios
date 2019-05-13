//
//  ALPassportScanViewController.m
//  AnylineExamples
//
//  Created by Matthias on 24/05/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALMRZScanViewController.h"
#import "ALIdentificationView.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALAppDemoLicenses.h"
#import "ALResultViewController.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kMRZLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineMRZModuleDelegate> to be able to receive results
@interface ALMRZScanViewController ()<ALIDPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) ALIDScanViewPlugin *mrzScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *mrzScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALMRZScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"MRZ";
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    ALMRZConfig *mrzConfig = [[ALMRZConfig alloc] init];
    
    //Create fieldScanOptions to configure individual scannable fields
    ALMRZFieldScanOptions *scanOptions = [[ALMRZFieldScanOptions alloc] init];
    scanOptions.vizAddress = ALDefault;
    scanOptions.vizDateOfIssue = ALDefault;
    scanOptions.vizSurname = ALDefault;
    scanOptions.vizGivenNames = ALDefault;
    scanOptions.vizDateOfBirth = ALDefault;
    scanOptions.vizDateOfExpiry = ALDefault;
    
    
    
    //Set scanOptions for MRZConfig
    mrzConfig.idFieldScanOptions = scanOptions;
    
    NSError *error = nil;

    //Init the anyline ID ScanPlugin with an ID, Licensekey, the delegate,
    //  the MRZConfig (which will configure the scan Plugin for MRZ scanning), and an error
    self.mrzScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" licenseKey:kMRZLicenseKey delegate:self idConfig:mrzConfig error:&error];
    NSAssert(self.mrzScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanPlugin addInfoDelegate:self];
    
    
    self.mrzScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.mrzScanPlugin];
    NSAssert(self.mrzScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanViewPlugin addScanViewPluginDelegate:self];
    
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.mrzScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryMrz;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];
    
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

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.mrzScanViewPlugin stopAndReturnError:nil];
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
    BOOL success = [self.mrzScanViewPlugin startAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Start Scanning Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    self.startTime = CACurrentMediaTime();
}

#pragma mark -- AnylineMRZModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin didFindResult:(ALIDResult *)scanResult {
    ALMRZIdentification *identification = (ALMRZIdentification*)scanResult.result;
    
    [self.mrzScanViewPlugin stopAndReturnError:nil];
    NSMutableString * result = [NSMutableString string];
    [result appendString:[NSString stringWithFormat:@"Document Type: %@\n", [identification documentType]]];
    [result appendString:[NSString stringWithFormat:@"Document Number: %@\n", [identification documentNumber]]];
    [result appendString:[NSString stringWithFormat:@"Surname: %@\n", [identification surname]]];
    [result appendString:[NSString stringWithFormat:@"Given Names: %@\n", [identification givenNames]]];
    [result appendString:[NSString stringWithFormat:@"Issuing Country Code: %@\n", [identification issuingCountryCode]]];
    [result appendString:[NSString stringWithFormat:@"Nationality Country Code: %@\n", [identification nationalityCountryCode]]];
    [result appendString:[NSString stringWithFormat:@"Day Of Birth: %@\n", [identification dateOfBirth]]];
    [result appendString:[NSString stringWithFormat:@"Date of Expiry: %@\n", [identification dateOfExpiry]]];
    [result appendString:[NSString stringWithFormat:@"Sex: %@\n", [identification sex]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Number: %@\n", [identification checkDigitDocumentNumber]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Expiration Date: %@\n", [identification checkDigitDateOfExpiry]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Day Of Birth: %@\n", [identification checkDigitDateOfBirth]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Final: %@\n", [identification checkDigitFinal]]];
    [result appendString:[NSString stringWithFormat:@"Personal Number: %@\n", [identification personalNumber]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Personal Number: %@\n", [identification checkDigitPersonalNumber]]];

    
    [super anylineDidFindResult:result barcodeResult:@"" image:scanResult.image scanPlugin:anylineIDScanPlugin viewPlugin:self.mrzScanViewPlugin completion:^{
        
        //MRZ Fields
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification givenNames]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification surname]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Sex" value:[identification sex]]];
        [resultData addObject:[self resultEntryWithDate:[identification dateOfBirthObject] dateString:[identification dateOfBirth] title:@"Date of Birth"]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Type" value:[identification documentType]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[identification documentNumber]]];
        [resultData addObject:[self resultEntryWithDate:[identification dateOfExpiryObject] dateString:[identification dateOfExpiry] title:@"Date of Expiry"]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:[identification nationalityCountryCode]]];
        if ([identification personalNumber] && [identification personalNumber].length > 0) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Personal Number" value:[identification personalNumber]]];
        }
        
        
        //VIZ Fields
        NSMutableArray <ALResultEntry*> *vizResultData = [[NSMutableArray alloc] init];
        if ([identification vizGivenNames] && [identification vizGivenNames].length > 0) {
          [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification vizGivenNames]]];
        }
        if ([identification vizSurname] && [identification vizSurname].length > 0) {
            [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification vizSurname]]];
        }
        if ([identification vizAddress] && [identification vizAddress].length > 0) {
            [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Address" value:[identification vizAddress]]];
        }
        if ([identification vizDateOfBirth] && [identification vizDateOfBirth].length > 0) {
            [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfBirthObject] dateString:[identification vizDateOfBirth] title:@"Date of Birth"]];
        }
        if ([identification vizDateOfExpiry] && [identification vizDateOfExpiry].length > 0) {
            [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfExpiryObject] dateString:[identification vizDateOfExpiry] title:@"Date of Expiry"]];
        }
        if ([identification vizDateOfIssue] && [identification vizDateOfIssue].length > 0) {
            [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfIssueObject] dateString:[identification vizDateOfIssue] title:@"Date of Issue"]];
        }
        
        NSMutableDictionary *resultDataDict = [[NSMutableDictionary alloc] init];
        [resultDataDict setObject:resultData forKey:@"Machine Readable Zone"];
        if (vizResultData.count > 0) {
            [resultDataDict setObject:vizResultData forKey:@"Visual Inspection Zone"];
        }
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultDataDictionary:resultDataDict image:scanResult.image optionalImageTitle:@"Detected Face Image" optionalImage:[scanResult.result faceImage]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (ALResultEntry *)resultEntryWithDate:(NSDate *)date dateString:(NSString *)dateString title:(NSString *)title {
    BOOL isAvailable = [self checkDateIfAvailable:date dateString:dateString];
    if (!isAvailable) {
        return [[ALResultEntry alloc] initWithTitle:title value:nil];
    }
    
    NSString *value = [self stringForDate:date];
    return [[ALResultEntry alloc] initWithTitle:title value:value isAvailable:isAvailable];
}

- (BOOL)checkDateIfAvailable:(NSDate *)date dateString:(NSString *)dateString {
    if (!date && dateString.length == 0) {
        return NO;
    }
    return YES;
}

- (NSString *)stringForDate:(NSDate *)date {
    if (!date) {
        return @"Date not valid";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    return [dateFormatter stringFromDate:date];
}
@end
