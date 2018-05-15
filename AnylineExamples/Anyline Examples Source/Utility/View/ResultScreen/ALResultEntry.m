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

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value {
    self = [super init];
    if (self) {
        _title = title;
        _value = (![self stringIsNilOrEmpty:value]) ? value : @"Not available";
        _isAvailable = (![self stringIsNilOrEmpty:value]) ? true : false;
    }
    return self;
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}
@end

