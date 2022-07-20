//
//  ALExampleManager.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALMeterExampleManager.h"

//#import "ALAutoAnalogDigitalMeterScanViewController.h"
#import "ALDialMeterScanViewController.h"
#import "ALMeterSerialNumberScanViewController.h"
#import "CustomerSelfReadingViewController.h"
#import "WorkForceViewController.h"
#import "ALParallelMeterScanViewController.h"


@interface ALMeterExampleManager ()

@property (nonatomic, strong) NSDictionary *examples;

@property (nonatomic, strong) NSArray *sectionNames;

@end

@implementation ALMeterExampleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initExampleData];
    }
    return self;
}

- (void)initExampleData {
    self.title = @"Meter Reading";
    ALExample *autoAnalogDigitalMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Analog / Digital", nil)
                                                       image:[UIImage imageNamed:@"analog digital"]
                                              viewController:[ALParallelMeterScanViewController class]];
    
    ALExample *dialMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Dial", nil)
                                                                image:[UIImage imageNamed:@"dial meter"]
                                                       viewController:[ALDialMeterScanViewController class]];
    
    ALExample *serialScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Serial Number", nil)
                                                          image:[UIImage imageNamed:@"serial number"]
                                                 viewController:[ALMeterSerialNumberScanViewController class]];
    
    self.sectionNames = @[@"Meter Types"];
    self.examples = @{
                      self.sectionNames[0] : @[autoAnalogDigitalMeterScanning,
                                               dialMeterScanning,
                                               serialScanning]
                      };
}

@end
