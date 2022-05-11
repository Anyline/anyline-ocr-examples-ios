//
//  ALTireConfig.h
//  AnylineIntegrationTests
//
//  Created by Renato Neves Ribeiro on 26.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBaseTireConfig.h"
#import "ALDefStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTireConfig : ALBaseTireConfig

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict
                                           error:(NSError * _Nullable * _Nullable)error;
/**
 *  Property to set a custom command file (path not string) to improve scanning for your use-case.
 *  Get in touch with Anyline to receive your custom command file.
 */
@property (nullable, nonatomic, strong) NSString *customCmdFilePath;
/**
 *  Property to set a custom command file (string not path) to improve scanning for your use-case.
 *  Get in touch with Anyline to receive your custum command file.
 */
@property (nullable, nonatomic, strong) NSString *customCmdFileString;

- (NSDictionary * _Nullable)startVariablesOrError:(NSError * _Nullable * _Nullable)error assetPath:(NSString *_Nullable)assetPath;

- (NSString * _Nullable)toJsonString;

@end

NS_ASSUME_NONNULL_END
