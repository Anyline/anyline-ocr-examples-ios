#import "ALEnergyMeterScanViewController.h"
#import <Anyline/Anyline.h>
#import "CustomerSelfReadingResultViewController.h"
#import "WorkforceToolResultViewController.h"
#import "CustomerDataView.h"
#import "ALMeterReading.h"
#import "Reading.h"
#import "ALUtils.h"
#import "ALPluginResultHelper.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "NSString+Util.h"

@interface ALEnergyMeterScanViewController () <ALScanPluginDelegate, ALScanViewPluginDelegate, ALViewPluginCompositeDelegate, CustomerSelfReadingResultDelegate, WorkforceToolResultDelegate>

//@property (nonatomic, strong, nullable) ALScanView *scanView;
@property (nonatomic, strong, nullable) ALViewPluginComposite *viewPluginComposite;
@property (nonatomic, strong, nullable) NSString *barcodeResult;
@property (nonatomic, strong) UIView *customerDataContainer;

@property (strong, nonatomic) NSLayoutConstraint *customerDataContainerViewHeightConstraint;

@end


@implementation ALEnergyMeterScanViewController

- (void)viewDidLoad {
    
    self.title = @"Barcode";

    NSString *configJSONStr = [self configJSONStrWithFilename:@"serial_meter_barcode_config"];
    NSDictionary *JSONDict = [configJSONStr asJSONObject];

    id obj = [ALScanViewPluginFactory withJSONDictionary:JSONDict error:nil];
    NSAssert([obj isKindOfClass:ALViewPluginComposite.class], @"should be a plugin composite!");

    ALScanViewConfig *scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:JSONDict error:nil];

    self.viewPluginComposite = (ALViewPluginComposite *)obj;
    self.viewPluginComposite.delegate = self;

    for (id<ALScanViewPluginBase> child in self.viewPluginComposite.children) {
        if ([child isKindOfClass:ALScanViewPlugin.class]) {
            ((ALScanViewPlugin *)child).scanPlugin.delegate = self;
            ((ALScanViewPlugin *)child).delegate = self;
        }
    }

    NSError *error;
    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.viewPluginComposite
                                       scanViewConfig:scanViewConfig
                                                error:&error];

    if ([self popWithAlertOnError:error]) {
        return;
    }
    
    self.scanView.translatesAutoresizingMaskIntoConstraints = NO;

    [self installScanView:self.scanView];
    [self.scanView startCamera];

    //    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView}]];
    //    id topGuide = self.topLayoutGuide;
    //    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[scanView]|" options:0 metrics:nil views:@{@"scanView" : self.scanView, @"topGuide" : topGuide}]];

    self.controllerType = ALScanHistoryElectricMeter;
    
    // Init customer data container view
    [self setupCustomerDataContainer];

    if (self.customer) {
        [self _addCustomerDataView];
    }
    
    self.barcodeResult = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewPluginComposite startWithError:nil];
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
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:self.customerDataContainer
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:-5.f];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self.customerDataContainer
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:5.f];

    NSLayoutConstraint *bottom = [NSLayoutConstraint
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

// MARK: - ALScanPluginDelegate, ALViewPluginCompositeDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    // from the config at serial_meter_barcode_config.json, the ids are
    // "meter" and "barcode" with meter coming in first
    if ([scanPlugin.pluginID isEqualToString:@"meter"]) {
        NSString *meterReading = scanResult.pluginResult.meterResult.value;
        __weak __block typeof(self) weakSelf = self;
        [self anylineDidFindResult:meterReading
                     barcodeResult:nil
                             image:scanResult.croppedImage
                        scanPlugin:scanPlugin
                        viewPlugin:self.viewPluginComposite completion:^{
            [weakSelf displayReading:scanResult];
        }];
    } else if ([scanPlugin.pluginID isEqualToString:@"barcode"]) {
        NSString *barcodeReading = scanResult.pluginResult.barcodeResult.barcodes.firstObject.decoded;
        [self evaluateMeterId:barcodeReading];

        if (self.customer) {
            self.barcodeResult = barcodeReading;
            // if we have a 'Customer Not Found' message showing because we read a bad barcode previously and
            // they haven't dismissed the message yet, dismiss it, since we have now found a customer.
            if ([self.presentedViewController isKindOfClass:UIAlertController.class]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }

            // TODO: work around this unsupported functionality (maybe just restart the whole plugin)
            // [self.viewPluginComposite startFromID:kMeterScanPluginID andReturnError:nil];

            self.title = @"Analog/Digital Meter";

        } else {
            // we don't want the composite to be running when we return from this method, or it may do
            // something with the barcode result when it gets this delegate message
            [self.viewPluginComposite performSelector:@selector(startAndReturnError:) withObject:nil afterDelay:0.0];
            self.barcodeResult = @"";
            self.customer = nil;
        }

    }
}

