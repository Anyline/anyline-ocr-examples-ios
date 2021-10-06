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

@interface ALBarcode: NSObject

@property (nonatomic, strong, readonly) NSString * _Nonnull barcodeFormat;
@property (nonatomic, copy,   readonly) NSString * _Nonnull value;
@property (nonatomic, copy,   readonly) NSString * _Nonnull base64;
@property (nonatomic, copy,   readonly) ALSquare * _Nullable coordinates;

- (instancetype _Nonnull )initWithValue:(NSString * _Nonnull)value
                                 format:(NSString * _Nonnull)barcodeFormat;

- (instancetype _Nonnull)initWithValue:(NSString * _Nonnull)value
                                format:(NSString * _Nonnull)barcodeFormat
                           coordinates:(NSString * _Nullable)coordinates
                                base64:(NSString * _Nullable)base64;

- (NSString * _Nonnull)toJSONString;

+ (NSArray<NSString*>*_Nullable)allBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)basicBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)advancedBarcodeFormats;

@end

NS_ASSUME_NONNULL_END
