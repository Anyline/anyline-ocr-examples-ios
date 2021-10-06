//
//  ALIDCountryHelper.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 08.12.20.
//

#import "ALIDCountryHelper.h"

NSString * const kTemplateTypeName = @"template_type_and_region_mapping";
NSString * const kTemplateTypeNameArabic = @"template_type_and_region_mapping_arabic";
NSString * const kTemplateTypeNameCyrillic = @"template_type_and_region_mapping_cyrillic";

@interface ALIDCountryHelper ()

@property (nonatomic, strong) NSDictionary *cachedTemplateDict;

@end

@implementation ALIDCountryHelper

- (instancetype)init {
    if (self = [self initWithScriptType:ALScriptTypeLatin]) {}
    return self;
}

- (instancetype)initWithScriptType:(ALScriptType)scriptType {
    if (self = [super init]) {
        _scriptType = scriptType;
        [self cacheTemplateDict];
    }
    return self;
}

- (void)setScriptType:(ALScriptType)scriptType {
    BOOL isDifferentScriptType = _scriptType != scriptType;
    _scriptType = scriptType;
    if (isDifferentScriptType) {
        [self cacheTemplateDict];
    }
}

- (void)cacheTemplateDict {
    NSString *resourceName = [[self class] resourceNameForScriptType:_scriptType];
    _cachedTemplateDict = [[self class] loadedJSONFileName:resourceName];
}

+ (NSDictionary<NSString *, NSDictionary<NSString *, NSArray<NSString *>*>*> *)loadedJSONFileName:(NSString *)resourceName {
    NSError *error = nil;
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:jsonFilePath];
    return [NSJSONSerialization JSONObjectWithData:jsonFile
                                           options:NSJSONReadingMutableContainers
                                             error:&error];
}

+ (NSString *)resourceNameForScriptType:(ALScriptType)scriptType {
    switch (scriptType) {
        case ALScriptTypeLatin: return kTemplateTypeName;
        case ALScriptTypeArabic: return kTemplateTypeNameArabic;
        case ALScriptTypeCyrillic: return kTemplateTypeNameCyrillic;
    }
}

- (NSDictionary<NSString *, NSArray<NSString *> *> *)idTemplateList {
    NSDictionary *templateDict = _cachedTemplateDict;
    NSMutableDictionary<NSString*,NSArray<NSString*>*> *templateList = [@{} mutableCopy];
    [templateDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSDictionary<NSString *, NSArray<NSString *>*> *  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *sortedArray = [obj.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        templateList[key] = sortedArray;
    }];
    return templateList;
}

- (NSArray<NSString *> *)defaultTemplates {
    NSDictionary<NSString*, NSArray<NSString*>*> *templateList = [self idTemplateList];
    
    NSMutableArray<NSString *> *defaultTemplates = [@[] mutableCopy];
    [templateList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        [defaultTemplates addObjectsFromArray:obj];
    }];
    
    return defaultTemplates;
}

- (NSArray<NSString *>*)templatesForCountryNames:(NSArray<NSString *>*)names {
    NSMutableArray<NSString *> *templates = [@[] mutableCopy];
    
    NSDictionary *templateDict = _cachedTemplateDict;
    
    __block int templateCount = 0;
    [templateDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,NSArray<NSString *> *> * _Nonnull obj, BOOL * _Nonnull stop) {
        templateCount += obj.allKeys.count;
        for (NSString *countryName in obj.allKeys) {
            for (NSString *wanteCountry in names) {
                if ([countryName isEqualToString:wanteCountry]) {
                    [templates addObjectsFromArray:obj[countryName]];
                }
            }
        }
    }];
    
    if (names.count == templateCount) {
        return @[];
    }
    
    return templates;
}

@end
