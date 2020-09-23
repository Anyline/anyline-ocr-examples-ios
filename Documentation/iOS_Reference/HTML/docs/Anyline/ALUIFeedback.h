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
#import "ALScanViewPluginConfig.h"

@protocol ALCutoutDelegate;

@interface ALUIFeedback : UIView
@property (nonatomic, strong) ALSquare  * _Nonnull square;
@property (nonatomic, strong) ALPolygon * _Nonnull polygon;
@property (nonatomic, strong) NSArray   * _Nonnull contours;

@property (nonatomic, strong, readonly) NSHashTable<ALCutoutDelegate> * _Nullable cutoutDelegates;

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                          pluginConfigs:(NSDictionary<NSString *,ALScanViewPluginConfig *> *_Nonnull)configs;

- (void)updateConfigurations:(NSDictionary<NSString *,ALScanViewPluginConfig *> *_Nonnull)configs visiblePlugins:(NSSet<NSString *> *_Nonnull)visible;
- (void)refreshWithCurrentConfigs;
- (void)updateConfiguration:(ALScanViewPluginConfig * _Nonnull)pluginConfig   forPluginID:(NSString *_Nonnull)pluginID;

- (void)setVisualFeedbackStrokeColor:(UIColor * _Nonnull)color pluginID:(NSString * _Nonnull)pluginID;
- (void)setCutoutVisible:(BOOL)isVisible pluginID:(NSString * _Nonnull)pluginID;

- (void)setSquare:(ALSquare * _Nullable)square forPluginID:(NSString * _Nonnull)pluginID;
- (void)setPolygon:(ALPolygon * _Nullable)polygon forPluginID:(NSString * _Nonnull)pluginID;
- (void)setContours:(NSArray * _Nullable)contours forPluginID:(NSString * _Nonnull)pluginID;

- (CGRect)cutoutForPluginID:(NSString *_Nonnull)pluginID;

- (void)addCutoutDelegate:(id<ALCutoutDelegate> _Nonnull)infoDelegate;

- (void)removeCutoutDelegate:(id<ALCutoutDelegate> _Nonnull)infoDelegate;


@end

@protocol ALCutoutDelegate <NSObject>

@required
/**
 *
 * Called if the cutout was updated within the ALUIFeedback class.
 *
 * @param cutoutRect The updated cutout rect
 *
 */
- (void)alUIFeedback:(ALUIFeedback * _Nonnull)alUIFeedback updatedCutout:(CGRect)cutoutRect forPluginID:(NSString *_Nonnull)pluginID;


@end
