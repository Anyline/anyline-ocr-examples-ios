//
//  ALMeterReadingView.h
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALMeterReading;

@interface ALMeterReadingView : UIView

// Main properties
@property (assign, nonatomic, getter=isEditingMode) BOOL    editingMode;
@property (strong, nonatomic, readonly) ALMeterReading      *originalMeterReading;
@property (strong, nonatomic) ALMeterReading                *meterReading;

- (instancetype)initWithMeterReading:(ALMeterReading *)meterReading;

- (void)setEditingMode:(BOOL)editingMode animated:(BOOL)animated;

@end
