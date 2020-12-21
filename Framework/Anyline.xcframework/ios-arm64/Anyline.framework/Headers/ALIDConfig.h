//
//  ALIDConfig.h
//  Anyline
//
//  Created by Philipp Müller on 30.05.18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALResult.h"

/**
 *  The possible field scan options for the ID Plugin
 */
typedef NS_ENUM(NSInteger, ALFieldScanOption) {
    /**
     * Field has to be found / returned.
     */
    ALMandatory = 0,
    /**
     * Field is optional.
     */
    ALOptional = 1,
    /**
     * Field will not be returned.
     */
    ALDisabled = 2,
    /**
     * Field will use the default behaviour.
     */
    ALDefault = 3
};

@interface ALIDFieldScanOptions: NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end

@interface ALIDFieldConfidences: NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end

@interface ALIDConfig : NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

/**
 *  ID Fields can be configured with enum ALFieldScanOption, which can set a particular field to mandatory, optional or disabled.
 */
@property (nonatomic, strong, nullable) ALIDFieldScanOptions *idFieldScanOptions;

@property (nonatomic, strong, nullable) ALIDFieldConfidences *idFieldConfidences;


/*
 *  Will set the minConfidences for all ALIDFieldConfidences, that are not set.
 *  If a ALIDFieldConfidences for a specific field is set,
 *  the minConfidences will not be used for this specific field.
 *
 *  Default value: -1
 */
@property (nonatomic) int minConfidence;

@end
