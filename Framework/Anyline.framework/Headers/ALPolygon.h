//
//  ALPolygon.h
//  Anyline
//
//  Created by David on 13.09.16.
//  Copyright © 2016 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPolygon : NSObject

@property (nonatomic, strong, readonly) NSArray * points;

- (instancetype)initWithPoints:(NSArray*)points;

- (ALPolygon *)polygonWithScale:(CGFloat)scale;

@end
