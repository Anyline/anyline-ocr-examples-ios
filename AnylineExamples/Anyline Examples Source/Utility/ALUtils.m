//
//  ALUtils.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "ALUtils.h"

#import "Reading.h"
#import "Customer.h"

#import "NSTimer+ALExamplesAdditions.h"

@interface ALUtils () <UIAlertViewDelegate>

@property (weak, nonatomic) UIViewController *viewControllerForEmailWindow;

@end

@implementation ALUtils

//_singleton(sharedUtils)

+ (instancetype)sharedInstance {
    static ALUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ALUtils alloc] init];

    });
    return sharedInstance;
}

#pragma mark - Read Bundle files
+ (NSDictionary *)getInfoPlistWithName:(NSString*)name {
    NSString *stringPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:stringPath];
    NSAssert(dictionary, @"ERROR - missing %@.plist file", name);
    return dictionary;
}

#pragma mark - Mocked Reading Sync.
+ (void)syncReading:(Reading *)reading withBlock:(ALSyncBlock)block {
    // check if it's enabled for this target
    if ([InfoPlist[@"NYSAPReportingEnabled"] boolValue]) {
        //E.g. create json string with data from reading
        //Send the json file via URL request to your URL
        //Return block(YES) on success and block(NO) on failure.
        block(YES);
    }
    // otherwise just fake it, by calling the callback with YES after 1 second
    else {
        ExecuteAfter(1, ^{
            block(YES);
        });
    }
}

+ (BOOL)isScannerTypeImplemented:(ALScannerType)scannerType {
    return (scannerType != ALScannerTypeUnknown);
}

#pragma mark - Private

+ (ALFlashMode)defaultFlashMode {
    NSString *flashModeString = InfoPlist[@"NYDefaultFlashMode"];

    if ([flashModeString isEqualToString:@"auto"]) {
        return ALFlashModeAuto;
    } else if ([flashModeString isEqualToString:@"manual"]) {
        return ALFlashModeManual;
    } else if ([flashModeString isEqualToString:@"none"]) {
        return ALFlashModeNone;
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown flash mode: %@. Supported are: auto, manual, none", flashModeString] userInfo:nil];
    }
    return ALFlashModeAuto;
}

void _VerifyAnylineModuleSetup(BOOL success, NSError *error) {
    if (!success) {
        [[[UIAlertView alloc] initWithTitle:@"Setup Error"
                                    message:error.debugDescription
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"button")
                          otherButtonTitles:nil] show];
    }
}
   
    
    
#pragma mark - Delayed execution
    
static NSMutableDictionary *_cancellableBlockss;
NSMutableDictionary * cancellableBlockss() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cancellableBlockss = [NSMutableDictionary new];
    });
        
    return _cancellableBlockss;
}
    
void ExecuteAfter(CGFloat delay, void(^block)(void)) {
    ExecuteAfterCancellable(nil, delay, block);
}

void ExecuteAfterCancellable(NSString *cancelIdentifier, CGFloat delay, void(^block)(void)) {
    NSTimer *timer;
        
    if (cancelIdentifier) {
        //first create the timer
        timer = [NSTimer timerWithTimeInterval:delay repeats:NO withBlock:^{
            //first call original block
            block();
                
            //then remove from list
            [cancellableBlockss() removeObjectForKey:cancelIdentifier];
        }];
            
            //then remember it so we can cancel it later
        cancellableBlockss()[cancelIdentifier] = timer;
    }
    else {
        timer = [NSTimer timerWithTimeInterval:delay repeats:NO withBlock:block];
    }
        
    //schedule it
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
    
    
@end
