//
//  ALToggleControl.h
//  AnylineExamples
//
//  Created by Philipp Müller on 29/01/2018.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALToggleControl : UIControl
    
@property (strong, nonatomic) IBInspectable UIImage       *imageWhenOff;
@property (strong, nonatomic) IBInspectable UIImage       *imageWhenOn;
@property (strong, nonatomic) IBInspectable UIImage       *backgroundImageWhenOff;
@property (strong, nonatomic) IBInspectable UIImage       *backgroundImageWhenOn;
    
@property (assign, nonatomic) IBInspectable BOOL          isOn;
    
@end
