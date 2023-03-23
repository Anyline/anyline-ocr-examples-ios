#import "ALMeterExampleManager.h"
#import "AnylineExamples-Swift.h"
#import "ALUniversalSerialNumberScanViewController.h"

@interface ALMeterExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALMeterExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Meter Reading";
    
    ALExample *analogDigitalMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Analog / Digital", nil)
                                                                      image:[UIImage imageNamed:@"analog digital"]
                                                             viewController:[ALMeterScanViewController class]
                                                                      title:@"Analog / Digital"];
    
    ALExample *dialMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Dial", nil)
                                                             image:[UIImage imageNamed:@"dial meter"]
                                                    viewController:[ALMeterScanViewController class]
                                                             title:@"Dial Meter"];
    
    ALExample *meterSerialNumberScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Meter Serial Number", nil)
                                                                image:[UIImage imageNamed:@"serial number"]
                                                       viewController:[ALUniversalSerialNumberScanViewController class]];

    // this is merely a parallel meter/barcode scanner, like with Analog/Digital, but using the now-defunct
    // ALSerialNumber meter scan mode.
    //    ALExample *serialScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Serial Number", nil)
    //                                                          image:[UIImage imageNamed:@"serial number"]
    //                                                 viewController:[ALMeterSerialNumberScanViewController class]
    //                                                          title:@"Serial Number"];
    
    self.sectionNames = @[ @"Meter Types" ]; // TODO: not showing on bundle

    self.examples = @{
        self.sectionNames[0] : @[
            analogDigitalMeterScanning,
            dialMeterScanning,
            meterSerialNumberScanning
        ]
    };
}

@end
