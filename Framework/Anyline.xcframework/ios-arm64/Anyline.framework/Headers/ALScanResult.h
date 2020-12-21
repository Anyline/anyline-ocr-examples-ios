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
 *  This is nil if the result is from a composite scan view plugin (images from the individual plugins can be found in the scanned result), or in emptyScanResult
 */
@property (nullable, nonatomic, strong, readonly) UIImage *image;
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

@property (readonly) BOOL isEmpty;

- (instancetype _Nullable)initWithResult:(ObjectType _Nonnull)result
                                   image:(UIImage * _Nullable)image
                               fullImage:(UIImage * _Nullable)fullImage
                              confidence:(NSInteger)confidence
                                pluginID:(NSString *_Nonnull)pluginID;
/*
 An empty scan result with the given ID. This is used as the result for plugins within a composite scan view plugin which were skipped. Check whether a scan result is empty using isEmpty
 */
+ (instancetype _Nonnull)emptyScanResultWithID:(NSString *_Nonnull)pluginID ;

@end
