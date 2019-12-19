//
//  UISwitch+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Angela Brett on 18.12.19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISwitch (ALExamplesAdditions)

//increases visibility when the switch is turned off in iOS 13 (where there is no white border as in iOS 12, but just a light background that is hard to see against the camera view) by darkening the background colour
- (void)useHighContrast;

@end

NS_ASSUME_NONNULL_END
