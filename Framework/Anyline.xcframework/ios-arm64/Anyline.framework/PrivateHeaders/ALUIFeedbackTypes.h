#import <Foundation/Foundation.h>

@class AVAudioPlayer;
@class ALEvent, ALScanInfoWhen, ALRunSkippedWhen, ALUIFeedbackElementConfig;
@class ALUIFeedbackElementContentConfig, ALUIFeedbackElementAttributesConfig;
@class ALUIFeedbackElementApplyDetails, ALUIFeedbackElementTriggerWhenScanInfoConfig, ALUIFeedbackElementTriggerWhenRunSkippedConfig;

@protocol ALUIFeedbackVisualElement;


NS_ASSUME_NONNULL_BEGIN

/// A lightweight object containing layout constraints for each CGFloat of a CGRect frame
@interface ALLayoutRectConstraints: NSObject

@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *left;
@property (nonatomic, strong) NSLayoutConstraint *width;
@property (nonatomic, strong) NSLayoutConstraint *height;

@property (nonatomic, readonly) NSArray<NSLayoutConstraint *> *asList;

@end


// note: not ALEvent types.
@interface ALUIFeedbackScanInfoEvent: NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

// can be null, as there are types that we don't support right now
+ (ALUIFeedbackScanInfoEvent * _Nullable)fromALEvent:(ALEvent *)event;
+ (ALUIFeedbackScanInfoEvent *)fromALScanInfoWhen:(ALScanInfoWhen *)infoScanWhen;

@end


// note: not ALEvent types.
@interface ALUIFeedbackRunSkippedEvent: NSObject <NSCopying>

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSNumber *errorCode;
@property (nonatomic, copy) NSNumber *lineNo;

+ (ALUIFeedbackRunSkippedEvent *)fromALEvent:(ALEvent *)event;
+ (ALUIFeedbackRunSkippedEvent *)fromALRunSkippedWhen:(ALRunSkippedWhen *)runSkipWhen;

@end


@interface ALUIFeedbackElementApplyDetails : NSObject

@property (nonatomic, copy) NSString *elementIdentifier;
@property (nonatomic, strong, nullable) ALUIFeedbackElementContentConfig *applyContent;
@property (nonatomic, strong, nullable) ALUIFeedbackElementAttributesConfig *applyAttributes;

@end

NS_ASSUME_NONNULL_END
