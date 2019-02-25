//
//  ALUIFeedback.h
//  WebView
//
//  Created by David Dengg on 20.02.18.
//  Copyright © 2018 David Dengg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALSquare.h"
#import "ALPolygon.h"
#import "ALUIConfiguration.h"

@protocol ALCutoutDelegate;

@interface ALUIFeedback : UIView
@property (nonatomic, strong) ALSquare  * _Nonnull square;
@property (nonatomic, strong) ALPolygon * _Nonnull polygon;
@property (nonatomic, strong) NSArray   * _Nonnull contours;

@property (nonatomic, strong, readonly) NSHashTable<ALCutoutDelegate> * _Nullable cutoutDelegates;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                           pluginConfig:(ALScanViewPluginConfig * _Nonnull)pluginConfig
                               pluginID:(NSString * _Nonnull)pluginID;

- (void)cancelFeedback;
- (void)updateConfiguration:(ALScanViewPluginConfig * _Nonnull)pluginConfig;

- (void)setVisualFeedbackStrokeColor:(UIColor * _Nonnull)color pluginID:(NSString * _Nonnull)pluginID;
- (void)setCutoutVisible:(BOOL)isVisible pluginID:(NSString * _Nonnull)pluginID;

- (void)setSquare:(ALSquare * _Nullable)square;
- (void)setPolygon:(ALPolygon * _Nullable)polygon;

- (CGRect)cutout;

- (void)addCutoutDelegate:(id<ALCutoutDelegate> _Nonnull)infoDelegate;

- (void)removeCutoutDelegate:(id<ALCutoutDelegate> _Nonnull)infoDelegate;


@end

@protocol ALCutoutDelegate <NSObject>

@required
/**
 *
 * Called if the cutout was updated within the ALUIFeedback class.
 *
 * @param updatedCutout The updated cutout rect
 *
 */
- (void)alUIFeedback:(ALUIFeedback * _Nonnull)alUIFeedback updatedCutout:(CGRect)cutoutRect;


@end
