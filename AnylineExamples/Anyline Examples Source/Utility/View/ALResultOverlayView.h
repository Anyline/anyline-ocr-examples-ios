//
//  ALResultOverlayView.h
//  AnylineExamples
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ALTouchBlock)(void);

@interface ALResultOverlayView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;
- (NSString *)labelText;
- (void)setAlignment:(NSTextAlignment)textAlignment;
- (void)setTouchDownBlock:(ALTouchBlock)compblock;
- (void)addLabelOffset:(CGSize)offset;
- (void)setFontSize:(NSInteger)fontSize;
- (void)resizeAndCenter;
- (CGFloat)labelWidth;
- (UIFont *)labeFont;

@end
