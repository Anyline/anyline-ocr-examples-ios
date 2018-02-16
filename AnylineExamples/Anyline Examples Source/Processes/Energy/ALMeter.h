//
//  ALMeter.h
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>

typedef NS_ENUM(NSUInteger, ALScannerType) {
    ALScannerTypeUnknown,
    ALScannerTypeGas,
    ALScannerTypePower,
    ALScannerTypeWaterBlackBackground,
    ALScannerTypeWaterWhiteBackground,
    ALScannerTypeSerialNumber,
    ALScannerTypeBarcode,
    ALScannerTypeQRCode,
    ALScannerTypeDigital,
    ALScannerTypeHeat4,
    ALScannerTypeHeat5,
    ALScannerTypeHeat6,
    ALScannerTypeAnalog,
    ALScannerTypeAutoAnalogDigital,
};

@interface ALMeter : NSObject

@property (assign, nonatomic) ALScannerType type;

- (instancetype)initWithType:(ALScannerType)type;

+ (UIImage *)symbolImageForMeterType:(ALScannerType)type;

+ (ALScannerType)scannerTypeForMeterTypeString:(NSString *)meterTypeString;
+ (ALScanMode)scanModeForScannerType:(ALScannerType)scannerType;
+ (ALScannerType)scannerTypeForScanMode:(ALScanMode)scanMode;

/**
 *  Returns a readable string representation of the passed scan mode
 *
 *  @return - readable string or nil
 */
+ (NSString *)readableStringForScanMode:(ALScanMode)scanMode;

@end
