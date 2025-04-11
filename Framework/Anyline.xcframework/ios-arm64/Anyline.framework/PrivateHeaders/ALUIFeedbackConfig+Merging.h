#import <Foundation/Foundation.h>
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

// you can merge two objects, provided they are both are non null and of the type of
// the calling class.
// when merging attributes of both sides into the result, those of the left object would be
// used if the right object has non-null values for those attributes.
@protocol ALUIFeedbackMergeable <NSObject>

+ (id _Nullable)mergedFrom:(id _Nullable)left and:(id _Nullable)right;

@end


@interface ALOverlayDimensionConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALOverlayScaleConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALOverlayConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALUIFeedbackElementTriggerConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALUIFeedbackElementTriggerWhenRunSkippedConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALUIFeedbackElementTriggerWhenScanInfoConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALRunSkippedWhen (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALScanInfoWhen (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALUIFeedbackElementAttributesConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end

@interface ALUIFeedbackElementContentConfig (ALUIFeedbackConfigMerging) <ALUIFeedbackMergeable> @end


NS_ASSUME_NONNULL_END
