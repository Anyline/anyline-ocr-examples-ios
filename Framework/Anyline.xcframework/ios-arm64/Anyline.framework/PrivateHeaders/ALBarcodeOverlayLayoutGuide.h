#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ALBarcodeLayoutGuideType) {
    ALBarcodeLayoutGuideTypeBarcode,
    ALBarcodeLayoutGuideTypeCustomView
};


@interface ALBarcodeOverlayLayoutGuide : UILayoutGuide

@property (nonatomic, assign) ALBarcodeLayoutGuideType type;

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSLayoutConstraint *xConstraint;

@property (nonatomic, strong) NSLayoutConstraint *yConstraint;

@property (nonatomic, strong) NSLayoutConstraint *wConstraint;

@property (nonatomic, strong) NSLayoutConstraint *hConstraint;

@property (nonatomic, assign) CGPoint currentPosition;

@end

NS_ASSUME_NONNULL_END
