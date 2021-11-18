//
//  ALBarcodeResultUtil.h
//  AnylineExamples
//
//  Created by Aldrich Co on 11/17/21.
//

#import <Foundation/Foundation.h>
#import "ALResultEntry.h"
#import <Anyline/ALBarcodeResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcodeResultUtil : NSObject

+ (NSString *)strValueFromBarcode:(ALBarcode *)barcode;

+ (NSArray<ALResultEntry *> *)barcodeResultDataFromBarcodeResult:(ALBarcodeResult *)barcodeResult;

@end

NS_ASSUME_NONNULL_END
