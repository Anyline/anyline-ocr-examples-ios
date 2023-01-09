//
//  ALMROExampleManager.h
//  AnylineExamples
//
//  Created by Philipp Müller on 14/03/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALMROExampleManager.h"
#import "AnylineExamples-Swift.h"
#import "ALUniversalSerialNumberScanViewController.h"
#import "ALVINScanViewController.h"
#import "ALContainerScanViewController.h"
#import "ALVRCScanViewController.h"

NSString * const kVehicleRegistrationCertificate = @"Vehicle Registration Certificate";

@interface ALMROExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;
@property (nonatomic, strong) NSArray *sectionNames;

@end


@implementation ALMROExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Vehicle";
    
    ALExample *vinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Vehicle Identification Number", nil)
                                                       image:[UIImage imageNamed:@"vin"]
                                              viewController:[ALVINScanViewController class]];
    
    ALExample *tinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Identification Number (DOT)", nil)
                                                       image:[UIImage imageNamed:@"tin"]
                                              viewController:[ALTireViewController class] title:@"Tire Identification Number (DOT)"];
    
    ALExample *tireSizeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Size Specifications", nil)
                                                            image:[UIImage imageNamed:@"tin"]
                                                   viewController:[ALTireSizeViewController class] title:@"Tire Size Specifications"];
    
    ALExample *commercialTireScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Commercial Tire Identification Number", nil)
                                                                  image:[UIImage imageNamed:@"tin"]
                                                         viewController:[ALCommercialTireIdViewController class] title:@"Commercial Tire Identification Number"];
    
    ALExample *vehicleRegistrationCertificate = [[ALExample alloc] initWithName:NSLocalizedString(kVehicleRegistrationCertificate, nil)
                                                                          image:[UIImage imageNamed:@"vrc"]
                                                                 viewController:[ALVRCScanViewController class]
                                                                          title:kVehicleRegistrationCertificate];
    
    self.sectionNames = @[@"Vehicle",];
    self.examples = @{
        self.sectionNames[0] : @[
            vinScanning,
            tinScanning,
            tireSizeScanning,
            commercialTireScanning,
            vehicleRegistrationCertificate
        ],
    };
}

@end
