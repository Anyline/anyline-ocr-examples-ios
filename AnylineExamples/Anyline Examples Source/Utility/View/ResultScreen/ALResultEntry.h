//
//  ALResultEntry.h
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

@interface ALResultEntry : NSObject

@property (strong, atomic) NSString *title;
@property (strong, atomic) NSString *value;
@property (atomic) BOOL isAvailable;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isAvailable:(BOOL)available;

@end
