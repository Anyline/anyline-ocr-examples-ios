//
//  ALBarcodeResultUtil.h
//  AnylineExamples
//
//  Created by Aldrich Co on 11/17/21.
//

#import <Foundation/Foundation.h>
#import <Anyline/ALBarcodeResult.h>
#import "AnylineExamples-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcodeResultUtil : NSObject

+ (NSString *)strValueFromBarcode:(ALBarcode *)barcode;

+ (NSArray<ALResultEntry *> *)barcodeResultDataFromBarcodeResultArray:(NSArray<ALBarcode *> *)resultData;

@end

NS_ASSUME_NONNULL_END
