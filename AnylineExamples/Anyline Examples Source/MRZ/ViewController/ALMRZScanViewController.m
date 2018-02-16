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

// This is the license key for the examples project used to set up Aynline below
NSString * const kMRZLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineMRZModuleDelegate> to be able to receive results
@interface ALMRZScanViewController ()<AnylineMRZModuleDelegate>
// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) AnylineMRZModuleView *mrzModuleView;
// A view to present the scanned results
@property (nonatomic, strong) ALIdentificationView *identificationView;

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
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.mrzModuleView setupWithLicenseKey:kMRZLicenseKey delegate:self error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Setup Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    self.mrzModuleView.flashButtonAlignment = ALFlashAlignmentTopLeft;
    
    self.mrzModuleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.mrzModuleView];
    [self.view sendSubviewToBack:self.mrzModuleView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.mrzModuleView}]];
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.mrzModuleView, @"topGuide" : topGuide}]];
    
    /*
     ALIdentificationView will present the scanned values. Here we start listening for taps
     to later dismiss the view.
     */
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapIdentificationView:)];
    
    self.identificationView = [[ALIdentificationView alloc] initWithFrame:CGRectMake(0, 0, 300, 300/1.4)];
    
    [self.identificationView addGestureRecognizer:gr];
    self.identificationView.center = self.view.center;
    [self.view insertSubview:self.identificationView belowSubview:self.mrzModuleView];
    
    self.controllerType = ALScanHistoryMrz;
    
    self.identificationView.alpha = 0;
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // The view to present the results should be hidden by default
    self.identificationView.alpha = 0;
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
 A little animation for the user to see the scanned document.
 */
-(void)animateScanDidComplete {
    [self.mrzModuleView cancelScanningAndReturnError:nil];
    [self.view bringSubviewToFront:self.identificationView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.identificationView.center = self.view.center;
        self.identificationView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.identificationView.alpha = 1.0;
            self.identificationView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
            self.identificationView.transform = CGAffineTransformMakeScale(0.87, 0.87);
            self.identificationView.center = self.view.center;
        } completion:^(BOOL finished) {
        }];
    });
}


/*
 Dismiss the view if the user taps the screen
 */
-(void)didTapIdentificationView:(id) sender {
    if(self.identificationView.alpha == 1.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.4 animations:^{
                self.identificationView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                self.identificationView.alpha = 0;
            } completion:^(BOOL finished) {
                // We start scanning again once the animation completed
                [self startAnyline];
            }];
        });
    }
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
//- (void)anylineMRZModuleView:(AnylineMRZModuleView *)anylineMRZModuleView
//           didFindScanResult:(ALIdentification *)scanResult
//         allCheckDigitsValid:(BOOL)allCheckDigitsValid
//                     atImage:(UIImage *)image {
- (void)anylineMRZModuleView:(AnylineMRZModuleView *)anylineMRZModuleView
               didFindResult:(ALMRZResult *)scanResult {

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
        // Because there is a lot of information to be passed along the module
        // uses ALIdentification.
        [self.identificationView updateIdentification:scanResult.result];
        // Because cancelOnResult: is YES by default scanning has stopped.
        // Present the information to the user
        [self animateScanDidComplete];
    }];
}

@end
