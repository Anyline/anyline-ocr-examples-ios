//
//  ALIntroHelpView.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 18/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALIntroHelpViewElectricDelegate;

typedef NS_ENUM(NSUInteger, ALIntroHelpViewMode) {
    ALIntroHelpViewModeBW = 0,
    ALIntroHelpViewModeDigits = 1,
    ALIntroHelpViewModeAnalog = 2,
    ALIntroHelpViewModeAutoAnalogDigital = 3,
    ALIntroHelpViewModeDialMeter = 4,
    ALIntroHelpViewModeSerialNumber = 5,
    ALIntroHelpViewModeNone = 6
};

@interface ALIntroHelpViewElectric : UIView

@property (nonatomic, strong) UIImageView *sampleImageView;

@property (nonatomic, weak) id<ALIntroHelpViewElectricDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame cutoutPath:(UIBezierPath *)cutoutPath type:(ALIntroHelpViewMode)widgetType;

@end

@protocol ALIntroHelpViewElectricDelegate <NSObject>

@required
- (void)goButtonPressedOnIntroHelpView:(ALIntroHelpViewElectric *)introHelpView;
@end
