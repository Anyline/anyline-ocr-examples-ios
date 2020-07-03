//
//  ALTemplateConfig.h
//  Anyline
//
//  Created by Angela Brett on 04.06.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import "ALIDConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTemplateFieldScanOptions: ALIDFieldScanOptions

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;
- (BOOL)hasField:(NSString *)fieldName;
- (void)addField:(NSString *)fieldName value:(ALFieldScanOption)scanOption;
- (void)removeField:(NSString *)fieldName;
- (NSArray<NSString *> *)fieldNames;
- (ALFieldScanOption)valueForField:(NSString *)fieldName;

@end

@interface ALTemplateFieldConfidences: ALIDFieldConfidences

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;
- (BOOL)hasField:(NSString *)fieldName;
- (void)addField:(NSString *)fieldName value:(ALFieldConfidence)confidence;
- (void)removeField:(NSString *)fieldName;
- (ALFieldConfidence)valueForField:(NSString *)fieldName;
- (NSArray<NSString *> *)fieldNames;

@end

@interface ALTemplateConfig : ALIDConfig

- (NSDictionary *)toStartVariableJsonDictionary;

@end

NS_ASSUME_NONNULL_END
