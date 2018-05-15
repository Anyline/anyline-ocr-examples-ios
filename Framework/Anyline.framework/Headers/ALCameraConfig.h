//
//  ALCameraConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALViewConstants.h"

@interface ALCameraConfig : NSObject

@property (nullable, nonatomic, strong) NSString *defaultCamera;
@property (nonatomic, assign) ALCaptureViewResolution captureResolution;
@property (nonatomic, assign) ALPictureResolution pictureResolution;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

- (instancetype _Nullable)initWithDefaultCamera:(NSString *_Nonnull)defaultCamera
                              captureResolution:(ALCaptureViewResolution)captureResolution
                              pictureResolution:(ALPictureResolution)pictureResolution;

+ (instancetype _Nullable)defaultCameraConfig;

@end
