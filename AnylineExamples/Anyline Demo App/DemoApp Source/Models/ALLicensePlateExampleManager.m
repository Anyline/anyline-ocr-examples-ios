//
//  ALLicensePlateExampleManager.m
//  AnylineExamples
//
//  Created by Philipp Müller on 05/03/2021.
//  Copyright © 2021 Anyline GmbH. All rights reserved.
//

#import "ALLicensePlateExampleManager.h"
#import "ALLicensePlateViewController.h"
#import "ALUSLicensePlateViewController.h"

@interface ALLicensePlateExampleManager ()

@property (nonatomic, strong) NSMutableDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALLicensePlateExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"License Plate";
    
    ALExample *licensePlateEU = [[ALExample alloc] initWithName:NSLocalizedString(@"EU License Plate", nil)
                                                       image:[UIImage imageNamed:@"tile_licenseplate_eu"]
                                              viewController:[ALLicensePlateViewController class]];
    ALExample *licensePlateUS = [[ALExample alloc] initWithName:NSLocalizedString(@"US License plate", nil)
                                                       image:[UIImage imageNamed:@"tile_licenseplate_us"]
                                              viewController:[ALUSLicensePlateViewController class]];


    self.sectionNames = @[@"License Plate"];
    self.examples = [@{
                      self.sectionNames[0] : @[licensePlateEU, licensePlateUS],
    } mutableCopy];
    
}

@end
