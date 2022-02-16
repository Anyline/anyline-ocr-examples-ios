//
//  ALTireResult.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 24.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import "ALScanResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTireResult : ALScanResult<NSString *>

/**
 *  The thresholded image where the scanned text was found
 */
@property (nullable, nonatomic, strong, readonly) UIImage *thresholdedImage;

/**
 Constructor for an OCRResult

 @param result The string scan result
 @param image The image where the result was found
 @param fullImage A fullframe image from the result
 @param confidence The confidence for the result
 @param pluginID The pluginID which generated the result
 @param thresholdedImage A thresholded Image of the result
 @return Instance of an OCRResult
 */
- (instancetype _Nullable)initWithResult:(NSString * _Nonnull)result
                                  image:(UIImage * _Nonnull)image
                              fullImage:(UIImage * _Nullable)fullImage
                             confidence:(NSInteger)confidence
                               pluginID:(NSString *_Nonnull)pluginID
                       thresholdedImage:(UIImage * _Nullable)thresholdedImage;

@end

NS_ASSUME_NONNULL_END
