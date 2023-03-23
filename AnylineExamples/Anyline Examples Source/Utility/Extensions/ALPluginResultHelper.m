#import "ALPluginResultHelper.h"
#import <Anyline/Anyline.h>
#import "AnylineExamples-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSArray (ALExtras)

- (NSArray<ALResultEntry *> *)resultEntries {

    // requirement: elements are dictionaries<string, string>.
    NSMutableArray<ALResultEntry *> *ret = [NSMutableArray array];
    for (id element in self) {
        if (![element isKindOfClass:[NSDictionary<NSString *, NSString *> class]]) {
            continue;
        }
        NSDictionary<NSString *, NSString *> *dict = element;
        NSString *title = dict[@"nameReadable"];
        if (!title) {
            title = dict[@"name"];
        }

        NSString *value = dict[@"value"];
        if (!value) {
            value = @"";
        }

        BOOL spellOut = NO;
        BOOL mandatory = NO;

        NSString *extra = dict[@"extra"];
        if (extra) {
            NSArray<NSString *> *extraComps = [extra componentsSeparatedByString:@";"];
            if ([extraComps containsObject:@"spellOut"]) {
                spellOut = YES;
            }

            if ([extraComps containsObject:@"mandatory"]) {
                mandatory = YES;
            }

            if ([extraComps containsObject:@"script:cyr"]) {
                title = [title stringByAppendingString:@"-cyr"];
            } else if ([extraComps containsObject:@"script:ara"]) {
                title = [title stringByAppendingString:@"-ara"];
            }
        }

        ALResultEntry *entry = [ALResultEntry withTitle:title value:value shouldSpellOutValue:spellOut];
        entry.isMandatory = mandatory;
        [ret addObject:entry];

    }
    return ret;
}

@end

NS_ASSUME_NONNULL_END
