#import <UIKit/UIKit.h>
#import "ALScanViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class ALUIFeedbackLogger;
@class AVAudioPlayer;

@interface ALUIFeedbackElementContentConfig (ALPrivateExtras)

- (AVAudioPlayer * _Nullable)getAudioPlayer;

- (AVAudioPlayer * _Nullable)getAudioPlayerWithLogger:(ALUIFeedbackLogger * _Nullable)logger;

- (UIImage * _Nullable)getImage;

- (UIImage * _Nullable)getImageWithLogger:(ALUIFeedbackLogger * _Nullable)logger;

@end

NS_ASSUME_NONNULL_END
