//
//  ALMeterReading.m
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeterReading.h"

#import <Anyline/Anyline.h>

@implementation ALMeterReading

#pragma mark - Public

- (instancetype)initWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result {
    return [self initWithType:type image:meterImage fullImage:fullImage result:result barcodeResult:nil];
}

+ (instancetype)meterReadingWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result {
    return [[self alloc] initWithType:type image:meterImage fullImage:fullImage result:result barcodeResult:nil];
}

- (instancetype)initWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result barcodeResult:(NSString *)barcodeResult {
    if (self = [super initWithType:type]) {
        if (!meterImage) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`meterImage` is required when instantiating a ALMeterReading" userInfo:nil];
        if (!result) @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`result` is required when instantiating a ALMeterReading" userInfo:nil];
        
        self.image = meterImage;
        self.fullImage = fullImage;
        self.result = result;
        self.barcodeResult = barcodeResult;
    }

    return self;
}

+ (instancetype)meterReadingWithType:(ALScannerType)type image:(UIImage *)meterImage fullImage:(UIImage *)fullImage result:(NSString *)result barcodeResult:(NSString *)barcodeResult {
    return [[self alloc] initWithType:type image:meterImage fullImage:fullImage result:result barcodeResult:barcodeResult];
}

- (NSString *)readingString {
    return self.result;
}

- (NSString *)readingValue {
    return self.readingValue;
}

- (NSUInteger)insignificantDigitsCount {
    NSArray *components = [self.readingString componentsSeparatedByString:@"."];
    NSUInteger fractionalCount = components.count >= 2 ? [components[1] length] : 0;
    
    return fractionalCount;
}

- (NSUInteger)significantDigitsCount {
    // split it by the decimal separator, then count the first part
    return [self.readingString componentsSeparatedByString:@"."].firstObject.length;
}

#pragma mark - Overrides

- (instancetype)initWithType:(ALScannerType)type {
    return [self initWithType:type image:nil fullImage:nil result:nil];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    __typeof__(self) copy = [[self class] allocWithZone:zone];
    
    copy.type = self.type;
    copy.image = [self.image copy];
    copy.result = [self.result copy];
    
    return copy;
}

@end

@interface ALResultDebuggingSubclass : ALResult <NSCopying>

@property (strong, nonatomic) NSDictionary *values;

@end

@implementation ALResultDebuggingSubclass

#pragma mark - Overrides

- (instancetype)init {
    if (self = [super init]) {
        self.values = @{
            @"alam_1": @(1),
            @"alam_2": @(2),
            @"alam_3": @(3),
            @"alam_4": @(4),
            @"alam_5": @(5),
            @"alam_6": @(6),
            @"alam_7": @(7),
        };
    }
    
    return self;
}

- (BOOL)valid {
    return YES;
}

- (NSArray *)identifiers {
    return self.values.allKeys;
}

- (id)resultForIdentifier:(NSString *)identifier {
    return self.values[identifier];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    __typeof__(self) copy = [[self class] allocWithZone:zone];
    
    copy.values = [self.values copy];
    
    return copy;
}

@end

@implementation ALMeterReading (DebuggingAdditions)

+ (instancetype)debuggingInstance {
    return [[self alloc] initWithType:ALScannerTypePower image:[UIImage imageNamed:@"analog electricity cutout"] fullImage:[UIImage imageNamed:@"analog electricity meter full"] result:@"837449"];
}

@end


@implementation ALMeterReading (FallbackValues)

+ (NSString *)fallbackResultForScannerType:(ALScannerType)type {
    switch (type) {
        case ALScannerTypeAutoAnalogDigital:
        case ALScannerTypeAnalog:{
            return @"83744.9";
        } break;
            
        case ALScannerTypeGas:{
            return @"00613.839";
        } break;
            
        case ALScannerTypePower:{
            return @"83744.9";
        } break;
            
        case ALScannerTypeWaterWhiteBackground:{
            return @"00626.451";
        } break;
            
        case ALScannerTypeWaterBlackBackground:{
            return @"00000.020";
        } break;
            
        case ALScannerTypeHeat4:
        case ALScannerTypeHeat5:
        case ALScannerTypeHeat6:
        case ALScannerTypeDigital:{
            return @"12827.3";
        } break;
            
        case ALScannerTypeBarcode:
        case ALScannerTypeQRCode:{
            return @"01241385 001";
        }
            
        case ALScannerTypeUnknown:
        case ALScannerTypeSerialNumber:{
            return nil;
        } break;
    }
}

+ (UIImage *)fallbackCroppedImageForScannerType:(ALScannerType)type {
    switch (type) {
        case ALScannerTypeAnalog:{
            return [UIImage imageNamed:@"analog electricity cutout"];
        } break;
        
        case ALScannerTypeAutoAnalogDigital:{
            return [UIImage imageNamed:@"analog electricity cutout"];
        } break;
            
        case ALScannerTypeGas:{
            return [UIImage imageNamed:@"gas meter cutout"];
        } break;
            
        case ALScannerTypePower:{
            return [UIImage imageNamed:@"analog electricity cutout"];
        } break;
            
        case ALScannerTypeWaterWhiteBackground:{
            return [UIImage imageNamed:@"water white cutout"];
        } break;
            
        case ALScannerTypeWaterBlackBackground:{
            return [UIImage imageNamed:@"water meter black cutout"];
        } break;
        
        case ALScannerTypeHeat4:
        case ALScannerTypeHeat5:
        case ALScannerTypeHeat6:
        case ALScannerTypeDigital:{
            return [UIImage imageNamed:@"digital cutout"];
        } break;
            
        case ALScannerTypeUnknown:
        case ALScannerTypeSerialNumber:
        case ALScannerTypeBarcode:
        case ALScannerTypeQRCode:{
            return nil;
        } break;
    }
}

+ (UIImage *)fallbackFullImageForScannerType:(ALScannerType)type {
    switch (type) {
        case ALScannerTypeAnalog:{
            return [UIImage imageNamed:@"analog electricity meter full"];
        } break;
            
        case ALScannerTypeAutoAnalogDigital:{
            return [UIImage imageNamed:@"analog electricity meter full"];
        } break;
            
        case ALScannerTypeGas:{
            return [UIImage imageNamed:@"gas meter full"];
        } break;
            
        case ALScannerTypePower:{
            return [UIImage imageNamed:@"analog electricity meter full"];
        } break;
            
        case ALScannerTypeWaterWhiteBackground:{
            return [UIImage imageNamed:@"water meter white full"];
        } break;
            
        case ALScannerTypeWaterBlackBackground:{
            return [UIImage imageNamed:@"water meter black full"];
        } break;
        
        case ALScannerTypeHeat4:
        case ALScannerTypeHeat5:
        case ALScannerTypeHeat6:
        case ALScannerTypeDigital:{
            return [UIImage imageNamed:@"digital meter full"];
        } break;
            
        case ALScannerTypeUnknown:
        case ALScannerTypeSerialNumber:
        case ALScannerTypeBarcode:
        case ALScannerTypeQRCode:{
            return nil;
        } break;
    }
}


@end
