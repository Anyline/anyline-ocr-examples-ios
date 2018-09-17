//
//  ALBasicConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"
#import "ALCameraConfig.h"
#import "ALScanViewPluginConfig.h"
#import "ALFlashButtonConfig.h"

@interface ALBasicConfig : NSObject

@property (nonatomic, strong) ALCameraConfig * _Nonnull cameraConfig;
@property (nonatomic, strong) ALFlashButtonConfig * _Nonnull flashButtonConfig;
@property (nonatomic, strong) ALScanViewPluginConfig * _Nonnull scanViewPluginConfig;

+ (_Nullable instancetype)cutoutConfigurationFromJsonFile:(NSString * _Nonnull)jsonFile;

- (_Nullable instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary;

- (_Nullable instancetype)initWithJsonFile:(NSString * _Nonnull)jsonFile;

- (_Nullable instancetype)initWithCameraConfig:(ALCameraConfig * _Nonnull)cameraConfig
                             flashButtonConfig:(ALFlashButtonConfig * _Nonnull)flashButtonConfig
                          scanViewPluginConfig:(ALScanViewPluginConfig * _Nonnull)scanViewPluginConfig;



@end
