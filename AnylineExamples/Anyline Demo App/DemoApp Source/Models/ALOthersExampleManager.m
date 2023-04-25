#import "ALOthersExampleManager.h"
#import "ALUniversalSerialNumberScanViewController.h"
#import "ALContainerScanViewController.h"
#import "ALCompositeScanViewController.h"
#import "ALCustomOCRViewController.h"

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
    
    ALExample *containerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Shipping Container", nil)
                                                             image:[UIImage imageNamed:@"container serial numbers"]
                                                    viewController:[ALContainerScanViewController class]
                                                             title:NSLocalizedString(@"Shipping Container", nil)];
    
    ALExample *parallelFirstExample = [[ALExample alloc] initWithName:NSLocalizedString(@"VIN + Barcode Parallel Either-OR", nil)
                                                                image:[UIImage imageNamed:@"vin-barcode-parallel-either-or"]
                                                       viewController:[ALCompositeScanViewController class]
                                                                title:NSLocalizedString(@"VIN + Barcode Parallel Either-OR", nil)];

    ALExample *customCMDExample = [[ALExample alloc] initWithName:NSLocalizedString(@"Custom CMD", nil)
                                                            image:[UIImage imageNamed:@"custom-cmd"]
                                                   viewController:[ALCustomOCRViewController class]
                                                            title:NSLocalizedString(@"Custom CMD", nil)];


    self.sectionNames = @[ @"OCR", @"Composites" ];
    self.examples = @{
        self.sectionNames[0] : @[ containerScanning, customCMDExample ],
        self.sectionNames[1] : @[ parallelFirstExample ],
    };
}

@end
