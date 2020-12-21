//
//  ALAbstractScanViewPluginComposite.h
//  Anyline
//
//  Created by Angela Brett on 09.07.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
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

@interface ALCompositeResult : ALScanResult< NSDictionary<NSString *,ALScanResult *> *>
@end

@protocol ALCompositeScanPluginDelegate <NSObject>

@required
/**
 *  Returns the scanned values
 *
 *  @param anylineCompositeScanPlugin The plugin
 *  @param scanResult The scanned values, as a dictionary mapping each plugin ID to the result for that plugin. Scan results for plugins which have been skipped will return true from isEmpty.
 *
 */
- (void)anylineCompositeScanPlugin:(ALAbstractScanViewPluginComposite * _Nonnull)anylineCompositeScanPlugin
                   didFindResult:(ALCompositeResult * _Nonnull)scanResult;


@end

#endif /* ALAbstractScanViewPluginComposite_h */

