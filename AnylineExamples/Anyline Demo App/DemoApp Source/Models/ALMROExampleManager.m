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
#import "ALVerticalContainerScanViewController.h"

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
    
    ALExample *vinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Vehicle Identification Number", nil)
                                                       image:[UIImage imageNamed:@"vin"]
                                              viewController:[ALVINScanViewController class]];
    
    ALExample *containerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Horizontal Shipping Container", nil)
                                                             image:[UIImage imageNamed:@"container serial numbers"]
                                                    viewController:[ALContainerScanViewController class]];
    
    ALExample *verticalContainerScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Vertical Shipping Container", nil)
                                                                     image:[UIImage imageNamed:@"vertical container scanner"]
                                                            viewController:[ALVerticalContainerScanViewController class]];
    
    ALExample *tinScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Identification Number (DOT)", nil)
                                                       image:[UIImage imageNamed:@"tin"]
                                              viewController:[TireViewController class] title:@"Tire Identification Number (DOT)"];
    
    ALExample *tireSizeScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Tire Size Specifications", nil)
                                                            image:[UIImage imageNamed:@"tin"]
                                                   viewController:[TireViewController class] title:@"Tire Size Specifications"];
    
    ALExample *commercialTireScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Commercial Tire Identification Number", nil)
                                                                  image:[UIImage imageNamed:@"tin"]
                                                         viewController:[TireViewController class] title:@"Commercial Tire Identification Number"];
    
    self.sectionNames = @[@"MRO",];
    self.examples = @{
        self.sectionNames[0] : @[
            serialNumberScanning,
            vinScanning,
            tinScanning,
            tireSizeScanning,
            commercialTireScanning,
            containerScanning,
            verticalContainerScanning,
        ],
    };
}

@end
