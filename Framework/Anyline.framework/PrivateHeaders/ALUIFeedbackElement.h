#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALUIFeedbackVisualElement;

@class AVAudioPlayer;
@class ALUIFeedbackElementConfig;
@class ALUIFeedbackElementContentConfig;
@class ALUIFeedbackElementAttributesConfig;
@class ALUIFeedbackElementApplyDetails;
@class ALUIFeedbackLogger;

@interface ALUIFeedbackElement : NSObject

@property (nonatomic, strong) ALUIFeedbackElementConfig *config;

@property (nonatomic, strong, nullable) UIView<ALUIFeedbackVisualElement> *view;

/// This is the layout guide associated with the view for this element (null for non-visual
/// elements). It is used to position the view with respect to the cutout (or another view)
@property (nonatomic, strong, nullable) UILayoutGuide *layoutGuide;

@property (nonatomic, strong, nullable) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong, nullable) ALUIFeedbackElementContentConfig *currentContent;

@property (nonatomic, strong, nullable) ALUIFeedbackElementAttributesConfig *currentAttributes;

@property (nonatomic, readonly) BOOL isViewElement;

@property (nonatomic, readonly) BOOL isSoundElement;

/// Late-evaluated constraints for UIImageView in which the image is
/// not initially known. Nil until called at run time and when there's
/// an image in the UIImageView.
@property (nonatomic, readonly, nullable) NSLayoutConstraint *preserveAspectRatioWidthCnst;

@property (nonatomic, readonly, nullable) NSLayoutConstraint *preserveAspectRatioHeightCnst;

- (instancetype)initWithConfig:(ALUIFeedbackElementConfig *)config logger:(ALUIFeedbackLogger *)logger;

/// Apply properties to the associated element (such as content, attributes). The change
/// can be initiated from "triggers" originating from the ScanPlugin.
/// - Parameter details: details about the change
- (void)applyDetails:(ALUIFeedbackElementApplyDetails *)details;

/// If the element is a visual one, this will create a matching pre-configured UIView.
- (UIView<ALUIFeedbackVisualElement> * _Nullable)makeFeedbackView;

/// Returns the NSLayoutContraints that define the position and size of the element's
/// view within the feedback container.
/// - Parameter sourceGuide: the UILayoutGuide of the source view (typically
/// the cutout view) referenced in the element config.
- (NSArray<NSLayoutConstraint *> *)viewConstraintsFromSourceGuide:(UILayoutGuide *)sourceGuide;

@end


NS_ASSUME_NONNULL_END
