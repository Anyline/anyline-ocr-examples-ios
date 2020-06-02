//
//  ALResultEntry.m
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import <Foundation/Foundation.h>
#import "ALResultEntry.h"

@interface ALResultEntry ()

@end

@implementation ALResultEntry

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value shouldSpellOutValue:(BOOL)shouldSpellOutValue {
    self = [super init];
    if (self) {
        _title = title;
        _value = (![self stringIsNilOrEmpty:value]) ? value : @"Not available";
        _isAvailable = (![self stringIsNilOrEmpty:value]) ? true : false;
        _shouldSpellOutValue = shouldSpellOutValue;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [self initWithTitle:title value:value shouldSpellOutValue:NO];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isAvailable:(BOOL)available {
    self = [super init];
    if (self) {
        _title = title;
        _value = (![self stringIsNilOrEmpty:value]) ? value : @"Not available";
        _isAvailable = available;
    }
    return self;
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}
@end

