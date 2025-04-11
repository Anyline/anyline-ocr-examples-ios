#import <UIKit/UIKit.h>
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ALUIFeedbackVisualElement;
@class AVAudioPlayer;
@class ALUIFeedbackElementTriggerWhenRunSkippedConfig;
@class ALUIFeedbackElementApplyDetails;
@class ALUIFeedbackLogger;

@interface ALUIFeedbackElementConfig (ALPrivateExtras)

@property (nonatomic, readonly) NSString *globalIdentifier;

- (UIImageView<ALUIFeedbackVisualElement> *)getImageViewWithLogger:(ALUIFeedbackLogger * _Nullable)logger;

- (UITextView<ALUIFeedbackVisualElement> *)getTextViewWithLogger:(ALUIFeedbackLogger * _Nullable)logger;

- (id)JSONObject;

- (ALUIFeedbackElementApplyDetails *)applyDetailsForRunSkippedTrigger:(ALUIFeedbackElementTriggerWhenRunSkippedConfig *)runSkippedTrigger;

- (ALUIFeedbackElementApplyDetails *)applyDetailsForScanInfoTrigger:(ALUIFeedbackElementTriggerWhenScanInfoConfig *)scanInfoTrigger;

@end

NS_ASSUME_NONNULL_END
