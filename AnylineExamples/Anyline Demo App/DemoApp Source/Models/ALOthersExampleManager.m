//
//  ALOthersExampleManager.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALOthersExampleManager.h"

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
#import "ALHashtagScanViewController.h"
#import "ALBadgeScanViewController.h"
#import "ALVINScanViewController.h"
#import "ALDrivingLicenseScanViewController.h"

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
    ALExample *ibanScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"IBAN", nil)
                                                        image:[UIImage imageNamed:@"iban"]
                                               viewController:[ALIBANScanViewController class]];
    
    ALExample *bottleCapScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Bottlecap", nil)
                                                             image:[UIImage imageNamed:@"bottle caps"]
                                                    viewController:[ALBottlecapScanViewController class]];
    
    ALExample *rbScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"RedBull Mobile Collect", nil)
                                                      image:[UIImage imageNamed:@"red bull mobile collect"]
                                             viewController:[ALRBScanViewController class]];
    
    ALExample *voucherCodeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Voucher Code", nil)
                                                               image:[UIImage imageNamed:@"voucher"]
                                                      viewController:[ALVoucherCodeScanViewController class]];

    ALExample *documentScanner = [[ALExample alloc] initWithName:NSLocalizedString(@"Document Scanner", nil)
                                                                image:[UIImage imageNamed:@"document"]
                                                       viewController:[ALDocumentScanViewController class]];
    
    ALExample *scrabbleScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Scrabble Anagram", nil)
                                                            image:[UIImage imageNamed:@"scrabble"]
                                                   viewController:[ALScrabbleScanViewController class]];
    
    ALExample *recordScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Record Number", nil)
                                                          image:[UIImage imageNamed:@"vinyl record number"]
                                                 viewController:[ALRecordNumberScanViewController class]];
    
    ALExample *isbnScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"ISBN", nil)
                                                        image:[UIImage imageNamed:@"isbn"]
                                               viewController:[ALISBNScanViewController class]];
    
    ALExample *driverATScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"AT Driving License", nil)
                                                            image:[UIImage imageNamed:@"driving license"]
                                                   viewController:[ALDrivingLicenseScanViewController class]];

    ALExample *barcodeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Barcode / QR-Code", nil)
                                                           image:[UIImage imageNamed:@"barcode"]
                                                  viewController:[ALMultiformatBarcodeScanViewController class]];
    
    self.sectionNames = @[@"Others",];
    self.examples = @{
                      self.sectionNames[0] : @[ibanScanning, bottleCapScanning, rbScanning, voucherCodeScanning, scrabbleScanning, recordScanning, isbnScanning, driverATScanning, barcodeScanning, documentScanner],
                      };
}

@end
