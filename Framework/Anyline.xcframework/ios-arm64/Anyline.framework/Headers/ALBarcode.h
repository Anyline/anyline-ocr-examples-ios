//
//  ALBarcode.h
//  Anyline
//
//  Created by David Dengg on 16.12.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBarcodeTypes.h"
#import "ALSquare.h"

NS_ASSUME_NONNULL_BEGIN

// Keys for the parsedPDF417 Dictionary
extern NSString * const kPDF417ParsedBody;
extern NSString * const kPDF417ParsedAdditions;
extern NSString * const kPDF417ParsedVersion;

@interface ALBarcode: NSObject

@property (nonatomic, strong, readonly) NSString * _Nonnull barcodeFormat;
@property (nonatomic, copy,   readonly) NSString * _Nonnull value;
@property (nonatomic, copy,   readonly) NSString * _Nonnull base64;
@property (nonatomic, copy,   readonly) ALSquare * _Nullable coordinates;
@property (nonatomic, copy,   readonly) NSDictionary * _Nonnull parsedPDF417;

- (instancetype _Nonnull )initWithValue:(NSString * _Nonnull)value
                                 format:(NSString * _Nonnull)barcodeFormat;

- (instancetype _Nonnull)initWithValue:(NSString * _Nonnull)value
                                format:(NSString * _Nonnull)barcodeFormat
                           coordinates:(NSString * _Nullable)coordinates
                                base64:(NSString * _Nullable)base64
                          parsedPDF417:(NSString * _Nullable)parsedPDF417;

- (NSString * _Nonnull)toJSONString;

+ (NSArray<NSString*>*_Nullable)allBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)basicBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)advancedBarcodeFormats;

@end

NS_ASSUME_NONNULL_END
