//
//  ALExampleManager.m
//  AnylineExamples
//
//  Created by Philipp Müller on 21/11/2017.
//  Copyright © 2017 Anyline GmbH. All rights reserved.
//

#import "ALMeterExampleManager.h"

#import "ALAutoAnalogDigitalMeterScanViewController.h"
#import "ALDialMeterScanViewController.h"
#import "ALSerialNumberScanViewController.h"
#import "CustomerSelfReadingViewController.h"
#import "WorkForceViewController.h"


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
                                              viewController:[ALAutoAnalogDigitalMeterScanViewController class]];
    
    ALExample *dialMeterScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Dial", nil)
                                                                image:[UIImage imageNamed:@"dial meter"]
                                                       viewController:[ALDialMeterScanViewController class]];
    
    
    ALExample *selfScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Self Reading", nil)
                                                                          image:[UIImage imageNamed:@"Self Reading"]
                                                                 viewController:[CustomerSelfReadingViewController class]];
    
    ALExample *workforce = [[ALExample alloc] initWithName:NSLocalizedString(@"Workforce", nil)
                                                             image:[UIImage imageNamed:@"Workforce"]
                                                    viewController:[WorkForceViewController class]];
    
    ALExample *serialScanning = [[ALExample alloc] initWithName:NSLocalizedString(@"Serial Number", nil)
                                                          image:[UIImage imageNamed:@"serial number"]
                                                 viewController:[ALSerialNumberScanViewController class]];
    
    self.sectionNames = @[@"Meter Types", @"Processes", @"Others"];
    self.examples = @{
                      self.sectionNames[0] : @[autoAnalogDigitalMeterScanning,
                                               dialMeterScanning,],
                      self.sectionNames[1] : @[selfScanning,
                                               workforce,],
                      self.sectionNames[2] : @[serialScanning,],
                      };
}

@end
