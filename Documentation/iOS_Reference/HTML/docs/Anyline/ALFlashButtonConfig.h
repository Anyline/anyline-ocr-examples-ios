//
//  ALFlashButtonConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"

@interface ALFlashButtonConfig : NSObject

@property (nonatomic, assign) ALFlashMode flashMode;
@property (nonatomic, assign) ALFlashAlignment flashAlignment;
@property (nullable, nonatomic, strong) UIImage *flashImage;
@property (nonatomic, assign) CGPoint flashOffset;

+ (_Nullable instancetype)configurationFromJsonFilePath:(NSString * _Nonnull)jsonFile;

- (_Nullable instancetype)initWithJsonFilePath:(NSString * _Nonnull)jsonFile;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

- (instancetype _Nullable)initWithFlashMode:(ALFlashMode)flashMode
                             flashAlignment:(ALFlashAlignment)flashAlignment
                                flashOffset:(CGPoint)flashOffset;

+ (instancetype _Nonnull)defaultFlashConfig;

@end
