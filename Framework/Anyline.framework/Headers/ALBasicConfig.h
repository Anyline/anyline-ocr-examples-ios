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
#import "ALCutoutConfig.h"
#import "ALFlashButtonConfig.h"
#import "ALVisualFeedbackConfig.h"
#import "ALScanFeedbackConfig.h"

@interface ALBasicConfig : NSObject

@property (nonatomic, strong) ALCameraConfig * _Nonnull cameraConfig;
@property (nonatomic, strong) ALCutoutConfig * _Nonnull cutoutConfig;
@property (nonatomic, strong) ALFlashButtonConfig * _Nonnull flashButtonConfig;
@property (nonatomic, strong) ALVisualFeedbackConfig * _Nonnull visualFeedbackConfig;
@property (nonatomic, strong) ALScanFeedbackConfig * _Nonnull scanFeedbackConfig;


+ (_Nullable instancetype)cutoutConfigurationFromJsonFile:(NSString * _Nonnull)jsonFile;

- (_Nullable instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary;

@end
