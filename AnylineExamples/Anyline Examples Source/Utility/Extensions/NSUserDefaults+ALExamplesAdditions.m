//
//  NSUserDefaults+ALExamplesAdditions.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 05/06/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "NSUserDefaults+ALExamplesAdditions.h"

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

@end
