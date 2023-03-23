#import <Foundation/Foundation.h>
#import <Anyline/Anyline.h>

NS_ASSUME_NONNULL_BEGIN

@class ALResultEntry;

@interface ALBarcodeResultUtil : NSObject

//+ (NSArray<ALResultEntry *> *)barcodeResultDataFromBarcodeResult:(ALBarcodeResult *)barcodeResult;

+ (NSArray<ALResultEntry *> *)resultDataFromBarcodeResults:(NSArray<ALBarcode *> *)barcodes;

@end

NS_ASSUME_NONNULL_END
