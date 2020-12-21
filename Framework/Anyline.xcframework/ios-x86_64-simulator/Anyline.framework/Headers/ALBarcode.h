//
//  ALBarcode.h
//  Anyline
//
//  Created by David Dengg on 16.12.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBarcodeTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcode: NSObject

@property (nonatomic, strong, readonly) NSString * _Nonnull barcodeFormat;
@property (nonatomic, copy,   readonly) NSString * _Nonnull value;

- (instancetype _Nonnull )initWithValue:(NSString * _Nonnull)value
                                 format:(NSString * _Nonnull)barcodeFormat;

- (NSString * _Nonnull)toJSONString;

+ (NSArray<NSString*>*_Nullable)allBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)basicBarcodeFormats;
+ (NSArray<NSString*>*_Nullable)advancedBarcodeFormats;

@end

NS_ASSUME_NONNULL_END
