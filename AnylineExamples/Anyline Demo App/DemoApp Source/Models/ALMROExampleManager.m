//
//  ALMROExampleManager.h
//  AnylineExamples
//
//  Created by Philipp Müller on 14/03/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALMROExampleManager.h"
#import "AnylineExamples-Swift.h"
#import "ALLicensePlateScanViewController.h"
#import "ALUniversalSerialNumberScanViewController.h"
#import "ALVINScanViewController.h"
#import "ALContainerScanViewController.h"
#import "ALVRCScanViewController.h"
#import "ALTINScanViewController.h"

NSString * const kVehicleRegistrationCertificate = @"Vehicle Registration Certificate DE";

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
    
    ALExample *tinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire DOT/TIN", nil)
                                                       image:[UIImage imageNamed:@"tin"]
                                              viewController:[ALTINScanViewController class] title:@"Tire DOT/TIN"];
    
    ALExample *tireSizeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Size", nil)
                                                            image:[UIImage imageNamed:@"tin"]
                                                   viewController:[ALTireSizeViewController class] title:@"Tire Size"];
    
    ALExample *commercialTireScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Commercial ID", nil)
                                                                  image:[UIImage imageNamed:@"tin"]
                                                         viewController:[ALCommercialTireIdViewController class] title:@"Tire Commercial ID"];
    
    ALExample *licensePlate = [[ALExample alloc] initWithName:NSLocalizedString(@"License Plate", nil)
                                                        image:[UIImage imageNamed:@"tile_licenseplate"]
                                               viewController:[ALLicensePlateScanViewController class]
                                                        title:@"License Plate"];
    
    ALExample *tireMakeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Make", nil)
                                                            image:[UIImage imageNamed:@"tile_tire_make"]
                                                   viewController:[ALTireMakeViewController class]
                                                            title:@"Tire Make"];
    
    ALExample *vehicleRegistrationCertificate = [[ALExample alloc] initWithName:NSLocalizedString(kVehicleRegistrationCertificate, nil)
                                                                          image:[UIImage imageNamed:@"vrc"]
                                                                 viewController:[ALVRCScanViewController class]
                                                                          title:kVehicleRegistrationCertificate];

    ALExample *odometer = [[ALExample alloc] initWithName:NSLocalizedString(@"Odometer", nil)
                                                                          image:[UIImage imageNamed:@"odometer"]
                                                                 viewController:[ALOdometerScanViewController class]
                                                                          title:@"odometer"];
    
    self.sectionNames = @[@"Vehicle",];
    self.examples = @{
        self.sectionNames[0] : @[
            licensePlate,
            vinScanning,
            tinScanning,
            tireSizeScanning,
            tireMakeScanning,
            commercialTireScanning,
            vehicleRegistrationCertificate,
            odometer
        ],
    };
}

@end