- (void)viewPluginComposite:(ALViewPluginComposite *)viewPluginComposite allResultsReceived:(NSArray<ALScanResult *> *)scanResults {
    // this is here if you plan on getting notified if both meter and barcode scan results.
}

// MARK: - Customer<->Reading Utility Methods

- (void)evaluateMeterId:(NSString *)barcode {
    if (self.order) {
        self.customer = [self.order customerWithMeterID:[barcode stringByCleaningWhitespace]];
    } else if (self.csr) {
        self.customer = [self.csr customerWithMeterID:[barcode stringByCleaningWhitespace]];
    }

    if (!self.customer) {
        [self showAlertWithTitle:@"Customer not found"
                         message:@"Make sure you are scanning a meter reading customer from the Anyline Examples sheet."
                      completion:nil];
    }
}

- (void)displayReading:(ALScanResult *)scanResult {

    if (!self.customer) {
        return;
    }

    NSString *meterReading = scanResult.pluginResult.meterResult.value;

    ALScannerType scannerType = [ALMeterReading scannerTypeForMeterTypeString:self.customer.meterType];

    NSError *error;
    Reading *reading = [Reading insertNewObjectWithReadingValue:meterReading
                                                           sort:@(self.customer.readings.count)
                                                   scannedImage:scanResult.fullSizeImage
                                                    readingDate:[NSDate date]
                                                       customer:self.customer
                                         inManagedObjectContext:self.customer.managedObjectContext
                                                          error:&error];
    if (error) {
        NSLog(@"Persistence Error: %@", error.localizedDescription);
    }

    [self.customer addReadingsObject:reading];

    ALMeterReading *mr = [ALMeterReading meterReadingWithType:scannerType
                                                        image:scanResult.croppedImage
                                                    fullImage:scanResult.fullSizeImage
                                                       result:meterReading];

    if (self.order) {
        WorkforceToolResultViewController *resultVC = [[WorkforceToolResultViewController alloc]initWithReading:reading andMeterReading:mr];
        resultVC.delegate = self;
        [self.navigationController pushViewController:resultVC animated:YES];

    } else if (self.csr) {
        CustomerSelfReadingResultViewController *resultVC = [[CustomerSelfReadingResultViewController alloc]initWithReading:reading andMeterReading:mr];
        resultVC.delegate = self;
        [self.navigationController pushViewController:resultVC animated:YES];
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
        [self.viewPluginComposite startWithError:nil];
        self.title = @"Barcode";
    } else {
        [self.viewPluginComposite startWithError:nil];
    }
}

// MARK: - CustomerSelfReadingResultDelegate methods

- (void)backFromResultView:(CustomerSelfReadingResultViewController *)customerSelfReadingResultView isReset:(BOOL)isReset {
    [self startWithReset:isReset];
}

- (void)backFromWorkforceResultView:(WorkforceToolResultViewController *)workforceToolResultViewController isReset:(BOOL)isReset {
    [self startWithReset:isReset];
}

@end
