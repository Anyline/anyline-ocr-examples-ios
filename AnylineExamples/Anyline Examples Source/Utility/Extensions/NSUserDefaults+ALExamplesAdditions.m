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

@implementation NSUserDefaults (ALExamplesAdditions)

+ (BOOL)AL_reportingEnabled {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"anylineReportingEnabled"]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"anylineReportingEnabled"];
}

+ (void)AL_setReportingEnabled:(BOOL)reportingEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:reportingEnabled forKey:@"anylineReportingEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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

@end
