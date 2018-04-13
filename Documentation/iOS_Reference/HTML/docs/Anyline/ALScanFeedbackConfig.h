//
//  ALScanFeedbackConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 05.04.18.
//  Copyright © 2018 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALScanFeedbackConfig : NSObject

@property (nonatomic, assign) BOOL beepOnResult;
@property (nonatomic, assign) BOOL vibrateOnResult;
@property (nonatomic, assign) BOOL blinkAnimationOnResult;
@property (nonatomic, assign) BOOL cancelOnResult;

- (instancetype _Nullable)initWithDictionary:(NSDictionary * _Nonnull)configDict;

@end
