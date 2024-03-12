//
//  NSUserDefaults+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 05/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "NSUserDefaults+ALExamplesAdditions.h"

NSString * const DATA_POLICY_ACCEPTED = @"dataPrivacyPolicyAccepted";
NSString * const SECRET_DEV_MODE_ENABLED = @"secretDevModeEnabled";
NSString * const SECRET_DEV_MODE_UNLOCKED = @"secretDevModeUnlocked";
NSString * const HAS_REGISTERED = @"hasRegistered";
NSString * const kSelectedSymbologies = @"selectedSymbologies";

@implementation NSUserDefaults (ALExamplesAdditions)

+ (BOOL)AL_createEntryOnce:(NSString*)entry {
    BOOL defaultsEntry = [[NSUserDefaults standardUserDefaults] boolForKey:entry];
    if(!defaultsEntry) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:entry];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

+ (void)AL_setMail:(NSString *)mail {
    [[NSUserDefaults standardUserDefaults] setObject:mail forKey:@"anylineUserMail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)AL_getMail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"anylineUserMail"];
}

+ (void)AL_setFirstName:(NSString *)firstName {
    [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"anylineFirstName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)AL_getFirstName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"anylineFirstName"];
}

+ (void)AL_setLastName:(NSString *)lastName {
    [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:@"anylineLastName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)AL_getLastName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"anylineLastName"];
}

+ (void)AL_setGeography:(NSString *)geography {
    [[NSUserDefaults standardUserDefaults] setObject:geography forKey:@"anylineGeography"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)AL_getGeography {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"anylineGeography"];
}

+ (void)AL_incrementScanCount {
    [[NSUserDefaults standardUserDefaults] setInteger:[self AL_scanCount] + 1
                                               forKey:@"anylineScanCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)AL_scanCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"anylineScanCount"];
}

+ (void)resetScanCount {
    [[NSUserDefaults standardUserDefaults] setInteger:0
                                               forKey:@"anylineScanCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)AL_dataPolicyAccepted {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:DATA_POLICY_ACCEPTED]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:DATA_POLICY_ACCEPTED];
}

+ (void)AL_setDataPolicyAccepted:(BOOL)wasAccepted {
    [[NSUserDefaults standardUserDefaults] setBool:wasAccepted forKey:DATA_POLICY_ACCEPTED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)AL_secretDevModeEnabled {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SECRET_DEV_MODE_ENABLED]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:SECRET_DEV_MODE_ENABLED];
}

+ (void)AL_setSecretDevModeEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:SECRET_DEV_MODE_ENABLED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)AL_secretDevModeUnlocked {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SECRET_DEV_MODE_UNLOCKED]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:SECRET_DEV_MODE_UNLOCKED];
}

+ (void)AL_secretDevModeUnlocked:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:SECRET_DEV_MODE_UNLOCKED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)AL_hasRegistered {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:HAS_REGISTERED]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:HAS_REGISTERED];
}

+ (void)AL_setHasRegistered:(BOOL)wasAccepted {
    [[NSUserDefaults standardUserDefaults] setBool:wasAccepted forKey:HAS_REGISTERED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<NSString *> *)AL_selectedSymbologiesForBarcode {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSelectedSymbologies];
}

+ (void)AL_setSelectedSymbologiesForBarcode:(NSArray<NSString *> *)selectedSymbologies {
    [[NSUserDefaults standardUserDefaults] setValue:selectedSymbologies forKeyPath:kSelectedSymbologies];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
