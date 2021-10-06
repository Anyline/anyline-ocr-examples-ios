//
//  ALIDCountryHelper.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 08.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum scriptType {
    ALScriptTypeLatin = 0,
    ALScriptTypeArabic,
    ALScriptTypeCyrillic
} ALScriptType;

@interface ALIDCountryHelper : NSObject

@property (nonatomic, assign) ALScriptType scriptType;

// when no script type was given, it is assumed to be in Latin
- (instancetype)init;

- (instancetype)initWithScriptType:(ALScriptType)scriptType;

// dictionary structured as defined in the JSON (Geo. Region -> [Countries])
- (NSDictionary<NSString*, NSArray<NSString*>*> *)idTemplateList;

// list of countries in idTemplateList, flatmapped
- (NSArray<NSString *> *)defaultTemplates;

// array of codes corresponding to selected countries
- (NSArray<NSString *> *)templatesForCountryNames:(NSArray<NSString *>*)names;


@end

NS_ASSUME_NONNULL_END
