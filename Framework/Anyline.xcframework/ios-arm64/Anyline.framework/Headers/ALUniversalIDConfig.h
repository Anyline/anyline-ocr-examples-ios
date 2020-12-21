//
//  ALTemplateConfig.h
//  Anyline
//
//  Created by Angela Brett on 04.06.20.
//  Copyright © 2020 Anyline GmbH. All rights reserved.
//

#import "ALIDConfig.h"

/**
 *  The available ALUniversalIDLayoutTypes for the ALUniversalIDConfig
 */
typedef NS_ENUM(NSInteger, ALUniversalIDLayoutType) {
    /**
     * Used to set allowedLayouts for the layoutType DrivingLicense
     */
    ALUniversalIDLayoutTypeDrivingLicense = 0,
    /**
     * Used to set allowedLayouts for the layoutType MRZ
     */
    ALUniversalIDLayoutTypeMRZ = 1,
    /**
     * Used to set allowedLayouts for the layoutType IDFront
     */
    ALUniversalIDLayoutTypeIDFront = 2,
};

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

/**
 * Set the allowed layouts for a specific layoutType
 * e.g. which allowedLayouts are set for driving licenses
 *
 *  @param allowedLayouts an array that contains all enabled layouts
 *  @param layoutType which type of layouts do the "allowedLayouts" belong to
 *
 */
- (void)setAllowedLayouts:(NSArray<NSString *>* _Nullable)allowedLayouts
            forLayoutType:(ALUniversalIDLayoutType)layoutType;
/**
 * Set the allowed layouts for a specific layoutType
 * e.g. which allowedLayouts are set for driving licenses
 *
 *  @param allowedLayouts an array that contains all enabled layouts
 *  @param layoutType which type of layouts do the "allowedLayouts" belong to
 *
 *  @return returns a dictionary containing all enabled layouts for a specific layout type
 */
- (NSArray<NSString *> * _Nullable)getAllowedLayoutsForLayoutType:(ALUniversalIDLayoutType)layoutType;

/**
 * Set the allowed layouts for a specific layoutType
 * e.g. which allowedLayouts are set for driving licenses
 *
 *  @param allowedLayouts an array that contains all enabled layouts
 *
 *  @return returns a dictionary containing all enabled layouts for all layout types.
 */
- (NSDictionary<NSString *, NSArray<NSString *> *> *_Nullable)allowedLayoutsDictionary;
@end
