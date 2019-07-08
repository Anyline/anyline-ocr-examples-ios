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

@interface ALIdentityDocumentsExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

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
    
    ALExample *mrzScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Passport/MRZ", nil)
                                                       image:[UIImage imageNamed:@"mrz-version 3"]
                                              viewController:[ALMRZScanViewController class]];
    
    ALExample *driverLicenseScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Driving License", nil)
                                                            image:[UIImage imageNamed:@"driving license"]
                                                   viewController:[ALDrivingLicenseScanViewController class]];
    
    ALExample *germanIDScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"German ID Front", nil)
                                                            image:[UIImage imageNamed:@"german-id-front"]
                                                   viewController:[ALGermanIDFrontScanViewController class]];
    
    ALExample *pdf417Scanning = [[ALExample alloc] initWithName:NSLocalizedString(@"PDF417", nil)
                                                            image:[UIImage imageNamed:@"PDF417"]
                                                   viewController:[ALPDF417ScanViewController class]];
    
    
    
    
    self.sectionNames = @[@"Identity Documents",];
    self.examples = @{
                      self.sectionNames[0] : @[mrzScanning,driverLicenseScanning,germanIDScanning,pdf417Scanning,],
                      };
}

@end
