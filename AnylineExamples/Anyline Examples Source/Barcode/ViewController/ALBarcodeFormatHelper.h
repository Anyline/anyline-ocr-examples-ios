#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ALBarcodeFormat;

@interface ALBarcodeFormatHelper : NSObject

+ (NSDictionary<NSString *, NSArray<NSString*> *> *)readableBarcodeNamesDict;

+ (NSArray<NSString*> *)readableHeaderArray;

+ (NSArray<NSString *> *)defaultSymbologiesReadableNames;

+ (NSArray<NSString *> *)readableNameForFormats:(NSArray<ALBarcodeFormat *> *)formats;

+ (NSArray<ALBarcodeFormat *> *)formatsForReadableNames:(NSArray<NSString *> *)readableNames;

@end

NS_ASSUME_NONNULL_END
