#import <Foundation/Foundation.h>
#import <Anyline/Anyline-Swift.h>
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALUIFeedbackConfig (ALPresetHelper)

- (BOOL)expandPresetsWithLogger:(ALUIFeedbackLogger * _Nullable)logger
                          error:(NSError * _Nullable * _Nullable)error;

- (BOOL)expandPresets;

+ (BOOL)checkAttributesForPreset:(NSString *)presetName
                   requiredAttrs:(NSArray<ALUIFeedbackPresetDefinitionAttributeConfig *> * _Nullable)requiredAttrs
                   providedAttrs:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)providedAttrs
                          logger:(ALUIFeedbackLogger * _Nullable)logger
                           error:(NSError * _Nullable * _Nullable)error;

@end


@interface ALUIFeedbackElementConfig (ALPresetHelper)

- (NSArray<ALUIFeedbackElementConfig *> * _Nullable)expandWithPresetDefinitions:(NSDictionary<NSString *, ALUIFeedbackPresetDefinitionConfig *> *)presetDefinitions
                                                               presetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)presetAttributes
                                                               presetsTraversed:(NSArray<NSString *> *)presetsTraversed
                                                                         logger:(ALUIFeedbackLogger * _Nullable)logger
                                                                          error:(NSError * _Nullable * _Nullable)error;

@end


@interface ALOverlayConfig (ALPresetHelper)

- (ALOverlayConfig * _Nullable)expandWithPresetDefinitions:(NSDictionary<NSString *, ALUIFeedbackPresetDefinitionConfig *> *)presetDefinitions
                                          presetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)presetAttributes
                                          presetsTraversed:(NSArray<NSString *> *)presetsTraversed
                                                    logger:(ALUIFeedbackLogger * _Nullable)logger
                                                     error:(NSError * _Nullable * _Nullable)error;

@end


@interface ALUIFeedbackElementTriggerConfig (ALPresetHelper)

- (ALUIFeedbackElementTriggerConfig * _Nullable)expandWithPresetDefinitions:(NSDictionary<NSString *, ALUIFeedbackPresetDefinitionConfig *> *)presetDefinitions
                                                           presetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)presetAttributes
                                                           presetsTraversed:(NSArray<NSString *> *)presetsTraversed
                                                                     logger:(ALUIFeedbackLogger * _Nullable)logger
                                                                      error:(NSError * _Nullable * _Nullable)error;

@end


@interface ALUIFeedbackPresetDefinitionConfig (ALPresetHelper)

- (ALOverlayConfig * _Nullable)overlayFromPresetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> * _Nullable)presetAttributes
                                                    logger:(ALUIFeedbackLogger * _Nullable)logger
                                                     error:(NSError * _Nullable * _Nullable)error;

- (ALOverlayConfig * _Nullable)overlayFromPresetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> * _Nullable)presetAttributes;

- (ALUIFeedbackElementTriggerConfig * _Nullable)triggerFromPresetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> * _Nullable)presetAttributes
                                                                     logger:(ALUIFeedbackLogger * _Nullable)logger
                                                                      error:(NSError * _Nullable * _Nullable)error;

- (ALUIFeedbackElementTriggerConfig * _Nullable)triggerFromPresetAttributes:(NSArray<ALUIFeedbackPresetAttributeConfig *> * _Nullable)presetAttributes;

@end


@interface ALUIFeedbackPresetAttributeConfig (ALPresetHelper)

- (ALUIFeedbackPresetAttributeConfig *)withVariablesResolvedUsingLookup:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)lookupAttributes;

@end


@interface ALUIFeedbackPresetConfig (ALPresetHelper)

- (NSArray<ALUIFeedbackPresetAttributeConfig *> *)attributesMergedFrom:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)lookupAttributes
                                                                logger:(ALUIFeedbackLogger * _Nullable)logger
                                                                 error:(NSError * _Nullable * _Nullable)error;

@end


@interface NSString (ALPresetHelper)

- (NSString *)resolveToAttributeVariables:(NSArray<ALUIFeedbackPresetAttributeConfig *> *)attributeConfigs;

@end


NS_ASSUME_NONNULL_END
