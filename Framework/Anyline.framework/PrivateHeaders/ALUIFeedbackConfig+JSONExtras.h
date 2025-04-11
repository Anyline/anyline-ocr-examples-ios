#ifndef ALUIFeedbackConfig_ALUIFeedbackConfigJSONExtras_h
#define ALUIFeedbackConfig_ALUIFeedbackConfigJSONExtras_h

// NOTE: does not have a .m counterpart

NS_ASSUME_NONNULL_BEGIN

// Implement this protocol only on classes defined in ALUIFeedbackConfig.h
// By doing this, you gain access to the internal implementation for these methods
// which are define in ALUIFeedbackConfig.m.
@protocol ALUIFeedbackConfigJSON <NSObject>

- (NSDictionary *)JSONDictionary;

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@end


@interface ALOverlayConfig (ALUIFeedbackConfigJSONExtras) <ALUIFeedbackConfigJSON> @end

@interface ALUIFeedbackElementTriggerConfig (ALUIFeedbackConfigJSONExtras) <ALUIFeedbackConfigJSON> @end

@interface ALUIFeedbackPresetDefinitionConfig (ALUIFeedbackConfigJSONExtras) <ALUIFeedbackConfigJSON> @end

@interface ALUIFeedbackPresetAttributeConfig (ALUIFeedbackConfigJSONExtras) <ALUIFeedbackConfigJSON> @end

@interface ALUIFeedbackPresetConfig (ALUIFeedbackConfigJSONExtras) <ALUIFeedbackConfigJSON> @end

NS_ASSUME_NONNULL_END

#endif /* ALUIFeedbackConfig_ALUIFeedbackConfigJSONExtras_h */
