//
//  ALBarcodeScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 20/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanViewPlugin.h"
#import "ALBarcodeScanPlugin.h"

@interface ALBarcodeScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALBarcodeScanPlugin *barcodeScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALBarcodeScanPlugin *_Nonnull)barcodeScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALBarcodeScanPlugin *_Nonnull)barcodeScanPlugin
                        scanViewPluginConfig:(ALScanViewPluginConfig *_Nonnull)scanViewPluginConfig;

/**
 *  When set to YES we only use the iOS native Barcode scanning.
 *  That one uses less computing power, but is worse under low light conditions.
 */
@property (nonatomic, assign) BOOL useOnlyNativeBarcodeScanning;

@end
