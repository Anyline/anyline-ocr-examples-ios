//
//  ALBarcodeResult.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

@class ALBarcode;

/**
 *  The result object for the AnylineBarcodePlugin
 */
@interface ALBarcodeResult : ALScanResult

/**
 * The scanned barcode format
 */
- (instancetype _Nullable)initWithBarcodes:(NSArray<ALBarcode*>*_Nonnull)result
                                     image:(UIImage * _Nullable)image
                                 fullImage:(UIImage * _Nullable)fullImage
                                confidence:(NSInteger)confidence
                                  pluginID:(NSString * _Nonnull)pluginID;

@property (nonatomic, strong) NSArray<ALBarcode*> * _Nonnull barcodes;
@property (nonatomic, strong) NSArray<ALBarcode*> * _Nonnull result;

@end

