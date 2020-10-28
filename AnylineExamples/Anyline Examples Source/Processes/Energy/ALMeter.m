//
//  ALMeter.m
//  eScan
//
//  Created by Luka Mirosevic on 26/03/2015.
//  Copyright (c) 2015 Daniel Albertini. All rights reserved.
//

#import "ALMeter.h"

@implementation ALMeter

- (instancetype)initWithType:(ALScannerType)type {
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

+ (UIImage *)symbolImageForMeterType:(ALScannerType)type {
    switch (type) {
        case ALScannerTypeAnalog: {
            return [UIImage imageNamed:@"analog_meter_icon_blue"];
        } break;
        
        case ALScannerTypeAutoAnalogDigital: {
            return [UIImage imageNamed:@"analog_meter_icon_blue"];
        } break;
        
        case ALScannerTypeGas: {
            return [UIImage imageNamed:@"button gas"];
        } break;
            
        case ALScannerTypePower: {
            return [UIImage imageNamed:@"button power"];
        } break;
            
        case ALScannerTypeWaterBlackBackground:
        case ALScannerTypeWaterWhiteBackground: {
            return [UIImage imageNamed:@"button water"];
        } break;
            
        case ALScannerTypeDigital: {
            return [UIImage imageNamed:@"button digital"];
        } break;
        case ALScannerTypeHeat6:
        case ALScannerTypeHeat5:
        case ALScannerTypeHeat4: {
            return [UIImage imageNamed:@"button digital"];
        } break;
            
        case ALScannerTypeQRCode:
        case ALScannerTypeSerialNumber:
        case ALScannerTypeBarcode: {
            return nil;
        } break;
            
        case ALScannerTypeUnknown: {
            return nil;
        } break;
    }
}

+ (ALScannerType)scannerTypeForMeterTypeString:(NSString *)meterTypeString {
    if ([meterTypeString isEqualToString:@"electric_7"]) {
        return ALScannerTypeAnalog;
    }else if ([meterTypeString isEqualToString:@"gas"]) {
        return ALScannerTypeGas;
    } else if ([meterTypeString isEqualToString:@"analog"]) {
        return ALScannerTypeAnalog;
    } else if ([meterTypeString isEqualToString:@"water_dark"]) {
        return ALScannerTypeWaterBlackBackground;
    } else if ([meterTypeString isEqualToString:@"water_light"]) {
        return ALScannerTypeWaterWhiteBackground;
    } else if ([meterTypeString isEqualToString:@"heat_4"]) {
        return ALScannerTypeHeat4;
    } else if ([meterTypeString isEqualToString:@"electric_digital"]) {
        return ALScannerTypeDigital;
    } else {
        return ALScannerTypeAutoAnalogDigital;
    }
}

+ (ALScanMode)scanModeForScannerType:(ALScannerType)scannerType {
    switch (scannerType) {
        case ALScannerTypeAnalog: {
            return ALAnalogMeter;
        } break;
            
        case ALScannerTypeGas: {
            return ALAnalogMeter;
        } break;
            
        case ALScannerTypePower: {
            return ALAnalogMeter;
        } break;
            
        case ALScannerTypeWaterBlackBackground: {
            return ALAnalogMeter;
        } break;
            
        case ALScannerTypeWaterWhiteBackground: {
            return ALAnalogMeter;
        } break;
            
        case ALScannerTypeSerialNumber: {
            return ALSerialNumber;
        } break;

        case ALScannerTypeQRCode:
        case ALScannerTypeBarcode: {
            return ALMeterBarcode;
        } break;
            
        case ALScannerTypeDigital: {
            return ALDigitalMeter;
        } break;
            
        case ALScannerTypeHeat4: {
            return ALHeatMeter4;
        } break;
            
        case ALScannerTypeHeat5: {
            return ALHeatMeter5;
        } break;
        
        case ALScannerTypeHeat6: {
            return ALHeatMeter6;
        } break;
        
        case ALScannerTypeAutoAnalogDigital: {
            return ALAutoAnalogDigitalMeter;
        } break;
        case ALScannerTypeUnknown: {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot convert an unknown scanner type to an ALScanMode" userInfo:nil];
        } break;
    }
}

+ (ALScannerType)scannerTypeForScanMode:(ALScanMode)scanMode {    
    switch (scanMode) {        
        case ALAnalogMeter: {
            return ALScannerTypeAnalog;
        } break;
        
        case ALAutoAnalogDigitalMeter: {
            return ALScannerTypeAutoAnalogDigital;
        } break;
            
        case ALMeterBarcode: {
            return ALScannerTypeBarcode;
        } break;
            
        case ALDigitalMeter: {
            return ALScannerTypeDigital;
        } break;
        case ALHeatMeter4: {
            return ALScannerTypeHeat4;
        } break;
        case ALHeatMeter5: {
            return ALScannerTypeHeat5;
        } break;
        case ALHeatMeter6: {
            return ALScannerTypeHeat6;
        } break;
            
        default:
        {
            //WARNING: These are unimplemented as of yet
            return ALScannerTypeUnknown;
        } break;
    }
    return ALScannerTypeGas;
}

+ (NSString *)readableStringForScanMode:(ALScanMode)scanMode {
    switch (scanMode) {
        case ALAnalogMeter: {
            return @"Analog Meter";
        } break;
            
        case ALAutoAnalogDigitalMeter: {
            return @"Auto Analog Digital Meter";
        } break;
            
        case ALDialMeter: {
            return @"Dial Meter";
        } break;
            
        case ALDotMatrixMeter: {
            return @"Dot Matrix Meter Meter";
        } break;
        case ALMeterBarcode: {
            return @"Barcode";
        } break;
            
        case ALDigitalMeter: {
            return @"Digital Meter";
        } break;
            
        case ALHeatMeter4: {
            return @"Heat Meter";
        } break;
            
        case ALHeatMeter5: {
            return @"Heat Meter";
        } break;
            
        case ALHeatMeter6: {
            return @"Heat Meter";
        } break;
            
        case ALSerialNumber: {
            return @"Serial Number";
        } break;
        default: {
            return nil;
        } break;
    }
    return nil;
}

@end
