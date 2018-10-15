//
//  ALScanResult.h
//  Anyline
//
//  Created by Daniel Albertini on 15/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSquare.h"

/**
 *  The base result object for all the modules
 */
@interface ALScanResult<__covariant ObjectType> : NSObject

/**
 The pluginID which created this ScanPlugin
 */
@property (nonnull, nonatomic, strong, readonly) NSString *pluginID;
/**
 *  The scanned result.
 */
@property (nonnull, nonatomic, strong, readonly) ObjectType result;
/**
 *  The image where the scanned text was found.
 */
@property (nonnull, nonatomic, strong, readonly) UIImage *image;
/**
 *  The full frme image where the scanned text was found.
 */
@property (nullable, nonatomic, strong) UIImage *fullImage;
/**
 *  The confidence for the scanned value.
 */
@property (nonatomic, assign, readonly) NSInteger confidence;
/**
 *  The outline of the found text in relation to the ModuleView.
 */
@property (nullable, nonatomic, strong) ALSquare *outline __deprecated_msg("Deprecated since 3.18.0 You can get the outline as a property from the ScanViewPlugin.");

- (instancetype _Nullable)initWithResult:(ObjectType _Nonnull)result
                                   image:(UIImage * _Nonnull)image
                               fullImage:(UIImage * _Nullable)fullImage
                              confidence:(NSInteger)confidence
                                pluginID:(NSString *_Nonnull)pluginID;

@end
