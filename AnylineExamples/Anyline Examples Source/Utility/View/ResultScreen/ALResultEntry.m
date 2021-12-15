//
//  ALResultEntry.m
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import <Foundation/Foundation.h>
#import "ALResultEntry.h"
#import "NSString+Util.h"

NSString * const kResultDataTitleKey = @"title";
NSString * const kResultDataValueKey = @"value";
NSString * const kResultDataIsAvailableKey = @"isAvailable";
NSString * const kResultDataShouldSpellOutValueKey = @"shouldSpellOutValue";
NSString * const kResultDataIsMandatoryKey = @"isMandatory";

NSString * const kResultDataValueNotAvailableString = @"Not available";


@interface ALResultEntry ()

@end

@implementation ALResultEntry


- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value shouldSpellOutValue:(BOOL)shouldSpellOutValue isMandatory:(BOOL)isMandatory {
    self = [super init];
    if (self) {
        _title = title;
        _value = (![self stringIsNilOrEmpty:value]) ? [value trimmed] : kResultDataValueNotAvailableString;
        _isAvailable = (![self stringIsNilOrEmpty:value]) ? true : false;
        _shouldSpellOutValue = shouldSpellOutValue;
        _isMandatory = isMandatory;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value shouldSpellOutValue:(BOOL)shouldSpellOutValue {
    self = [self initWithTitle:title value:value shouldSpellOutValue:shouldSpellOutValue isMandatory:YES];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [self initWithTitle:title value:value shouldSpellOutValue:NO isMandatory:YES];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isMandatory:(BOOL)isMandatory {
    self = [self initWithTitle:title value:value shouldSpellOutValue:NO isMandatory:isMandatory];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isAvailable:(BOOL)available {
    self = [self initWithTitle:title value:value shouldSpellOutValue:NO isMandatory:YES];
    return self;
}

- (instancetype)initWithDicitonary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (dict[kResultDataTitleKey]) {
            _title = dict[kResultDataTitleKey];
        }
        
        if (dict[kResultDataValueKey]) {
            _value = dict[kResultDataValueKey];
        } else {
            _value = kResultDataValueNotAvailableString;
        }
        
        if (dict[kResultDataIsAvailableKey]) {
            _isAvailable = [dict[kResultDataIsAvailableKey] boolValue];
        } else {
            _isAvailable = NO;
        }
        
        if (dict[kResultDataShouldSpellOutValueKey]) {
            _shouldSpellOutValue = [dict[kResultDataShouldSpellOutValueKey] boolValue];
        } else {
            _shouldSpellOutValue = NO;
        }
        
        if (dict[kResultDataIsMandatoryKey]) {
            _isMandatory = [dict[kResultDataIsMandatoryKey] boolValue];
        } else {
            _isMandatory = YES;
        }
    }
    return self;
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.title forKey:kResultDataTitleKey];
    [dict setObject:self.value forKey:kResultDataValueKey];
    [dict setObject:@(self.isAvailable) forKey:kResultDataIsAvailableKey];
    [dict setObject:@(self.shouldSpellOutValue) forKey:kResultDataShouldSpellOutValueKey];
    [dict setObject:@(self.isMandatory) forKey:kResultDataIsMandatoryKey];
    
    return dict;
}

@end

