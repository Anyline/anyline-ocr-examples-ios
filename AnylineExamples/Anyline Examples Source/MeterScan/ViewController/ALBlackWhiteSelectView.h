//
//  ALMeterSelectView.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 29/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALBWReadingType) {
    ALBWReadingTypeBlackText,
    ALBWReadingTypeWhiteText,
};

@protocol ALBlackWhiteSelectViewDelegate;

@interface ALBlackWhiteSelectView : UIView

@property (nonatomic, assign) ALBWReadingType activeSelection;

@property (nonatomic, weak) id<ALBlackWhiteSelectViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame digits:(NSInteger)digits activeSelection:(ALBWReadingType)activeSelection;

@end

@protocol ALBlackWhiteSelectViewDelegate <NSObject>

@required
- (void)blackWhiteSelectView:(ALBlackWhiteSelectView *)blackWhiteSelectView
               didChangeMode:(ALBWReadingType)readingType;

@end
