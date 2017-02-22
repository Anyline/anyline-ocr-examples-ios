//
//  ALScrabbleLabel.m
//  ExampleApi
//
//  Created by David Dengg on 14.02.16.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALScrabbleLabel.h"
/*
 * This class contains a scrabble letter
 */
@interface ALScrabbleTile : UIView
@end

@implementation ALScrabbleTile {
    UIBezierPath *_path;
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font andLetter:(NSString *)letter {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = letter;
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _path  = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 2, 2)
                                   byRoundingCorners:UIRectCornerAllCorners
                                         cornerRadii:CGSizeMake(4, 4)];
    
    [[UIColor colorWithRed:(float)250 / 255.0 green:(float)238 / 255.0 blue:(float)147 / 255.0 alpha:1.0] setFill];
    [_path fill];
}

@end

/*
 * This is the main label. It iterates and adds the scrabble tiles to itself
 */
@implementation ALScrabbleLabel {
    NSMutableArray *_tileViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setText:(NSString *)text {
    NSInteger kTileSize = 45;
    // Remove all previeously shown letters
    text = [text uppercaseString];
    for (UIView *v in _tileViews) {
        [v removeFromSuperview];
    }
    
    CGFloat offset = MAX((self.bounds.size.height / 2) - kTileSize/2 , 0);
    CGFloat xOffset = self.bounds.size.width/2 - (text.length * (kTileSize))/2;
    
    UIFont *font = [UIFont systemFontOfSize:30];
    // Add the string letter by letter    
    for (int i = 0; i<text.length; i++) {
        NSInteger letterPos = (kTileSize * i);
        NSString *letter = [text substringWithRange:NSMakeRange(i, 1)];
        ALScrabbleTile *tile = [[ALScrabbleTile alloc] initWithFrame:CGRectMake(xOffset + letterPos, offset, kTileSize, kTileSize)
                                                                font:font
                                                           andLetter:letter];
        [self addSubview:tile];
        [_tileViews addObject:tile];
    }
}

@end
