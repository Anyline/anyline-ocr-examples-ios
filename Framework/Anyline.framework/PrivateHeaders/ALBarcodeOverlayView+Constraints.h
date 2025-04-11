#import <Foundation/Foundation.h>
#import "ALBarcodeOverlayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALBarcodeOverlayView (Constraints)

- (NSArray<NSLayoutConstraint *> *_Nonnull)viewConstraintsTo:(UILayoutGuide *)barcodeLayoutGuide;

@end


NS_ASSUME_NONNULL_END
