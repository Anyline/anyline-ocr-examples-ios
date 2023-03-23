#import "ALBarcodeResultUtil.h"
#import "AnylineExamples-Swift.h"

@implementation ALBarcodeResultUtil

+ (NSArray<ALResultEntry *> *)resultDataFromBarcodeResults:(NSArray<ALBarcode *> *)barcodes {
    NSMutableArray<ALResultEntry *> *resultData = [NSMutableArray arrayWithCapacity:barcodes.count];
    for (ALBarcode *barcode in barcodes) {
        // If we are have a parsed PDF417 result display it in a different way
//        NSMutableArray<ALResultEntry *> *pdf417Results = [NSMutableArray<ALResultEntry *> array];
//        if (barcode.parsedPDF417 != nil) {
//            @try {
//                NSDictionary *body = barcode.parsedPDF417[kPDF417ParsedBody];
//                for (NSString *key in body) {
//                    NSString *value = [body[key] uppercaseString];
//                    NSString *title = [NSString stringWithFormat:@"%@ (Barcode)", [ALUniversalIDFieldnameUtil camelCaseToTitleCase:key]];
//                    [pdf417Results addObject:[[ALResultEntry alloc] initWithTitle:title value:value]];
//                }
//            } @catch (id anException) {
//                // Something went wrong with converting the PDF417 code
//            }
//        }
//
//        if (pdf417Results.count > 0) {
//            [resultData addObjectsFromArray:pdf417Results];
//        } else {
//            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Result"
//                                                                 value:barcodeString
//                                                   shouldSpellOutValue:YES]];
//        }

        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Result"
                                                             value:barcode.value
                                               shouldSpellOutValue:YES]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Symbology"
                                                             value:barcode.format
                                               shouldSpellOutValue:YES]];
    }
    return resultData;
}

/// Returns an array of ALResultEntry for use with a results screen, given an
/// ALBarcodeResult. The results may also include PDF417-AAMVA parsed data, if
/// the barcode scan plugin's `parsePDF417` property had been set to YES.
///
/// @param barcodeResult A barcode scan result
///
//+ (NSArray<ALResultEntry *> *)barcodeResultDataFromBarcodeResult:(ALBarcodeResult *)barcodeResult {
//    NSMutableArray<ALResultEntry *> *resultData = [NSMutableArray array];
//    for (ALBarcode *barcode in barcodeResult.result) {
//        NSString *barcodeString = [[self class] strValueFromBarcode:barcode];
//        // If we are have a parsed PDF417 result display it in a different way
//        NSMutableArray<ALResultEntry *> *pdf417Results = [NSMutableArray<ALResultEntry *> array];
//        if (barcode.parsedPDF417 != nil) {
//            @try {
//                NSDictionary *body = barcode.parsedPDF417[kPDF417ParsedBody];
//                for (NSString *key in body) {
//                    NSString *value = [body[key] uppercaseString];
//                    NSString *title = [NSString stringWithFormat:@"%@ (Barcode)", [ALUniversalIDFieldnameUtil camelCaseToTitleCase:key]];
//                    [pdf417Results addObject:[[ALResultEntry alloc] initWithTitle:title value:value]];
//                }
//            } @catch (id anException) {
//                // Something went wrong with converting the PDF417 code
//            }
//        }
//
//        if (pdf417Results.count > 0) {
//            [resultData addObjectsFromArray:pdf417Results];
//        } else {
//            [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Result"
//                                                                 value:barcodeString
//                                                   shouldSpellOutValue:YES]];
//        }
//        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Barcode Symbology" value:barcode.barcodeFormat shouldSpellOutValue:YES]];
//    }
//    return resultData;
//}

@end
