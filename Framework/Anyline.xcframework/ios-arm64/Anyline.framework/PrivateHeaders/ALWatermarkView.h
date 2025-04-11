#import <UIKit/UIKit.h>

extern NSInteger const kALWatermarkHeight;
extern NSInteger const kALWatermarkWidth;
extern NSInteger const kALWatermarkSpacing;
extern NSString * const kTrialPopupTitle;
extern NSString * const kTrialPopupMessage;

typedef NS_ENUM(NSUInteger, ALWatermarkPosition) {
    ALPositionAbove  = 0,
    ALPositionInside = 1,
    ALPositionBelow  = 2,
};

@interface ALWatermarkView : UIView

- (instancetype)initWithCutout:(CGRect)cutoutFrame screenFrame:(CGRect)screenFrame error:(NSError **)error;

- (BOOL)isWatermarkOK:(CGRect)scanRect error:(NSError **)error;

- (void)positionWatermark:(CGRect)cutoutFrame screenFrame:(CGRect)screenFrame;

- (void)positionWatermark;

@property (nonatomic, assign) ALWatermarkPosition positioning;

@end
