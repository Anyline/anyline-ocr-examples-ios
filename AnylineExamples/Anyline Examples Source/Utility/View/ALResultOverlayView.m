//
//  ALResultOverlayView.m
//  AnylineExamples
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ALResultOverlayView.h"

@interface ALResultOverlayView ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) ALTouchBlock touchBlock;
@property (nonatomic, assign) CGSize offset;
@end

@implementation ALResultOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        [self addSubview:self.imageView];
        
        CGFloat lx = 250;
        CGFloat ly = 160;
        
        CGFloat rx = self.imageView.center.x - lx/2;
        CGFloat ry = self.imageView.center.y - ly/2;
        
        CGFloat width  = lx;
        CGFloat height = ly;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(rx, ry, width, height)];
        self.label.center        = self.imageView.center;
        self.label.font          = [UIFont boldSystemFontOfSize:20];
        self.label.textColor     = [UIColor blackColor];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.lineBreakMode = NSLineBreakByClipping;
        [self addSubview:self.label];
    }
    return self;
}

- (void)addLabelOffset:(CGSize)offset {
    _offset = offset;
    _label.center = CGPointMake(_label.center.x + offset.width,
                                _label.center.y + offset.height);
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setFontSize:(NSInteger)fontSize {
    self.label.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (void)setText:(NSString *)text {
    self.label.text = [text uppercaseString];
}

- (void)setAlignment:(NSTextAlignment)textAlignment {
    self.label.textAlignment = textAlignment;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBlock();
}

- (void)setTouchDownBlock:(ALTouchBlock)compblock {
    _touchBlock = compblock;
}

- (CGFloat)labelWidth {
    return self.label.bounds.size.width;
}

- (NSString *)labelText {
    return self.label.text;
}

- (void)resizeAndCenter {
    [self.label sizeToFit];
    self.label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (UIFont *)labeFont {
    return self.label.font;
}

@end
