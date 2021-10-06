//
//  ALScriptSelectionViewController.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 18.05.21.
//

#import <UIKit/UIKit.h>
#import "ALIDCountryHelper.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ALScriptSelectionDelegate;

@interface ALScriptSelectionViewController : UIViewController

@property (nonatomic, assign) ALScriptType scriptType;
@property (copy) void (^blockForAfterViewDismissal)(void);
@property (nonatomic, weak) id<ALScriptSelectionDelegate> delegate;

+ (UIBarButtonItem*)createBarButtonForScriptSelection:(UIViewController *)viewController;

@end

@protocol ALScriptSelectionDelegate <NSObject>

@required
- (void)changeScript:(ALScriptType)scriptType;

@end

NS_ASSUME_NONNULL_END
