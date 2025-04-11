#ifndef UIView_ALCustomUIFeedbackElement_h
#define UIView_ALCustomUIFeedbackElement_h

NS_ASSUME_NONNULL_BEGIN

@class ALUIFeedbackElementContentConfig;
@class ALUIFeedbackElementAttributesConfig;
@class ALUIFeedbackLogger;

/// Used to denote a feedback element UIView which can be added to the
/// ALUIFeedbackContainerView.
@protocol ALUIFeedbackVisualElement <NSObject>

- (void)applyContent:(ALUIFeedbackElementContentConfig * _Nullable)contentConfig logger:(ALUIFeedbackLogger * _Nullable)logger;

- (void)applyAttributes:(ALUIFeedbackElementAttributesConfig * _Nullable)attributesConfig logger:(ALUIFeedbackLogger * _Nullable)logger;

- (ALUIFeedbackElementAttributesConfig *)baseAttributes;

@end


@interface UITextView (ALUIFeedbackVisualElement) <ALUIFeedbackVisualElement> @end


@interface UIImageView (ALUIFeedbackVisualElement) <ALUIFeedbackVisualElement> @end


NS_ASSUME_NONNULL_END

#endif /* UIView_ALCustomUIFeedbackElement_h */
