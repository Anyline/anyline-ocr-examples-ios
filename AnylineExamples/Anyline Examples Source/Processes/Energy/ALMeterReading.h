//
//  ALMeterReading.h
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeter.h"

@class ALResult;

@interface ALMeterReading : ALMeter <NSCopying>

@property (strong, nonatomic) UIImage               *image;
@property (strong, nonatomic) UIImage               *fullImage;
@property (strong, nonatomic) NSString              *result;
@property (strong, nonatomic) NSString              *barcodeResult;
@property (strong, nonatomic, readonly) NSString    *readingString;
@property (assign, nonatomic, readonly) NSString    *readingValue;
@property (assign, nonatomic, readonly) NSUInteger  insignificantDigitsCount;
@property (assign, nonatomic, readonly) NSUInteger  significantDigitsCount;

- (instancetype)initWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result;
+ (instancetype)meterReadingWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result;

- (instancetype)initWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result barcodeResult:(NSString *)barcodeResult NS_DESIGNATED_INITIALIZER;
+ (instancetype)meterReadingWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result barcodeResult:(NSString *)barcodeResult;

@end

@interface ALMeterReading (DebuggingAdditions)

/**
 Factory method for an instance with some random reading value. For testing purposes.
 */
+ (instancetype)debuggingInstance;

@end


@interface ALMeterReading (FallbackValues)

/**
 *  Returns the fallback value for the passed scanner type
 */
+ (NSString *)fallbackResultForScannerType:(ALScannerType)type;

/**
 *  Returns the fallback cropped image for the passed scanner type
 */
+ (UIImage *)fallbackCroppedImageForScannerType:(ALScannerType)type;

/**
 *  Returns the fallback full image for the passed scanner type
 */
+ (UIImage *)fallbackFullImageForScannerType:(ALScannerType)type;

@end
