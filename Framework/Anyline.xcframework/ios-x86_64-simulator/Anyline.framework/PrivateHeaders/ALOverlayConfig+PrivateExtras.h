#import "ALOverlayConfig+Extras.h"

#ifndef ALOverlayConfig_PrivateExtras_h
#define ALOverlayConfig_PrivateExtras_h

NS_ASSUME_NONNULL_BEGIN

@interface ALOverlayConfig (ALExtras_Private)


@end


@interface ALOverlayScaleConfig (ALExtras_Private)

+ (ALOverlayScaleConfig *)defaultOffset;

+ (ALOverlayScaleConfig *)defaultSize;

@end


@interface ALOverlayDimensionConfig (ALExtras_Private)

+ (ALOverlayDimensionConfig * _Nonnull)defaultOffsetConfig;

+ (ALOverlayDimensionConfig * _Nonnull)defaultSizeConfig;

@end

NS_ASSUME_NONNULL_END

#endif /* ALOverlayConfig_PrivateExtras_h */
