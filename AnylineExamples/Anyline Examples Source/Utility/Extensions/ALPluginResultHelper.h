#import <Foundation/Foundation.h>
#import <Anyline/Anyline.h> // needed?
// #import "AnylineExamples-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@class ALResultEntry;

@interface NSArray (ALExtras)

@property (nonatomic, readonly) NSArray<ALResultEntry *> *resultEntries;

@end

NS_ASSUME_NONNULL_END
