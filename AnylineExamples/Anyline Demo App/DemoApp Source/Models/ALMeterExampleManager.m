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
    
    ALExample *analogDigitalMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Meter Reading", nil)
                                                                      image:[UIImage imageNamed:@"analog digital"]
                                                             viewController:[ALMeterScanViewController class]
                                                                      title:@"Meter Reading"];
    
    ALExample *meterSerialNumberScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Meter Serial Number", nil)
                                                                image:[UIImage imageNamed:@"serial number"]
                                                       viewController:[ALUniversalSerialNumberScanViewController class]];

    self.sectionNames = @[ @"Meter Types" ]; // TODO: not showing on bundle

    self.examples = @{
        self.sectionNames[0] : @[
            analogDigitalMeterScanning, meterSerialNumberScanning
        ]
    };
}

@end
