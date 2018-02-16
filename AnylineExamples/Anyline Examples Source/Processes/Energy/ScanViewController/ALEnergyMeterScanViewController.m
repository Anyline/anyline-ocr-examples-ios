//
//  ALEnergyMeterScanViewController.m
//  AnylineExamples
//
//  Created by Philipp Mueller on 10/01/18
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALEnergyMeterScanViewController.h"
#import "ALMeterScanResultViewController.h"
#import <Anyline/Anyline.h>
#import "ALAppDemoLicenses.h"
#import "ALUtils.h"
#import "NSString+Util.h"

#import "CustomerDataView.h"

#import "ALMeterReading.h"
#import "CustomerDataView.h"
#import "Reading.h"
#import "CustomerSelfReadingResultViewController.h"
#import "WorkforceToolResultViewController.h"


// This is the license key for the examples project used to set up Aynline below
NSString * const kALEnergyMeterScanLicenseKey = kDemoAppLicenseKey;

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALEnergyMeterScanViewController ()<AnylineEnergyModuleDelegate, CustomerSelfReadingResultDelegate, WorkforceToolResultDelegate>

// The Anyline module used to scan
@property (nonatomic, strong) AnylineEnergyModuleView *anylineEnergyView;

@property (nonatomic, strong) NSString *barcodeResult;
@property (nonatomic, strong) UIView *customerDataContainer;
@property (strong, nonatomic) NSLayoutConstraint *customerDataContainerViewHeightConstraint;


@end

@implementation ALEnergyMeterScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Barcode";
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.anylineEnergyView = [[AnylineEnergyModuleView alloc] initWithFrame:frame];
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // once we start receiving results.
    BOOL success = [self.anylineEnergyView setupWithLicenseKey:kALEnergyMeterScanLicenseKey delegate:self error:&error];
    
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
    
    self.anylineEnergyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Set ScanMode to ALBarcode
    success = [self.anylineEnergyView setScanMode:ALBarcode error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    BOOL enableReporting = [NSUserDefaults AL_reportingEnabled];
    [self.anylineEnergyView enableReporting:enableReporting];
    self.anylineEnergyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.anylineEnergyView];
    [self.view sendSubviewToBack:self.anylineEnergyView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.anylineEnergyView}]];
    
    self.controllerType = ALScanHistoryElectricMeter;
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.anylineEnergyView, @"topGuide" : topGuide}]];
    
    //Init customer data container view
    [self setupCustomerDataContainer];

    if (self.customer) {
        [self _addCustomerDataView];
    }
    
    self.barcodeResult = @"";
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnyline];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.anylineEnergyView cancelScanningAndReturnError:nil];
}

#pragma mark - Customer Methods

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    
    [self _addCustomerDataView];
}

