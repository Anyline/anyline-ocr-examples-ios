//
//  ALExampleManager.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALProductExampleManager.h"

#import "ALAutoAnalogDigitalMeterScanViewController.h"
#import "ALDialMeterScanViewController.h"

#import "ALMultiformatBarcodeScanViewController.h"
#import "ALMRZScanViewController.h"
#import "ALIBANScanViewController.h"
#import "ALVoucherCodeScanViewController.h"
#import "ALISBNScanViewController.h"
#import "ALRecordNumberScanViewController.h"
#import "ALRBScanViewController.h"
#import "ALScrabbleScanViewController.h"
#import "ALDocumentScanViewController.h"

#import "ALLicensePlateViewController.h"

#import "ALOthersExampleManager.h"
#import "ALMeterExampleManager.h"
#import "ALMROExampleManager.h"
#import "ALIdentityDocumentsExampleManager.h"
#import "ALGridCollectionViewController.h"
#import "ALMeterCollectionViewController.h"
#import "ALLicensePlateExampleManager.h"

@interface ALProductExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALProductExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Solutions";
    
    ALExample *barcodeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Barcodes", nil)
                                                           image:[UIImage imageNamed:@"tile_barcodes"]
                                                  viewController:[ALMultiformatBarcodeScanViewController class]];
    
    ALExample *identityDocuments = [[ALExample alloc] initWithName:NSLocalizedString(@"Identity Documents", nil)
                                               image:[UIImage imageNamed:@"tile_identitydocuments"]
                                      viewController:[ALGridCollectionViewController class]
                                      exampleManager:[ALIdentityDocumentsExampleManager class]];
    
    ALExample *meterReading = [[ALExample alloc] initWithName:NSLocalizedString(@"Meter Reading", nil)
                                                        image:[UIImage imageNamed:@"tile_meterreading"]
                                               viewController:[ALMeterCollectionViewController class]
                                               exampleManager:[ALMeterExampleManager class]];
    
    ALExample *licensePlate = [[ALExample alloc] initWithName:NSLocalizedString(@"License Plate", nil)
                                                        image:[UIImage imageNamed:@"tile_licenseplate"]
                                               viewController:[ALGridCollectionViewController class]
                                               exampleManager:[ALLicensePlateExampleManager class]];
    
    ALExample *vehicle = [[ALExample alloc] initWithName:NSLocalizedString(@"Vehicle", nil)
                                                   image:[UIImage imageNamed:@"tile_vehicle_new"]
                                          viewController:[ALGridCollectionViewController class]
                                          exampleManager:[ALMROExampleManager class]];
    
    ALExample *others = [[ALExample alloc] initWithName:NSLocalizedString(@"Other", nil)
                                                  image:[UIImage imageNamed:@"tile_mro"]
                                         viewController:[ALGridCollectionViewController class]
                                         exampleManager:[ALOthersExampleManager class]];
    
    self.sectionNames = @[@"Solutions",];
    self.examples = @{
        self.sectionNames[0] : @[
            barcodeScanning,
            identityDocuments,
            meterReading,
            licensePlate,
            vehicle,
            others],
    };
}

@end
