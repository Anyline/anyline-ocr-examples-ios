//
//  ALBarcodeResult.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

extern NSString * _Nonnull const kCodeTypeAztec;
extern NSString * _Nonnull const kCodeTypeCodabar;
extern NSString * _Nonnull const kCodeTypeCode39;
extern NSString * _Nonnull const kCodeTypeCode93;
extern NSString * _Nonnull const kCodeTypeCode128;
extern NSString * _Nonnull const kCodeTypeDataMatrix;
extern NSString * _Nonnull const kCodeTypeEAN8;
extern NSString * _Nonnull const kCodeTypeEAN13;
extern NSString * _Nonnull const kCodeTypeITF;
extern NSString * _Nonnull const kCodeTypePDF417;
extern NSString * _Nonnull const kCodeTypeQR;
extern NSString * _Nonnull const kCodeTypeRSS14;
extern NSString * _Nonnull const kCodeTypeRSSExpanded;
extern NSString * _Nonnull const kCodeTypeUPCA;
extern NSString * _Nonnull const kCodeTypeUPCE;
extern NSString * _Nonnull const kCodeTypeUPCEANExtension;

/**
 *  Theses are the valid code types to supply to setBarcodeFormatOptions:
 *  Use | do allow multiple formats.
 *
 */
typedef NS_OPTIONS(NSInteger, ALBarcodeFormatOptions) {
    ALCodeTypeAztec             = 1 << 0,
    ALCodeTypeCodabar           = 1 << 1,
    ALCodeTypeCode39            = 1 << 2,
    ALCodeTypeCode93            = 1 << 3,
    ALCodeTypeCode128           = 1 << 4,
    ALCodeTypeDataMatrix        = 1 << 5,
    ALCodeTypeEAN8              = 1 << 6,
    ALCodeTypeEAN13             = 1 << 7,
    ALCodeTypeITF               = 1 << 8,
    ALCodeTypePDF417            = 1 << 9,
    ALCodeTypeQR                = 1 << 10,
    ALCodeTypeRSS14             = 1 << 11,
    ALCodeTypeRSSExpanded       = 1 << 12,
    ALCodeTypeUPCA              = 1 << 13,
    ALCodeTypeUPCE              = 1 << 14,
    ALCodeTypeUPCEANExtension   = 1 << 15,
    
    ALCodeTypeUnknown           = 0,
    
    ALCodeTypeAll = (ALCodeTypeAztec |
                     ALCodeTypeCodabar |
                     ALCodeTypeCode39 |
                     ALCodeTypeCode93 |
                     ALCodeTypeCode128 |
                     ALCodeTypeDataMatrix |
                     ALCodeTypeEAN8 |
                     ALCodeTypeEAN13 |
                     ALCodeTypeITF |
                     ALCodeTypePDF417 |
                     ALCodeTypeQR |
                     ALCodeTypeRSS14 |
                     ALCodeTypeRSSExpanded |
                     ALCodeTypeUPCA |
                     ALCodeTypeUPCE |
                     ALCodeTypeUPCEANExtension),
};

typedef ALBarcodeFormatOptions ALBarcodeFormat;

/**
 *  The result object for the AnylineBarcodePlugin
 */
@interface ALBarcodeResult : ALScanResult<NSString *>
/**
 * The scanned barcode format
 */
@property (nonatomic, assign, readonly) ALBarcodeFormat barcodeFormat;

- (instancetype _Nullable)initWithResult:(NSString * _Nonnull)result
                                   image:(UIImage * _Nonnull)image
                               fullImage:(UIImage * _Nullable)fullImage
                              confidence:(NSInteger)confidence
                                 outline:(ALSquare * _Nullable)outline
                                pluginID:(NSString *_Nonnull)pluginID
                           barcodeFormat:(ALBarcodeFormat)barcodeFormat;

@end
