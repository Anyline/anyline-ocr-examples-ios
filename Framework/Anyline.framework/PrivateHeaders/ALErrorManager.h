#import <Foundation/Foundation.h>
#import "ALError.h"

@interface ALErrorManager : NSObject

@property (strong, nonatomic) NSError *error;

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

- (BOOL)hasError;
- (void)resetError;

- (void)addErrorForDomain:(NSString *)errorDomain
                errorCode:(ALErrorCode)errorCode
                 userInfo:(NSDictionary *)userInfo;

@end
