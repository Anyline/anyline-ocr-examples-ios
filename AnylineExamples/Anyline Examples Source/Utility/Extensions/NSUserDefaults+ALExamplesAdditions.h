//
//  NSUserDefaults+ALExamplesAdditions.h
//  AnylineExamples
//
//  Created by Daniel Albertini on 05/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ALExamplesAdditions)

+ (BOOL)AL_createEntryOnce:(NSString *)entry;

+ (BOOL)AL_dataPolicyAccepted;
+ (void)AL_setDataPolicyAccepted:(BOOL)wasAccepted;

+ (BOOL)AL_secretDevModeEnabled;
+ (void)AL_setSecretDevModeEnabled:(BOOL)enabled;

+ (BOOL)AL_secretDevModeUnlocked;
+ (void)AL_secretDevModeUnlocked:(BOOL)enabled;

+ (BOOL)AL_hasRegistered;
+ (void)AL_setHasRegistered:(BOOL)wasAccepted;

+ (void)AL_setMail:(NSString *)mail;

+ (NSString *)AL_getMail;

+ (void)AL_incrementScanCount;

+ (NSInteger)AL_scanCount;

+ (void)resetScanCount;

@end
