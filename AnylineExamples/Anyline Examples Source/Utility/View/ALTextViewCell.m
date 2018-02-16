//
//  ALTextViewCell.m
//  ExampleApi
//
//  Created by David Dengg on 15.02.16.
//  Copyright © 2016 9yards. All rights reserved.
//

#import "ALTextViewCell.h"

@interface ALTextViewCell ()
@property (nonatomic, strong) UITextView *mainText;
@property (nonatomic, strong) UILabel *headerLabel;
@end

@implementation ALTextViewCell {
    BOOL _setupUp;
    CGFloat _cellHeight;
}

- (void)placeViews {
    // Return if the cell already is set up
    if (_setupUp) return;
    _setupUp = YES;
    
    NSInteger iTopOffset    = 0;
    NSInteger iHeight       = 30;
    NSInteger iLeftDistance = 10;
    
    CGFloat coverSplit = self.bounds.size.width/3;
    CGFloat viewWitdth = self.bounds.size.width - iLeftDistance;
    
    { // Header
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftDistance , iTopOffset, viewWitdth-coverSplit, iHeight)];
        label.backgroundColor= [UIColor clearColor];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setText:@""];
        [self.contentView addSubview:label];
        self.headerLabel = label;
    }
    iTopOffset += 30;
    { // Main Text
        UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(iLeftDistance , iTopOffset, self.contentView.bounds.size.width - 2*iLeftDistance, iHeight)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:@""];
        [label setEditable:NO];
        [label setSelectable:YES];
        [label setScrollEnabled:NO];
        [self.contentView addSubview:label];
        self.mainText = label;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    _cellHeight = 0;
}

- (void)updateCellWithHeader:(NSString *)header mainText:(NSString *)mainText {
    [self placeViews];
    
    self.headerLabel.text = header;
    self.mainText.attributedText = [[NSAttributedString alloc] initWithString:@""];
    self.mainText.text = @"";
    [self appendMainText:mainText];
}

- (void)appendMainText:(NSString *)text {
    if( text.length == 0 ) return;
    NSAttributedString *mainAttrStr = [[NSAttributedString alloc] initWithString:text];
    [self appendAttributesString:mainAttrStr];
}

- (void)appendAttributesString:(NSAttributedString *)mainAttrStr {
    UITextView *textView = self.mainText;
    
    NSMutableAttributedString *text = [textView.attributedText mutableCopy];
    [text appendAttributedString:mainAttrStr];

    textView.attributedText = text;
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size  = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    _cellHeight = textView.frame.origin.y + textView.frame.size.height + 10;
}

- (void)appendHyperlink:(NSString *)text link:(NSString *)hyperlink {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                                           attributes:@{ NSLinkAttributeName: [NSURL URLWithString:hyperlink] }];
    
    [self appendAttributesString:attributedString];
}

- (CGFloat)cellHeight {
    return _cellHeight;
}

@end
