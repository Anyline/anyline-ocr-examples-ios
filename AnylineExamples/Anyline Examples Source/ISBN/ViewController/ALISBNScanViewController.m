//
//  ALISBNScanViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 04/02/16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALISBNScanViewController.h"
#import <Anyline/Anyline.h>
#import "ALISBNViewController.h"
#import "ALAppDemoLicenses.h"

// This is the license key for the examples project used to set up Aynline below
NSString * const kISBNLicenseKey = kDemoAppLicenseKey;
// The controller has to conform to <AnylineOCRModuleDelegate> to be able to receive results
@interface ALISBNScanViewController ()<AnylineOCRModuleDelegate, AnylineDebugDelegate>
// The Anyline module used for OCR
@property (nonatomic, strong) AnylineOCRModuleView *ocrModuleView;

@end

@implementation ALISBNScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"ISBN";
    
    // Initializing the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.ocrModuleView = [[AnylineOCRModuleView alloc] initWithFrame:frame];
    
    ALOCRConfig *config = [[ALOCRConfig alloc] init];
    config.tesseractLanguages = @[@"eng_no_dict", @"deu"];
    config.charWhiteList = charWhiteListForISBN;
    config.validationRegex = regexForISBN;
    config.scanMode = ALAuto;
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.ocrModuleView setupWithLicenseKey:kISBNLicenseKey
                                                  delegate:self
                                                 ocrConfig:config
                                                     error:&error];
    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if (!success) {
        // Something went wrong. The error object contains the error description
        NSAssert(success, @"Setup Error: %@", error.debugDescription);
    }
    
    NSString *confPath = [[NSBundle mainBundle] pathForResource:@"isbn_config" ofType:@"json"];
    ALUIConfiguration *ibanConf = [ALUIConfiguration cutoutConfigurationFromJsonFile:confPath];
    self.ocrModuleView.currentConfiguration = ibanConf;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.ocrModuleView];
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
    ALISBNViewController *vc = [[ALISBNViewController alloc] init];
    NSString *isbn = (NSString *)result.result;
    isbn = [isbn stringByReplacingOccurrencesOfString:@"-" withString:@""];
    isbn = [isbn stringByReplacingOccurrencesOfString:@" " withString:@""];
    isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN10" withString:@""];
    isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN13" withString:@""];
    isbn = [isbn stringByReplacingOccurrencesOfString:@"ISBN" withString:@""];
    isbn = [isbn stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    [vc setIsbnString:isbn];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView
      reportDebugVariable:(NSString *)variableName
                    value:(id)value {
    
}


-(void) anylineModuleView:(AnylineAbstractModuleView *)anylineModuleView runSkipped:(ALRunFailure)runFailure {
    switch (runFailure) {
        case ALRunFailureResultNotValid:
            break;
        case ALRunFailureSharpnessNotReached:
            break;
        case ALRunFailureNoLinesFound:
            break;
        case ALRunFailureNoTextFound:
            break;
        case ALRunFailureUnkown:
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSError *error = nil;
    BOOL success = [self.ocrModuleView startScanningAndReturnError:&error];
    
    NSAssert(success, @"We failed starting: %@",error.debugDescription);
}

@end
