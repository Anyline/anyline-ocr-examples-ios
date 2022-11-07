//
//  ALBarcodeResultUtil.m
//  AnylineExamples
//
//  Created by Aldrich Co on 11/17/21.
//

#import "ALBarcodeResultUtil.h"
#import "ALUniversalIDFieldnameUtil.h"

@implementation ALBarcodeResultUtil

/// Returns an array of ALResultEntry for use with a results screen, given an
/// NSArray<ALBarcode *> *. The results may also include PDF417-AAMVA parsed data, if
/// the barcode scan plugin's `parsePDF417` property had been set to YES.
///
/// @param resultData An array of barcode scan result
///
+ (NSArray<ALResultEntry *> *)barcodeResultDataFromBarcodeResultArray:(NSArray<ALBarcode *> *)resultData {
    NSMutableArray<ALResultEntry *> *resultMutableData = [NSMutableArray array];
    for (ALBarcode *barcode in resultData) {
        NSString *barcodeString = [[self class] strValueFromBarcode:barcode];
        // If we are have a parsed PDF417 result display it in a different way
        NSMutableArray<ALResultEntry *> *pdf417Results = [NSMutableArray<ALResultEntry *> array];
        if (barcode.parsedPDF417 != nil) {
            @try {
                NSDictionary *body = barcode.parsedPDF417[kPDF417ParsedBody];
                for (NSString *key in body) {
                    NSString *value = [body[key] uppercaseString];
                    NSString *title = [NSString stringWithFormat:@"%@ (Barcode)", [ALUniversalIDFieldnameUtil camelCaseToTitleCase:key]];
                    [pdf417Results addObject:[[ALResultEntry alloc] initWithTitle:title value:value]];
                }
            } @catch (id anException) {
                // Something went wrong with converting the PDF417 code
            }
        }
        
        if (pdf417Results.count > 0) {
            [resultMutableData addObjectsFromArray:pdf417Results];
        } else {
            [resultMutableData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Result"
                                                                 value:barcodeString
                                                   shouldSpellOutValue:YES]];
        }
        [resultMutableData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Symbology" value:barcode.barcodeFormat shouldSpellOutValue:YES]];
    }
    return resultMutableData;
}

/// Returns a string value of a barcode, in base64 in case the raw
/// string value cannot be obtained.
///
/// @param barcode An ALBarcode
///
+ (NSString *)strValueFromBarcode:(ALBarcode *)barcode {
    NSString *barcodeString = barcode.base64;
    if (barcode.value.length > 0) {
        barcodeString = barcode.value;
    }
    return barcodeString;
}

@end
