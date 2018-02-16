//
//  ALMeterSelectView.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 29/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALMeterSelectViewDelegate;

@interface ALMeterSelectView : UIView

@property (nonatomic, assign) NSInteger digitCount;

@property (nonatomic, weak) id<ALMeterSelectViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
                    maxDigits:(NSInteger)maxDigitCount
                    minDigits:(NSInteger)minDigitCount
                  startDigits:(NSInteger)startDigits;

@end

@protocol ALMeterSelectViewDelegate <NSObject>

@required
- (void)meterSelectView:(ALMeterSelectView *)meterSelectView
    didChangeDigitCount:(NSInteger)digitCount;

@end
