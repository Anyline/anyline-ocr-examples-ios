#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALImage;

// scan controller is the one calling this
@protocol ALCorePluginCallback

- (void)onError:(NSString *)errorJSON;

- (void)onVisualFeedback:(NSString *)visualFeedbackJSON;

- (void)onInfo:(NSString *)infoJSON;

- (void)onRunSkipped:(NSString *)runSkippedJSON;

- (void)onResult:(ALImage *)image result:(NSString *)resultJSON;

@end

NS_ASSUME_NONNULL_END
