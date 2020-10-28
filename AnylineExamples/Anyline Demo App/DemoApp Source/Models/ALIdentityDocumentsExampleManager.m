//
//  ALIdentityDocumentsExampleManager.h
//  AnylineExamples
//
//  Created by Philipp Müller on 08/04/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALIdentityDocumentsExampleManager.h"

#import "ALMRZScanViewController.h"
#import "ALDrivingLicenseScanViewController.h"

#import "ALOthersExampleManager.h"
#import "ALMeterExampleManager.h"
#import "ALGridCollectionViewController.h"
#import "ALMeterCollectionViewController.h"
#import "ALGermanIDFrontScanViewController.h"
#import "ALPDF417ScanViewController.h"
#import "ALNFCScanViewController.h"

#import "ALNLDrivingLicenseScanViewController.h"
#import "ALBEDrivingLicenseScanViewController.h"
#import "ALUniversalIDScanViewController.h"
#import "ALUniversalIDScanViewControllerFrontAndBack.h"

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
                                                       image:[UIImage imageNamed:@"universal_id_350x256px_300dpi"]
                                              viewController:[ALUniversalIDScanViewControllerFrontAndBack class]];
    
    ALExample *universalIDUS = [[ALExample alloc] initWithName:NSLocalizedString(@"US Driving Licenses", nil)
                                                       image:[UIImage imageNamed:@"us_id_350x256px_300dpi"]
                                              viewController:[ALUniversalIDScanViewControllerFrontAndBack class]
                                                       title:@"US Driving Licenses"];
    
    ALExample *mrzScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Passport/MRZ", nil)
                                                       image:[UIImage imageNamed:@"passport_austria_350x265px"]
                                              viewController:[ALMRZScanViewController class]];
    
    ALExample *driverLicenseScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"AT/DE/UK Driving License", nil)
                                                            image:[UIImage imageNamed:@"driving_license_350x265px"]
                                                   viewController:[ALDrivingLicenseScanViewController class]];
    
    ALExample *germanIDScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"German ID Front", nil)
                                                            image:[UIImage imageNamed:@"id_germany_350x265px"]
                                                   viewController:[ALGermanIDFrontScanViewController class]];
    
    ALExample *pdf417Scanning = [[ALExample alloc] initWithName:NSLocalizedString(@"PDF417", nil)
                                                            image:[UIImage imageNamed:@"pdf417_350x265px"]
                                                   viewController:[ALPDF417ScanViewController class]];
    
    ALExample *nfcScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Passport NFC", nil)
                                                            image:[UIImage imageNamed:@"passport_350x265px"]
                                                   viewController:[ALNFCScanViewController class]];

    self.sectionNames = @[@"Identity Documents"];
    self.examples = [@{
                      self.sectionNames[0] : @[universalID,universalIDUS,mrzScanning,driverLicenseScanning,germanIDScanning,pdf417Scanning]
    } mutableCopy];
    
   //we could check [ALNFCDetector readingAvailable]) here and only show the NFC tile if it returns true, but for clarity we will always show it, and just show an alert about why it's not supported when it's tapped on.
    self.sectionNames = [self.sectionNames arrayByAddingObject:processTitle];
    self.examples[self.sectionNames[1]] = @[nfcScanning];
}

@end
