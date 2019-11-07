//
//  ALExampleManager.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 06.02.15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALExampleManager.h"

#import "ALAnalogMeterScanViewController.h"
#import "ALAutoAnalogDigitalMeterScanViewController.h"
#import "ALDialMeterScanViewController.h"
#import "ALSerialNumberScanViewController.h"

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

#import "ALLicensePlateViewController.h"

NSString * const processTitle = @"Processes";

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
    self.title = @"Anyline";
    
    ALExample *example = [[ALExample alloc] initWithName:@"Example"
                                                   image:nil
                                          viewController:nil];
    self.sectionNames = @[@"Anyline",];
    self.examples = @{
                      self.sectionNames[0] : @[example],
                      };
}

- (NSInteger)numberOfSections {
    return self.sectionNames.count;
}

- (NSString *)titleForSectionIndex:(NSInteger)index {
    return self.sectionNames[index];
}

- (NSInteger)numberOfExamplesInSectionIndex:(NSInteger)index {
    return [self.examples[self.sectionNames[index]] count];
}

- (ALExample *)exampleForIndexPath:(NSIndexPath *)indexPath {
    return self.examples[self.sectionNames[indexPath.section]][indexPath.row];
}


@end
