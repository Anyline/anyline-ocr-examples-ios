//
//  ALTireScanViewPlugin.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 24.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import <Anyline/Anyline.h>
#import "ALTireScanPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTireScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALTireScanPlugin *tireScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALTireScanPlugin *_Nonnull)tireScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALTireScanPlugin *_Nonnull)tireScanPlugin
                        scanViewPluginConfig:(ALScanViewPluginConfig *_Nonnull)scanViewPluginConfig;

@end

NS_ASSUME_NONNULL_END
