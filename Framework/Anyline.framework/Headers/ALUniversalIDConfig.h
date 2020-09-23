//
//  ALTemplateConfig.h
//  Anyline
//
//  Created by Angela Brett on 04.06.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import "ALIDConfig.h"

__attribute__((deprecated("please use ALUniversalIDFieldScanOptions instead")))
@interface ALTemplateFieldScanOptions: ALIDFieldScanOptions
@end

@interface ALUniversalIDFieldScanOptions: ALIDFieldScanOptions

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;
- (BOOL)hasField:(NSString *_Nonnull)fieldName;
- (void)addField:(NSString *_Nonnull)fieldName value:(ALFieldScanOption)scanOption;
- (void)removeField:(NSString *_Nonnull)fieldName;
- (NSArray<NSString *> *_Nonnull)fieldNames;
- (ALFieldScanOption)valueForField:(NSString *_Nonnull)fieldName;

@end

__attribute__((deprecated("please use ALUniversalIDFieldConfidences instead")))
@interface ALTemplateFieldConfidences : ALIDFieldConfidences
@end

@interface ALUniversalIDFieldConfidences: ALIDFieldConfidences

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;
- (BOOL)hasField:(NSString *_Nonnull)fieldName;
- (void)addField:(NSString *_Nonnull)fieldName value:(ALFieldConfidence)confidence;
- (void)removeField:(NSString *_Nonnull)fieldName;
- (ALFieldConfidence)valueForField:(NSString *_Nonnull)fieldName;
- (NSArray<NSString *> *_Nonnull)fieldNames;

@end

__attribute__((deprecated("please use ALUniversalIDConfig instead")))
@interface ALTemplateConfig : ALIDConfig
@end

@interface ALUniversalIDConfig : ALIDConfig

- (NSDictionary *_Nonnull)toStartVariableJsonDictionary;
- (NSDictionary *_Nullable)allowedLayoutsJsonDictionary;

@end
