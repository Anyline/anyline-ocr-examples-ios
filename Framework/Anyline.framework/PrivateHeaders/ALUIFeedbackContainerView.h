#import <UIKit/UIKit.h>
#import "ALEvent.h"
#import <Anyline/Anyline-Swift.h>


NS_ASSUME_NONNULL_BEGIN

@class ALUIFeedbackConfig;
@class ALUIFeedbackElementConfig;
@class ALUIFeedbackContainerView;

@protocol ALCustomUIFeedbackViewDelegate <NSObject>

- (void)customUIFeedbackView:(ALUIFeedbackContainerView *)feedbackView
     tappedElementWithConfig:(ALUIFeedbackElementConfig *)elementConfig;

@end

/// Object/View that displays custom feedback based on the scan view plugin
/// configuration.
@protocol ALCustomUIFeedbackContainer <NSObject>

// For now assume that visual feedback view's the same frame to this view,
// otherwise the values passed here aren't correct.
- (void)setCutoutFrame:(CGRect)frame;

@property (nonatomic, copy) void (^scanInfoEventReceived)(ALEvent *);

@property (nonatomic, copy) void (^scanRunSkippedEventReceived)(ALEvent *);

@property (nonatomic, copy) void (^scanStartedEventReceived)(ALEvent *);

@property (nonatomic, copy) void (^scanStoppedEventReceived)(ALEvent *);

@property (nonatomic, weak) id<ALCustomUIFeedbackViewDelegate> delegate;

@end


@interface ALUIFeedbackContainerView: UIView <ALCustomUIFeedbackContainer>

@property (nonatomic, weak, nullable) ALUIFeedbackLogger *logger;

- (instancetype)initWithFrame:(CGRect)frame 
                       config:(ALUIFeedbackConfig *)config
                       logger:(ALUIFeedbackLogger * _Nullable)logger;

@end


NS_ASSUME_NONNULL_END
