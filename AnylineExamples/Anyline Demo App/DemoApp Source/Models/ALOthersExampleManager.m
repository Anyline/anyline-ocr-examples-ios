#import "ALOthersExampleManager.h"
#import "ALUniversalSerialNumberScanViewController.h"
#import "ALContainerScanViewController.h"
#import "ALCompositeScanViewController.h"

@interface ALOthersExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALOthersExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Others";

    ALExample *containerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Horizontal Shipping Container", nil)
                                                             image:[UIImage imageNamed:@"container serial numbers"]
                                                    viewController:[ALContainerScanViewController class]
                                                             title:NSLocalizedString(@"Horizontal Shipping Container", nil)];
    
    ALExample *verticalContainerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Vertical Shipping Container", nil)
                                                                     image:[UIImage imageNamed:@"vertical container scanner"]
                                                            viewController:[ALContainerScanViewController class]
                                                                     title:NSLocalizedString(@"Vertical Shipping Container", nil)];

    ALExample *parallelFirstExample = [[ALExample alloc] initWithName:NSLocalizedString(@"VIN + Barcode Parallel Either-OR", nil)
                                                                     image:[UIImage imageNamed:@"vin-barcode-parallel-either-or"]
                                                            viewController:[ALCompositeScanViewController class]
                                                                     title:NSLocalizedString(@"VIN + Barcode Parallel Either-OR", nil)];

    self.sectionNames = @[ @"OCR", @"Composites" ];
    self.examples = @{
        self.sectionNames[0] : @[ containerScanning, verticalContainerScanning ],
        self.sectionNames[1] : @[ parallelFirstExample ],
    };
}

@end
