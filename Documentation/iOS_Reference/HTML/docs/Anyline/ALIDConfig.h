//
//  ALIDConfig.h
//  Anyline
//
//  Created by Philipp Müller on 30.05.18.
//  Copyright © 2018 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@class ALIDFieldScanOptions;

@interface ALIDConfig : NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

/**
 *  ID Fields can be configured with enum ALFieldScanOption. Which can set a partucialar field to mandatory, optional or disabled.
 */
@property (nonatomic, strong, nullable) ALIDFieldScanOptions *idFieldScanOptions;

@end

@interface ALIDFieldScanOptions: NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

@end

