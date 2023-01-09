#import "ALOthersExampleManager.h"
#import "ALUniversalSerialNumberScanViewController.h"
#import "ALContainerScanViewController.h"
#import "ALBottlecapScanViewController.h"


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
    //OCR
    
    ALExample *containerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Horizontal Shipping Container", nil)
                                                             image:[UIImage imageNamed:@"container serial numbers"]
                                                    viewController:[ALContainerScanViewController class]
                                                             title:NSLocalizedString(@"Horizontal Shipping Container", nil)];
    
    ALExample *verticalContainerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Vertical Shipping Container", nil)
                                                                     image:[UIImage imageNamed:@"vertical container scanner"]
                                                            viewController:[ALContainerScanViewController class]
                                                                     title:NSLocalizedString(@"Vertical Shipping Container", nil)];
    
    ALExample *bottleCapScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Pepsi Code", nil)
                                                             image:[UIImage imageNamed:@"tile_pepsicode"]
                                                    viewController:[ALBottlecapScanViewController class]];
    
    
    self.sectionNames = @[@"Others",];
    self.examples = @{
        self.sectionNames[0] : @[containerScanning, verticalContainerScanning, bottleCapScanning],
    };
}

@end
