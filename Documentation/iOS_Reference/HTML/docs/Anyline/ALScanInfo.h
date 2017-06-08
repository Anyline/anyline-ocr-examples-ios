//
//  ALScanInfo.h
//  Anyline
//
//  Created by Daniel Albertini on 25/04/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The name for a reported brightness value
 *
 * @type NSNumber holding a double
 */
extern NSString * _Nonnull const kBrightnessVariableName;

/**
 * The name for a reported text outline value
 *
 * @type cv::Rect
 */
extern NSString * _Nonnull const kOutlineVariableName;

/**
 * The name for a reported device acceleration value
 *
 * @type NSNumber holding a double
 */
extern NSString * _Nonnull const kDeviceAccelerationVariableName;

/**
 * The name for a reported thresholded image value
 *
 * @type ALImage
 */
extern NSString * _Nonnull const kThresholdedImageVariableName;

/**
 * The name for a reported contour value
 *
 * @type std::vector<al::Contour>
 */
extern NSString * _Nonnull const kContoursVariableName;

/**
 * The name for a reported square value
 *
 * @type cv::Rect
 */
extern NSString * _Nonnull const kSquareVariableName;

/**
 * The name for a reported polygon value
 *
 * @type ALPolygon
 */
extern NSString * _Nonnull const kPolygonVariableName;

/**
 * The name for a reported sharpness value
 *
 * @type NSNumber holding a double
 */
extern NSString * _Nonnull const kSharpnessVariableName;

/**
 * The name for a reported shake detection warning value
 *
 * @type NSNumber holding a BOOL
 */
extern NSString * _Nonnull const kShakeDetectionWarningVariableName;

@interface ALScanInfo : NSObject

@property (nonnull, nonatomic, strong, readonly) NSString *pluginID;

@property (nonnull, nonatomic, strong, readonly) NSString *variableName;

@property (nonnull, nonatomic, strong, readonly) id value;

- (instancetype _Nullable)initWithVariableName:(NSString * _Nonnull)variableName
                                         value:(id _Nonnull)value
                                      pluginID:(NSString *_Nonnull)pluginID;

@end
