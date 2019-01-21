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
    
    NSError *error = nil;

    self.mrzScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" licenseKey:kMRZLicenseKey delegate:self idConfig:mrzConfig error:&error];
    NSAssert(self.mrzScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanPlugin addInfoDelegate:self];
    
    self.mrzScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.mrzScanPlugin];
    NSAssert(self.mrzScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanViewPlugin addScanViewPluginDelegate:self];
    
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.mrzScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryMrz;
    
    // After setup is complete we add the module to the view of this view controller
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
    [self.mrzScanViewPlugin stopAndReturnError:nil];
    NSMutableString * result = [NSMutableString string];
    [result appendString:[NSString stringWithFormat:@"Document Type: %@\n", [scanResult.result documentType]]];
    [result appendString:[NSString stringWithFormat:@"Document Number: %@\n", [scanResult.result documentNumber]]];
    [result appendString:[NSString stringWithFormat:@"Surnames: %@\n", [scanResult.result surNames]]];
    [result appendString:[NSString stringWithFormat:@"Given Names: %@\n", [scanResult.result givenNames]]];
    [result appendString:[NSString stringWithFormat:@"Issuing Country Code: %@\n", [scanResult.result issuingCountryCode]]];
    [result appendString:[NSString stringWithFormat:@"Nationality Country Code: %@\n", [scanResult.result nationalityCountryCode]]];
    [result appendString:[NSString stringWithFormat:@"Day Of Birth: %@\n", [scanResult.result dayOfBirth]]];
    [result appendString:[NSString stringWithFormat:@"Expiration Date: %@\n", [scanResult.result expirationDate]]];
    [result appendString:[NSString stringWithFormat:@"Sex: %@\n", [scanResult.result sex]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Number: %@\n", [scanResult.result checkdigitNumber]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Expiration Date: %@\n", [scanResult.result checkdigitExpirationDate]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Day Of Birth: %@\n", [scanResult.result checkdigitDayOfBirth]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Final: %@\n", [scanResult.result checkdigitFinal]]];
    [result appendString:[NSString stringWithFormat:@"Personal Number: %@\n", [scanResult.result personalNumber]]];
    [result appendString:[NSString stringWithFormat:@"Check Digit Personal Number: %@\n", [scanResult.result checkDigitPersonalNumber]]];

    
    [super anylineDidFindResult:result barcodeResult:@"" image:scanResult.image scanPlugin:anylineIDScanPlugin viewPlugin:self.mrzScanViewPlugin completion:^{
        
        ALMRZIdentification *mrzIdentification = (ALMRZIdentification *)scanResult.result;
        
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Name" value:[scanResult.result givenNames]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[scanResult.result surNames]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Sex" value:[scanResult.result sex]]];
        [resultData addObject:[self resultEntryWithDate:[scanResult.result dayOfBirthDateObject] dateString:[scanResult.result dayOfBirth] title:@"Date of Birth"]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Type" value:[scanResult.result documentType]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[scanResult.result documentNumber]]];
        [resultData addObject:[self resultEntryWithDate:[scanResult.result expirationDateObject] dateString:[((ALMRZIdentification *)scanResult.result) expirationDate] title:@"Expiration Date"]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:[scanResult.result nationalityCountryCode]]];
        
        if ([[scanResult.result documentType] isEqualToString:@"ID"] && [[scanResult.result issuingCountryCode] isEqualToString:@"D"]) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Address" value:mrzIdentification.address]];
        }
        
        if ([scanResult.result issuingDate] && [scanResult.result issuingDate].length > 0) {
            [resultData addObject:[self resultEntryWithDate:[scanResult.result issuingDateObject] dateString:[((ALMRZIdentification *)scanResult.result) issuingDate] title:@"Issuing Date"]];
        }
        
        if ([scanResult.result personalNumber] && [scanResult.result personalNumber].length > 0) {
            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Personal Number" value:[scanResult.result personalNumber]]];
        }
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image optionalImageTitle:@"Detected Face Image" optionalImage:[scanResult.result faceImage]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (ALResultEntry *)resultEntryWithDate:(NSDate *)date dateString:(NSString *)dateString title:(NSString *)title {
    if (![self checkDateIfAvailable:date dateString:dateString]) {
        return [[ALResultEntry alloc] initWithTitle:title value:nil];
    }
    
    NSString *value = [self stringForDate:date];
    return [[ALResultEntry alloc] initWithTitle:title value:value isAvailable:(date)];
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