- (void)_addCustomerDataView {
    if (self.isViewLoaded) {
        // clear all the existing subviews we had in there
        for (UIView *v in self.customerDataContainer.subviews) {
            [v removeFromSuperview];
        }
        
        if (self.customer) {
            self.customerDataContainer.hidden = NO;
            
            CustomerDataView *customerView = TranslateAutoresizing(v(@"CustomerDataView"));
            customerView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueSmall | CustomerDataFacetReadingDate;
            customerView.customer = self.customer;
            [self.customerDataContainer addSubview:customerView];
            [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[customerView]-(4)-|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full width
            [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(4)-[customerView]-(4)-|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full height
        } else {
            self.customerDataContainer.hidden = YES;
        }
    }
}
#pragma mark - UI Setup Methods
- (void)setupCustomerDataContainer {
    //Init customerDatacontainer view
    self.customerDataContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 359, 195)];
    self.customerDataContainer.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:0.65];
    
    self.customerDataContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerDataContainer.hidden = YES;
    
    [self.view addSubview:self.customerDataContainer];
    
    //Trailing
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                   constraintWithItem:self.customerDataContainer
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:-5.f];
    
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self.customerDataContainer
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:5.f];
    
    //Bottom
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:self.customerDataContainer
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:-5.f];
    
    [self.view addConstraint:trailing];
    [self.view addConstraint:bottom];
    [self.view addConstraint:leading];
    
    //Height to be fixed for self.customerDataContainer
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:self.customerDataContainer
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:0
                                  constant:250];
    
    [self.customerDataContainer addConstraint:height];
}
#pragma mark - AnylineControllerDelegate methods
/*
 The main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineEnergyModuleView:(AnylineEnergyModuleView *)anylineEnergyModuleView 
                  didFindResult:(ALEnergyResult *)scanResult {
    if (scanResult.scanMode == ALBarcode) {
        [self evaluateMeterId:scanResult];
        if (self.customer) {
            self.barcodeResult = scanResult.result;
            [self restartAnylineWithScanMode:ALAutoAnalogDigitalMeter];
            self.title = @"Analog/Digital Meter";
        } else {
            [self startAnyline];
        }

    } else {
        [self anylineDidFindResult:scanResult.result barcodeResult:self.barcodeResult image:(UIImage*)scanResult.image module:anylineEnergyModuleView completion:^{
            [self displayReading:scanResult];
        }];
    }
   
}

#pragma mark - Anyline utility methods

- (void)startAnyline {
    /*
     This is the place where we tell Anyline to start receiving and displaying images from the camera.
     Success/error tells us if everything went fine.
     */
    if (!self.anylineEnergyView.isRunning) {
        NSError *error = nil;
        BOOL success = [self.anylineEnergyView startScanningAndReturnError:&error];
        if( !success ) {
            // Something went wrong. The error object contains the error description
            [[[UIAlertView alloc] initWithTitle:@"Start Scanning Error"
                                        message:error.debugDescription
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}

- (void)restartAnylineWithScanMode:(ALScanMode)scanMode {
    NSError *error;
    BOOL success;
    
    //Stop running anyline module
    success = [self.anylineEnergyView cancelScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Cancel Anyline Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

    //Set ScanMode of Anyline
    success = [self.anylineEnergyView setScanMode:scanMode error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Set ScanMode Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    //Start the anyline module again
    [self startAnyline];
}

#pragma mark - Customer<->reading Utility Methods

- (void)evaluateMeterId:(ALScanResult *)scanResult {
    if (self.order) {
        self.customer = [self.order customerWithMeterID:[scanResult.result stringByCleaningWhitespace]];
    } else if (self.csr) {
        self.customer = [self.csr customerWithMeterID:[scanResult.result stringByCleaningWhitespace]];
    }
    
    if (!self.customer) {
        [[[UIAlertView alloc] initWithTitle:@"Customer not found"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)displayReading:(ALScanResult *)scanResult {
    if (self.customer) {
        ALScannerType scannerType = [ALMeterReading scannerTypeForMeterTypeString:self.customer.meterType];
        
        NSError *error;
        Reading *reading = [Reading insertNewObjectWithReadingValue:scanResult.result
                                                               sort:@(self.customer.readings.count)
                                                       scannedImage:scanResult.fullImage
                                                        readingDate:[NSDate date]
                                                           customer:self.customer
                                             inManagedObjectContext:self.customer.managedObjectContext
                                                              error:&error];
        if (error) {
            NSLog(@"Persitence Error: %@", [error localizedDescription]);
        }
        
        [self.customer addReadingsObject:reading];
        
        ALMeterReading *mr = [ALMeterReading meterReadingWithType:scannerType
                                                            image:scanResult.image
                                                        fullImage:scanResult.fullImage
                                                           result:scanResult.result];
        
        if(self.order) {
            WorkforceToolResultViewController *resultVC = [[WorkforceToolResultViewController alloc]initWithReading:reading andMeterReading:mr];
            resultVC.delegate = self;
            [self.navigationController pushViewController:resultVC animated:YES];

        } else if (self.csr) {
            CustomerSelfReadingResultViewController *resultVC = [[CustomerSelfReadingResultViewController alloc]initWithReading:reading andMeterReading:mr];
            resultVC.delegate = self;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    }
}

/*
 * If isReset is set this method will either:
 *  - True:     reset the anylineView to the scanMode ALBarCode and reset the customer data.
 *  - False:    start the anylineView in the last scanMode and the customer data will stay the same.
 */
- (void)startWithReset:(BOOL)isReset {
    if (isReset) {
        //reset customer and customerDataContainer
        self.customer = nil;
        [self _addCustomerDataView];
        //reset found barcode
        self.barcodeResult = @"";
        [self restartAnylineWithScanMode:ALBarcode];
        self.title = @"Barcode";
    } else {
        [self startAnyline];
    }
}
    
#pragma mark - CustomerSelfReadingResultDelegate methods

- (void)backFromResultView:(CustomerSelfReadingResultViewController *)customerSelfReadingResultView isReset:(BOOL)isReset {
    [self startWithReset:isReset];
}
- (void)backFromWorkforceResultView:(WorkforceToolResultViewController *)workforceToolResultViewController isReset:(BOOL)isReset {
    [self startWithReset:isReset];
}
@end
