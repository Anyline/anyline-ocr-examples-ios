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
@interface ALMRZScanViewController ()<AnylineMRZModuleDelegate>
// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) AnylineMRZModuleView *mrzModuleView;

@end

@implementation ALMRZScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MRZ";
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];

    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.mrzModuleView = [[AnylineMRZModuleView alloc] initWithFrame:frame];
    
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    [self.mrzModuleView setupAsyncWithLicenseKey:kMRZLicenseKey delegate:self finished:^(BOOL success, NSError * _Nullable error) {
        // the finish block of setupWithLicenseKey:delegate:finished:error will returns true if everything went fine. In the case something wrong
        // we have to check the error object for the error message.
        if( !success ) {
            // Something went wrong. The error object contains the error description
            [[[UIAlertView alloc] initWithTitle:@"Setup Error"
                                        message:error.debugDescription
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
    
    self.mrzModuleView.flashButtonAlignment = ALFlashAlignmentTopLeft;
    
    self.mrzModuleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mrzModuleView.cropAndTransformID = YES;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.mrzModuleView];
    [self.view sendSubviewToBack:self.mrzModuleView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.mrzModuleView}]];
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.mrzModuleView, @"topGuide" : topGuide}]];
    
    self.controllerType = ALScanHistoryMrz;
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
    [self.mrzModuleView cancelScanningAndReturnError:nil];
}

- (void)viewDidLayoutSubviews {
    [self updateWarningPosition:
     self.mrzModuleView.cutoutRect.origin.y +
     self.mrzModuleView.cutoutRect.size.height +
     self.mrzModuleView.frame.origin.y +
     90];
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
    BOOL success = [self.mrzModuleView startScanningAndReturnError:&error];
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
- (void)anylineMRZModuleView:(AnylineMRZModuleView *)anylineMRZModuleView
               didFindResult:(ALMRZResult *)scanResult {

    [self.mrzModuleView cancelScanningAndReturnError:nil];
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
    
    [super anylineDidFindResult:result barcodeResult:@"" image:scanResult.image module:anylineMRZModuleView completion:^{
       
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Name" value:scanResult.result.givenNames]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:scanResult.result.surNames]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Sex" value:scanResult.result.sex]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Date of Birth" value:[self formatDate:scanResult.result.dayOfBirthDateObject]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Type" value:scanResult.result.documentType]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:scanResult.result.documentNumber]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Expiration Date" value:[self formatDate:scanResult.result.expirationDateObject]]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:scanResult.result.nationalityCountryCode]];
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:scanResult.image optionalImageTitle:@"Detected Face Image" optionalImage:scanResult.result.faceImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (NSString *)formatDate:(NSDate *)date {
    if (!date) {
        return @"";
    }
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

@end
