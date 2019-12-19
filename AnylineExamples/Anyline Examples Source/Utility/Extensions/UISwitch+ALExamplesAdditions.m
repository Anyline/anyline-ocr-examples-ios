//
//  UISwitch+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Angela Brett on 18.12.19.
//

#import "UISwitch+ALExamplesAdditions.h"

@implementation UISwitch (ALExamplesAdditions)

- (void)useHighContrast {
    if (@available(iOS 13.0, *)) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.layer.cornerRadius = 31.0/2.0;
        //alternatively, we could bring back the border, but let's let iOS 13 look like iOS 13.
        /*self.enableBarcodeSwitch.layer.borderColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0].CGColor;
        self.enableBarcodeSwitch.layer.borderWidth = 1.5;*/
    }
}

@end
