//
//  ALCheckbox.h
//  AnylineExamples
//
//  Created by AmirAnsari on 07.05.19.
//

#import <UIKit/UIKit.h>


@interface ALCheckbox : UIControl

-(void)setChecked:(BOOL)isChecked;
-(void)setEnabled:(BOOL)isEnabled;
-(void)setText:(NSString *)stringValue;

@property IBInspectable UIColor *checkColor;
@property IBInspectable UIColor *boxFillColor;
@property IBInspectable UIColor *boxBorderColor;
@property IBInspectable UIFont *labelFont;
@property IBInspectable UIColor *labelTextColor;

@property IBInspectable BOOL isEnabled;
@property IBInspectable BOOL isChecked;
@property IBInspectable BOOL showTextLabel;
@property (nonatomic, strong) IBInspectable  NSString *text;

@end
