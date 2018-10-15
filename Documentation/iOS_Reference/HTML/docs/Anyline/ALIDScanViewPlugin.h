//
//  ALIdentityDocumentScanViewPlugin.h
//  Anyline
//
//  Created by Daniel Albertini on 29/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALIDScanPlugin.h"
#import "ALAbstractScanViewPlugin.h"

@interface ALIDScanViewPlugin : ALAbstractScanViewPlugin

@property (nullable, nonatomic, strong) ALIDScanPlugin *idScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALIDScanPlugin *_Nonnull)idScanPlugin;

- (_Nullable instancetype)initWithScanPlugin:(ALIDScanPlugin *_Nonnull)idScanPlugin
                        scanViewPluginConfig:(ALScanViewPluginConfig *_Nonnull)scanViewPluginConfig;

@end
