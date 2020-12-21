//
//  ALBarcodeFormatHelper.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 11.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcodeFormatHelper : NSObject

+ (NSDictionary<NSString *, NSArray<NSString*> *> *)readableBarcodeNamesDict;

+ (NSArray<NSString*> *)readableHeaderArray;

+ (NSArray<NSString *> *)defaultReadableName;

+ (NSArray<NSString *> *)readableNameForFormats:(NSArray<NSString *> *)formats;

+ (NSArray<NSString *> *)formatsForReadableNames:(NSArray<NSString *> *)readableNames;

@end

NS_ASSUME_NONNULL_END
