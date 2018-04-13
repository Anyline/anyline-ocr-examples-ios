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

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

@end
