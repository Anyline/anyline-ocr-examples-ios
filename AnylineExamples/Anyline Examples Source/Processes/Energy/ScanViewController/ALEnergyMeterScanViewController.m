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


// This is the license key for the examples project used to set up Anyline below
NSString * const kALEnergyMeterScanLicenseKey = kDemoAppLicenseKey;
NSString * const kMeterScanPluginID = @"METER_READING";

// The controller has to conform to <AnylineEnergyModuleDelegate> to be able to receive results
@interface ALEnergyMeterScanViewController ()<ALMeterScanPluginDelegate, ALBarcodeScanPluginDelegate, CustomerSelfReadingResultDelegate, WorkforceToolResultDelegate, ALCompositeScanPluginDelegate>

// The Anyline plugin used to scan
@property (nonatomic, strong) ALSerialScanViewPluginComposite *serialComposite;
@property (nonatomic, strong) ALMeterScanViewPlugin *meterScanViewPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) NSString *barcodeResult;
@property (nonatomic, strong) UIView *customerDataContainer;
@property (strong, nonatomic) NSLayoutConstraint *customerDataContainerViewHeightConstraint;

@property (nonatomic, assign, readonly) ALScanMode scanMode;

@end

@implementation ALEnergyMeterScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"Barcode";
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(frame.origin.x, frame.origin.y + self.navigationController.navigationBar.frame.size.height, frame.size.width, frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    
    /*
     *  Create Meter Scanning components
     */
    //Add Meter Scan Plugin (Scan Process)
    NSError *error = nil;
    
    
    ALMeterScanPlugin *meterScanPlugin = [[ALMeterScanPlugin alloc] initWithPluginID:kMeterScanPluginID
                                                            licenseKey:kDemoAppLicenseKey
                                                              delegate:self
                                                                 error:&error];
    NSAssert(meterScanPlugin, @"Setup Error: %@", error.debugDescription);
    BOOL success = [meterScanPlugin setScanMode:ALAutoAnalogDigitalMeter error:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [self showAlertWithTitle:@"Set ScanMode Error" message:error.debugDescription];
    }
    //Add Meter Scan View Plugin (Scan UI)
    ALMeterScanViewPlugin *meterScanViewPlugin = [[ALMeterScanViewPlugin alloc] initWithScanPlugin:meterScanPlugin];
    //We use this as a property, to use it for the example scan history
    self.meterScanViewPlugin = meterScanViewPlugin;
    
    /*
     *  Create Barcode Scanning components
     */
    ALBarcodeScanPlugin *barcodeScanPlugin = [[ALBarcodeScanPlugin alloc] initWithPluginID:@"BARCODE"
                                                                licenseKey:kDemoAppLicenseKey
                                                                  delegate:self error:&error];
    barcodeScanPlugin.barcodeFormatOptions = ALCodeTypeAll;
    NSAssert(barcodeScanPlugin, @"Setup Error: %@", error.debugDescription);
    
    ALBarcodeScanViewPlugin *barcodeScanViewPlugiun = [[ALBarcodeScanViewPlugin alloc] initWithScanPlugin:barcodeScanPlugin];
    
    
    /*
     *  Combine Barcode and Meter Scanning in a SerialComposite
     */
    self.serialComposite = [[ALSerialScanViewPluginComposite alloc] initWithPluginID:@""];
    [self.serialComposite addDelegate:self];
    [self.serialComposite addPlugin:barcodeScanViewPlugiun];
    [self.serialComposite addPlugin:meterScanViewPlugin];
    
    //Add ScanView (Camera and Flashbutton)
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.serialComposite];
    
    [self.view addSubview:self.scanView];
    [self.scanView startCamera];
    
    
    
    self.scanView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // After setup is complete we add the scanView to the view of this view controller
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];

    self.controllerType = ALScanHistoryElectricMeter;
    
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
    [self.serialComposite stopAndReturnError:nil];
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

#pragma mark - Anyline Result Delegates
- (void)anylineMeterScanPlugin:(ALMeterScanPlugin *)anylineMeterScanPlugin didFindResult:(ALMeterResult *)scanResult {
    [self anylineDidFindResult:scanResult.result barcodeResult:self.barcodeResult image:(UIImage*)scanResult.image scanPlugin:anylineMeterScanPlugin viewPlugin:self.meterScanViewPlugin completion:^{
        [self displayReading:scanResult];
    }];
}

- (void)anylineBarcodeScanPlugin:(ALBarcodeScanPlugin *)anylineBarcodeScanPlugin didFindResult:(ALBarcodeResult *)scanResult {
    BOOL stopped = [self.serialComposite stopAndReturnError:nil];
    
    [self evaluateMeterId:scanResult];
    if (self.customer) {
        self.barcodeResult = scanResult.result;
        //if we have a 'Customer Not Found' message showing because we read a bad barcode previously and they haven't dismissed the message yet, dismiss it, since we have now found a customer.
        if ([self.presentedViewController isKindOfClass:UIAlertController.class]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [self.serialComposite startFromID:kMeterScanPluginID andReturnError:nil];
        self.title = @"Analog/Digital Meter";
    } else {
        //we don't want the composite to be running when we return from this method, or it may do something with the barcode result when it gets this delegate message
        [self.serialComposite performSelector:@selector(startAndReturnError:) withObject:nil afterDelay:0.0];
        self.barcodeResult = @"";
        self.customer = nil;
    }
    
}

- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite *)anylineCompositeScanPlugin
                     didFindResult:(ALCompositeResult *)scanResult {
    //If you only need the final result, you can use this method
    // ALCompositeResult *scanResult will contain one result per added scanViewPlugin. 
}

#pragma mark - Anyline Utility Methods

- (void)startAnyline {
    /*
     This is the place where we tell Anyline to start receiving and displaying images from the camera.
     Success/error tells us if everything went fine.
     */
    if (![self.serialComposite isRunning]) {
        [self startPlugin:self.serialComposite];
    }
}

#pragma mark - Customer<->reading Utility Methods

- (void)evaluateMeterId:(ALScanResult *)scanResult {
    if (self.order) {
        self.customer = [self.order customerWithMeterID:[scanResult.result stringByCleaningWhitespace]];
    } else if (self.csr) {
        self.customer = [self.csr customerWithMeterID:[scanResult.result stringByCleaningWhitespace]];
    }
    
    if (!self.customer) {
        [self showAlertWithTitle:@"Customer not found" message:@"Make sure you are scanning a meter reading customer from the Anyline Examples sheet."];
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
 *  - True:     reset the anylineView to the scanMode ALBarcode and reset the customer data.
 *  - False:    start the anylineView in the last scanMode and the customer data will stay the same.
 */
- (void)startWithReset:(BOOL)isReset {
    if (isReset) {
        //reset customer and customerDataContainer
        self.customer = nil;
        [self _addCustomerDataView];
        //reset found barcode
        self.barcodeResult = @"";
        [self.serialComposite startAndReturnError:nil];
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
