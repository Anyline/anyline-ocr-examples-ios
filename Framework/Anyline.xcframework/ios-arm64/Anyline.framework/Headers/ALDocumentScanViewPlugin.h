//
//  ALDocumentScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 24/10/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import "ALAbstractScanViewPlugin.h"
#import "ALDocumentScanPlugin.h"

@interface ALDocumentScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALDocumentScanPlugin *documentScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALDocumentScanPlugin *_Nonnull)documentScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALDocumentScanPlugin *_Nonnull)documentScanPlugin
                        scanViewPluginConfig:(ALScanViewPluginConfig *_Nonnull)scanViewPluginConfig;

@end
