//
//  ALExampleManager.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALExampleManager.h"

#import "ALGasMeterScanViewController.h"
#import "ALHeatMeterScanViewController.h"
#import "ALElectricMeterScanViewController.h"
#import "ALDigitalMeterScanViewController.h"
#import "ALWaterMeterScanViewController.h"

#import "ALMultiformatBarcodeScanViewController.h"
#import "ALMRZScanViewController.h"
#import "ALIBANScanViewController.h"
#import "ALVoucherCodeScanViewController.h"
#import "ALISBNScanViewController.h"
#import "ALRecordNumberScanViewController.h"
#import "ALRBScanViewController.h"
#import "ALBottlecapScanViewController.h"
#import "ALScrabbleScanViewController.h"
#import "ALDocumentScanViewController.h"
#import "ALLicensePlateViewController.h"
#import "ALLicensePlateDEViewController.h"
#import "ALLicensePlateATViewController.h"
#import "ALVINScanViewController.h"

@interface ALExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    
    ALExample *electricScanning = [[ALExample alloc] initWithName:@"Electric Meter Scanning"
                                                   viewController:[ALElectricMeterScanViewController class]];
    
    ALExample *gasScanning = [[ALExample alloc] initWithName:@"Gas Meter Scanning"
                                                viewController:[ALGasMeterScanViewController class]];
    
    ALExample *heatScanning = [[ALExample alloc] initWithName:@"Heat Meter Scanning"
                                               viewController:[ALHeatMeterScanViewController class]];
    
    ALExample *digitalScanning = [[ALExample alloc] initWithName:@"Digital Meter Scanning"
                                                  viewController:[ALDigitalMeterScanViewController class]];
    
    ALExample *waterScanning = [[ALExample alloc] initWithName:@"Water Meter Scanning"
                                                viewController:[ALWaterMeterScanViewController class]];
    
    
    ALExample *idScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"PASS / ID MRZ Scan", nil)
                                             viewController:[ALMRZScanViewController class]];
    
    
    ALExample *barcodeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Barcode Scan", nil)
                                                  viewController:[ALMultiformatBarcodeScanViewController class]];
    
    ALExample *ibanScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"IBAN Scanner", nil)
                                               viewController:[ALIBANScanViewController class]];
    
    ALExample *documentScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Document Scanner", nil)
                                                    viewController:[ALDocumentScanViewController class]];
    
    ALExample *voucherCodeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Voucher Code Scanner", nil)
                                                      viewController:[ALVoucherCodeScanViewController class]];
    
    ALExample *rbScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"RedBull Mobile Collect Scanner", nil)
                                             viewController:[ALRBScanViewController class]];
    
    ALExample *stieglScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Bottlecap Code Scanner", nil)
                                                 viewController:[ALBottlecapScanViewController class]];
    
    
    ALExample *scrabbleScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Scrabble Anagram Scanner", nil)
                                                   viewController:[ALScrabbleScanViewController class]];
    
    ALExample *isbnScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"ISBN Scanner", nil)
                                               viewController:[ALISBNScanViewController class]];
    
    ALExample *recordScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Record Number Code Scanner", nil)
                                                 viewController:[ALRecordNumberScanViewController class]];
    
    ALExample *licensePlateScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"License Plate Scanner", nil)
                                                       viewController:[ALLicensePlateViewController class]];
    
    ALExample *licensePlateScanningAT = [[ALExample alloc] initWithName:NSLocalizedString(@"Austrian License Plate Scanner", nil)
                                                       viewController:[ALLicensePlateATViewController class]];
    
    
    ALExample *licensePlateScanningDE = [[ALExample alloc] initWithName:NSLocalizedString(@"German License Plate Scanner", nil)
                                                         viewController:[ALLicensePlateDEViewController class]];
    
    ALExample *carVINNumberScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Car VIN Number", nil) viewController:[ALVINScanViewController class]];
    
    
    self.sectionNames = @[@"Energy",@"Identification",@"Barcodes",@"Fintech",@"Document",@"Loyality",@"Cars",@"Other"];
    self.examples = @{self.sectionNames[0] : @[electricScanning,gasScanning,heatScanning,digitalScanning,waterScanning],
                      self.sectionNames[1] : @[idScanning],
                      self.sectionNames[2] : @[barcodeScanning],
                      self.sectionNames[3] : @[ibanScanning],
                      self.sectionNames[4] : @[documentScanning],
                      self.sectionNames[5] : @[voucherCodeScanning,rbScanning,stieglScanning],
                      self.sectionNames[6] : @[carVINNumberScanning, licensePlateScanning, licensePlateScanningAT, licensePlateScanningDE],
                      self.sectionNames[7] : @[scrabbleScanning,isbnScanning,recordScanning],
                      };
}

- (NSInteger)numberOfSections {
    return self.sectionNames.count + 1;
}

- (NSString *)titleForSectionIndex:(NSInteger)index {
    if (index == self.numberOfSections - 1) {
        NSString * bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        NSString * SDKVersion   = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        return [NSString stringWithFormat:@"B%@ %@", bundleVersion, SDKVersion];
    }
    return self.sectionNames[index];
}

- (NSInteger)numberOfExamplesInSectionIndex:(NSInteger)index {
    if (index == self.numberOfSections - 1) {
        return 0;
    }
    return [self.examples[self.sectionNames[index]] count];
}

- (ALExample *)exampleForIndexPath:(NSIndexPath *)indexPath {
    return self.examples[self.sectionNames[indexPath.section]][indexPath.row];
}

@end
