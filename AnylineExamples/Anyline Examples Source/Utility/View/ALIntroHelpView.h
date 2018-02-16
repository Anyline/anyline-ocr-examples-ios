//
//  ALIntroHelpView.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 18/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALInfoHelpViewType) {
    ALInfoHelpViewTypeAll,
    ALInfoHelpViewTypeNone,
};

@protocol ALIntroHelpViewDelegate;

@interface ALIntroHelpView : UIView

@property (nonatomic, copy) UIBezierPath *cutoutPath;

@property (nonatomic, strong) UIImageView *sampleImageView;

@property (nonatomic, strong) NSString *introDescriptionText;

@property (nonatomic, assign) ALInfoHelpViewType introType;

@property (nonatomic, weak) id<ALIntroHelpViewDelegate> delegate;

@end

@protocol ALIntroHelpViewDelegate <NSObject>

@required

- (void)goButtonPressedOnIntroHelpView:(ALIntroHelpView *)introHelpView;

@end
