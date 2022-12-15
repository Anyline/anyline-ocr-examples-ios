#import "ALLicensePlateExampleManager.h"
#import "ALLicensePlateScanViewController.h"

@interface ALLicensePlateExampleManager ()

@property (nonatomic, strong) NSMutableDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end


@implementation ALLicensePlateExampleManager

- (instancetype)init {
    if (self = [super init]) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"License Plate";
    
    ALExample *licensePlateEU = [[ALExample alloc] initWithName:NSLocalizedString(@"EU License Plate", nil)
                                                          image:[UIImage imageNamed:@"tile_licenseplate_eu"]
                                                 viewController:[ALLicensePlateScanViewController class]
                                                          title:@"EU License Plate"];
    ALExample *licensePlateUS = [[ALExample alloc] initWithName:NSLocalizedString(@"US License Plate", nil)
                                                          image:[UIImage imageNamed:@"tile_licenseplate_us"]
                                                 viewController:[ALLicensePlateScanViewController class]
                                                          title:@"US License Plate"];
    ALExample *licensePlateAF = [[ALExample alloc] initWithName:NSLocalizedString(@"African License Plate", nil)
                                                          image:[UIImage imageNamed:@"tile_licenseplate_af"]
                                                 viewController:[ALLicensePlateScanViewController class]
                                                          title:@"African License Plate"];
    self.sectionNames = @[@"License Plate"];
    self.examples = [@{
        self.sectionNames[0] : @[ licensePlateEU, licensePlateUS, licensePlateAF ],
    } mutableCopy];
    
}

@end
