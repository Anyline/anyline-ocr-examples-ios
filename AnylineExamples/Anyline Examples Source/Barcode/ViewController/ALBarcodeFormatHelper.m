//
//  ALBarcodeFormatHelper.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 11.12.20.
//

#import "ALBarcodeFormatHelper.h"
#import <Anyline/Anyline.h>

static NSDictionary<NSString*, NSDictionary<NSString*, NSArray<NSString*>*>*> *barcodeFormats;
static NSArray<NSString *> *defaultReadableNames;

static NSArray<NSString *> *headerNames;

static NSString * const k1DRetail = @"1D SYMBOLOGIES - RETAIL";
static NSString * const k1DLogisitcs = @"1D SYMBOLOGIES - LOGISTICS / INVENTORY";
static NSString * const k2D = @"2D SYMBOLOGIES";
static NSString * const kPostal = @"POSTAL CODES";
static NSString * const kLegacy = @"LEGACY SYMBOLOGIES";

@implementation ALBarcodeFormatHelper

+ (void)initialize {
    barcodeFormats = @{k1DRetail : @{@"UPC/EAN" : @[kCodeTypeEAN8,kCodeTypeEAN13,kCodeTypeUPCA,kCodeTypeUPCE,kCodeTypeUPCEANExtension,kCodeTypeUPC_EAN_EXTENSION], @"GS1 DataBar & Composite Codes" : @[kCodeTypeRSS14,kCodeTypeRSSExpanded,kCodeTypeRSS_EXPANDED] },
                       k1DLogisitcs : @{@"Code 128" : @[kCodeTypeCode128], @"Code 39" : @[kCodeTypeCode39], @"Interleaved 2 of 5" : @[kCodeTypeITF], @"GS1-128" : @[kCodeTypeGS1_128], @"ISBT 128" : @[kCodeTypeISBT_128], @"Trioptic Code 39" : @[kCodeTypeTRIOPTIC], @"Code 32" : @[kCodeTypeCODE_32], @"Code 93" : @[kCodeTypeCode93], @"Matrix 2 of 5" : @[kCodeTypeMATRIX_2_5],},
                       k2D : @{@"PDF417" : @[kCodeTypePDF417], @"QR Code" : @[kCodeTypeQR], @"MicroPDF417" : @[kCodeTypeMICRO_PDF], @"MicroQR" : @[kCodeTypeMICRO_QR], @"GS1 QR Code" : @[kCodeTypeGS1_QR_CODE], @"Aztec" : @[kCodeTypeAztec],},
                       kPostal : @{@"US Postnet" : @[kCodeTypeUS_POSTNET], @"US Planet" : @[kCodeTypeUS_PLANET], @"UK Postal" : @[kCodeTypePOST_UK], @"USPS 4CD / One Code / Intelligent Mail" : @[kCodeTypeUSPS_4CB,kCodeTypeDOT_CODE],},
                       kLegacy : @{@"Code 25" : @[kCodeTypeDISCRETE_2_5], @"Codabar" : @[kCodeTypeCodabar], @"Code 11" : @[kCodeTypeCODE_11]}
    };
    
    defaultReadableNames = @[@"UPC/EAN", @"Code 128", @"Code 39", @"Interleaved 2 of 5", @"PDF417", @"QR Code"];
    
    headerNames = @[k1DRetail, k1DLogisitcs, k2D, kPostal, kLegacy];
}

+ (NSDictionary<NSString *, NSArray<NSString*> *> *)readableBarcodeNamesDict {
    NSMutableDictionary<NSString *, NSArray<NSString*> *> *readableBarcodeNamesDict = [@{} mutableCopy];
    
    [barcodeFormats enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,NSArray<NSString *> *> * _Nonnull obj, BOOL * _Nonnull stop) {
        readableBarcodeNamesDict[key] = obj.allKeys;
    }];
    
    return readableBarcodeNamesDict;
}

+ (NSArray<NSString*> *)readableHeaderArray {
    return headerNames;
}

+ (NSArray<NSString *> *)defaultReadableName {
    return defaultReadableNames;
}


+ (NSArray<NSString *> *)readableNameForFormats:(NSArray<NSString *> *)formats {
    NSMutableArray<NSString *> *readableNames = [@[] mutableCopy];
    
    for (NSString *defaultFormat in formats) {
        [barcodeFormats enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,NSArray<NSString *> *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull readableName, NSArray<NSString *> * _Nonnull sdkNames, BOOL * _Nonnull stop2) {
                for (NSString *sdkFormat in sdkNames) {
                    if ([defaultFormat isEqualToString:sdkFormat]) {
                        if (![readableNames containsObject:readableName]) {
                            [readableNames addObject:readableName];
                        }
                        *stop = YES;
                        *stop2 = YES;
                    }
                }
            }];
        }];
    }
    return readableNames;
}

+ (NSArray<NSString *> *)formatsForReadableNames:(NSArray<NSString *> *)readableNames {
    NSMutableArray<NSString *> *sdkFormats = [@[] mutableCopy];
    
    for (NSString *readableName in readableNames) {
        [barcodeFormats enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,NSArray<NSString *> *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull readableNameKey, NSArray<NSString *> * _Nonnull sdkNames, BOOL * _Nonnull stop2) {
                if ([readableName isEqualToString:readableNameKey]) {
                    [sdkFormats addObjectsFromArray:sdkNames];
                    *stop = YES;
                    *stop2 = YES;
                }
            }];
        }];
    }
    return sdkFormats;
}

@end
