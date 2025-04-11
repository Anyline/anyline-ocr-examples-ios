#ifndef ALBarcodeOverlayView_Private_h
#define ALBarcodeOverlayView_Private_h

#import "ALBarcodeOverlayView.h"

NS_ASSUME_NONNULL_BEGIN

@class ALOverlayConfig;
@class ALBarcodeOverlayLayoutGuide;

@interface ALBarcodeOverlayView ()

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) ALOverlayConfig *config;

@property (nonatomic, copy) void (^invalidateLabel)(NSString *);

@property (nonatomic, strong) ALBarcodeOverlayLayoutGuide *accessoryLayoutGuide;

@end


NS_ASSUME_NONNULL_END

#endif /* ALBarcodeOverlayView_Private_h */
