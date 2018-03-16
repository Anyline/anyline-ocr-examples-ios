//
//  ALMROExampleManager.h
//  AnylineExamples
//
//  Created by Philipp Müller on 14/03/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import "ALMROExampleManager.h"

#import "ALUniversalSerialNumberScanViewController.h"
#import "ALVINScanViewController.h"

#import "ALOthersExampleManager.h"
#import "ALMeterExampleManager.h"
#import "ALGridCollectionViewController.h"
#import "ALMeterCollectionViewController.h"

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
    self.title = @"MRO";
    
    ALExample *serialNumberScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Universal Serial Number", nil)
                                                                image:[UIImage imageNamed:@"serial number"]
                                                       viewController:[ALUniversalSerialNumberScanViewController class]];
    
    ALExample *vinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"VIN", nil)
                                                       image:[UIImage imageNamed:@"vin"]
                                              viewController:[ALVINScanViewController class]];
    
    
    
    self.sectionNames = @[@"MRO",];
    self.examples = @{
                      self.sectionNames[0] : @[serialNumberScanning,vinScanning,],
                      };
}

@end
