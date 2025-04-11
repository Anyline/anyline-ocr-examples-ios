#ifndef ALUIFeedbackConfig_Debugging_h
#define ALUIFeedbackConfig_Debugging_h

#import <Foundation/Foundation.h>
#import <Anyline/Anyline-Swift.h>

#define ALFeedbackParsingError(ERR_MSG) [NSError errorWithDomain:ALErrorDomain code:ALUIFeedbackJSONError userInfo:@{ NSLocalizedDescriptionKey : (ERR_MSG) }]


// category for logging
@interface ALUIFeedbackLogger (ALLogging)

- (void)info:(NSString *)message, ...;

- (void)debug:(NSString *)message, ...;

- (void)error:(NSString *)message, ...;

- (void)warn:(NSString *)message, ...;

@end

#endif /* ALUIFeedbackConfig_Debugging_h */
