//
//  ALCheckbox.m
//  AnylineExamples
//
//  Created by AmirAnsari on 07.05.19.
//

#import "ALCheckbox.h"
#import "UIColor+ALExamplesAdditions.h"

IB_DESIGNABLE

@implementation ALCheckbox {
    UILabel *label;
    BOOL textIsSet;
}

@synthesize text = _text;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initInternals];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initInternals];
    }
    return self;
}
- (void) initInternals{
    _boxFillColor = [UIColor clearColor];
    _boxBorderColor = [UIColor AL_examplesBlue];
    _checkColor = [UIColor AL_examplesBlue];
    _isChecked = YES;
    _isEnabled = YES;
    //_showTextLabel = NO;
    textIsSet = NO;
    self.backgroundColor = [UIColor clearColor];
}
-(CGSize)intrinsicContentSize{
    /*
     if (_showTextLabel) {
     return CGSizeMake(50, 20);
     }
     else{*/
    return CGSizeMake(20, 20);
    //}
    
}

- (void)drawRect:(CGRect)rect {
    [_boxFillColor setFill];
    [_boxBorderColor setStroke];
    
    //User set flag to draw label
    
    //check if label has already been created... if not create a new label and set some basic styles
    if (!textIsSet) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/10, 0, self.frame.size.width, self.frame.size.width/10 - 4)];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        textIsSet = YES;
    }
    //style label
    label.font = _labelFont;
    label.textColor = _labelTextColor;
    label.text = self.text;
    
    //create enclosing box for checkbox
    UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.frame.size.width/12 - 4, self.frame.size.width/12 - 4) cornerRadius:self.frame.size.width/100];
    boxPath.lineWidth = 2;
    [boxPath fill];
    [boxPath stroke];
    
    //if control is checked draw checkmark
    if (_isChecked == YES) {
        UIBezierPath *checkPath = [UIBezierPath bezierPath];
        checkPath.lineWidth = 2;
        
        [checkPath moveToPoint:CGPointMake(boxPath.bounds.size.width/10, boxPath.bounds.size.height/2)];
        [checkPath addLineToPoint:CGPointMake(boxPath.bounds.size.width * 45/100, boxPath.bounds.size.height * 95/100)];
        [checkPath addLineToPoint:CGPointMake(boxPath.bounds.origin.x + boxPath.bounds.size.width, boxPath.bounds.origin.y)];
        
        [_checkColor setStroke];
        [checkPath stroke];
    }
    
    
    //check if control is enabled... lower alpha if not and disable interaction
    if (_isEnabled == YES) {
        self.alpha = 1.0f;
        self.userInteractionEnabled = YES;
    }
    else {
        self.alpha = 0.6f;
        self.userInteractionEnabled = NO;
    }
    
    [self setNeedsDisplay];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setChecked:!_isChecked];
    return true;
}

-(void)setChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    [self setNeedsDisplay];
}
-(void)setEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
    [self setNeedsDisplay];
}

/*
 -(void)setText:(NSString *)stringValue{
 _text = stringValue;
 [self setNeedsDisplay];
 }
 */

@end
