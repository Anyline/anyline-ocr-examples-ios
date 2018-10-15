//
//  ALMeterScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 19/09/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanViewPlugin.h"
#import "ALMeterResult.h"
#import "ALMeterScanPlugin.h"
#import "ALBarcodeScanPlugin.h"

@interface ALMeterScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALMeterScanPlugin *meterScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALMeterScanPlugin *_Nonnull)meterScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALMeterScanPlugin *_Nonnull)meterScanPlugin
                        scanViewPluginConfig:(ALScanViewPluginConfig *_Nonnull)scanViewPluginConfig;

@end
