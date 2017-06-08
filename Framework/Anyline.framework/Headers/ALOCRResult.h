//
//  ALOCRResult.h
//  Anyline
//
//  Created by Daniel Albertini on 20/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALScanResult.h"

/**
 *  The result object for the AnylineOCRModule
 */
@interface ALOCRResult : ALScanResult<NSString *>
/**
 *  The scanned text in the frame.
 *
 *  @deprecated since 3.10. Use result property instead
 */
@property (nullable, nonatomic, strong, readonly) NSString *text __deprecated_msg("Deprecated since 3.10 Use result property instead.");

/**
 *  The thresholded image where the scanned text was found
 */
@property (nullable, nonatomic, strong, readonly) UIImage *thresholdedImage;

/**
 *  @deprecated since 3.10
 */
- (instancetype _Nullable)initWithText:(NSString * _Nonnull)text
                                image:(UIImage * _Nonnull)image
                     thresholdedImage:(UIImage * _Nullable)thresholdedImage __deprecated_msg("Deprecated since 3.10 Use initWithResult:image:fullImage:confidence instead.");

- (instancetype _Nullable)initWithResult:(NSString * _Nonnull)result
                                  image:(UIImage * _Nonnull)image
                              fullImage:(UIImage * _Nullable)fullImage
                             confidence:(NSInteger)confidence
                                outline:(ALSquare * _Nullable)outline
                               pluginID:(NSString *_Nonnull)pluginID
                       thresholdedImage:(UIImage * _Nullable)thresholdedImage;

@end
