//
//  ALScanResultViewController.h
//  eScan
//
//  Created by Luka Mirosevic on 01/02/15.
//  Copyright (c) 2015 9yards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALBaseViewController.h"

#import <Anyline/Anyline.h>

@class ALMeterReading;

@interface ALScanResultViewController : ALBaseViewController

- (instancetype)initWithMeterReading:(ALMeterReading *)meterReading editingMode:(BOOL)editingMode;

/**
 The original meter reading with which this VC was initialised.
 */
@property (nonatomic, strong, readonly) ALMeterReading      *originalMeterReading;

/**
 The meter reading currently displayed by this VC. If editing is enabled then this will change as the user is interacting.
 */
@property (nonatomic, strong) ALMeterReading                *meterReading;

@end
