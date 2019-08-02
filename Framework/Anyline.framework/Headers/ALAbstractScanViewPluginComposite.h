//
//  ALAbstractScanViewPluginComposite.h
//  Anyline
//
//  Created by Angela Brett on 09.07.19.
//  Copyright © 2019 9Yards GmbH. All rights reserved.
//

#ifndef ALAbstractScanViewPluginComposite_h
#define ALAbstractScanViewPluginComposite_h

#import "ALAbstractScanViewPlugin.h"

@protocol ALCompositeScanPluginDelegate;

@interface ALAbstractScanViewPluginComposite : ALAbstractScanViewPlugin

@property BOOL isRunning;

- (void)addPlugin:(ALAbstractScanViewPlugin * _Nonnull)plugin;
- (void)removePlugin:(NSString * _Nonnull)pluginID;
- (instancetype _Nonnull )initWithPluginID:(NSString *_Nonnull)pluginID;
- (void)addDelegate:(id<ALCompositeScanPluginDelegate>_Nonnull)delegate;
- (void)removeDelegate:(id<ALCompositeScanPluginDelegate>_Nonnull)delegate;
@end

@interface ALSerialScanViewPluginComposite : ALAbstractScanViewPluginComposite
- (BOOL)startFromID:(NSString * _Nonnull)pluginID andReturnError:(NSError * _Nullable * _Nullable)error;

@end

@interface ALCompositeResult : ALScanResult< NSDictionary<NSString *,ALScanResult *> *>
@end

@protocol ALCompositeScanPluginDelegate <NSObject>

@required
/**
 *  Returns the scanned value
 *
 *  @param anylineBarcodeScanPlugin The plugin
 *  @param scanResult The scanned value
 *
 */
- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite * _Nonnull)anylineCompositeScanPlugin
                   didFindResult:(ALCompositeResult * _Nonnull)scanResult;


@end

#endif /* ALAbstractScanViewPluginComposite_h */

