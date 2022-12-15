//
//  ALIdentityDocumentsExampleManager.h
//  AnylineExamples
//
//  Created by Philipp Müller on 08/04/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALIdentityDocumentsExampleManager.h"

#import "ALMRZScanViewController.h"
#import "ALOthersExampleManager.h"
#import "ALMeterExampleManager.h"
#import "ALGridCollectionViewController.h"
#import "ALMeterCollectionViewController.h"
#import "ALPDF417ScanViewController.h"
#import "ALNFCScanViewController.h"
#import "ALUniversalIDScanViewController.h"

@interface ALIdentityDocumentsExampleManager ()

@property (nonatomic, strong) NSMutableDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALIdentityDocumentsExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Identity Documents";
    
    ALExample *universalID = [[ALExample alloc] initWithName:NSLocalizedString(@"Universal ID", nil)
                                                       image:[UIImage imageNamed:@"tile_universalid"]
                                              viewController:[ALUniversalIDScanViewController class]];
    
    self.canUpdate = YES;
    
    ALExample *drivingLicenseScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Driver's License", nil)
                                                       image:[UIImage imageNamed:@"tile_driverslicense"]
                                              viewController:[ALUniversalIDScanViewController class]
                                                       title:kDriversLicenseTitleString];
    
    ALExample *idCardScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"ID Card", nil)
                                                       image:[UIImage imageNamed:@"tile_idcard"]
                                              viewController:[ALUniversalIDScanViewController class]
                                                       title:kIDCardTitleString];
    
    ALExample *passportScanning = [[ALExample alloc] initWithName:NSLocalizedString(kPassportVisaTitleString, nil)
                                                       image:[UIImage imageNamed:@"tile_passportvisa"]
                                              viewController:[ALMRZScanViewController class]
                                                       title:kPassportVisaTitleString];
    
    ALExample *mrzScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"MRZ", nil)
                                                       image:[UIImage imageNamed:@"tile_mrz"]
                                              viewController:[ALMRZScanViewController class]];
    
    ALExample *pdf417Scanning = [[ALExample alloc] initWithName:NSLocalizedString(@"PDF417", nil)
                                                            image:[UIImage imageNamed:@"tile_pdf417"]
                                                   viewController:[ALPDF417ScanViewController class]];
    
    ALExample *nfcScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"NFC", nil)
                                                            image:[UIImage imageNamed:@"tile_nfc"]
                                                   viewController:[ALNFCScanViewController class]];

    self.sectionNames = @[@"Universal ID", @"Technology showcase", @"Available ID types"];
    //we could check [ALNFCDetector readingAvailable]) here and only show the NFC tile if it returns true, but for clarity we will always show it, and just show an alert about why it's not supported when it's tapped on.
    self.examples = [@{
                      self.sectionNames[0] : @[universalID],
                      self.sectionNames[1] : @[nfcScanning, pdf417Scanning,mrzScanning],
                      self.sectionNames[2] : @[drivingLicenseScanning, passportScanning, idCardScanning],
    } mutableCopy];
    
}

@end
