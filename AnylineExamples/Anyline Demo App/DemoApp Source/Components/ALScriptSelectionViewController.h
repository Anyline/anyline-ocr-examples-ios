//
//  ALScriptSelectionViewController.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 18.05.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ALScriptSelectionDelegate;

@interface ALScriptSelectionViewController : UIViewController

@property (nonatomic, assign) BOOL isArabicScript;
@property (copy) void (^blockForAfterViewDismissal)(void);
@property (nonatomic, weak) id<ALScriptSelectionDelegate> delegate;

+ (UIBarButtonItem*)createBarButtonForScriptSelection:(UIViewController *)viewController;

@end

@protocol ALScriptSelectionDelegate <NSObject>

@required
-(void)changeScript:(BOOL)isArabic;

@end

NS_ASSUME_NONNULL_END
