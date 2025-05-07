#ifndef ALDetectedBarcode_Private_h
#define ALDetectedBarcode_Private_h

#import "ALDetectedBarcode.h"

@class ALImage;

NS_ASSUME_NONNULL_BEGIN

@interface ALDetectedBarcode ()

@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) ALBarcode *barcode;

@property (nonatomic, strong) ALImage *image;

@property (nonatomic, assign) CFTimeInterval timestamp;

@property (nonatomic, assign) CGPoint tl;

@property (nonatomic, assign) CGPoint tr;

@property (nonatomic, assign) CGPoint br;

@property (nonatomic, assign) CGPoint bl;

@property (nonatomic, assign) CGRect enclosingCGRect;

/// for now is the computed midpoint of the barcode, including potentially
/// factors apart from the coordinates from the immediate ScanResult (e.g.
/// aggregated past points)
@property (nonatomic, assign) CGPoint actualPosition;

- (instancetype)initWithBarcode:(ALBarcode *)barcode image:(ALImage *)image timestamp:(NSTimeInterval)timestamp;

- (CGPoint)logicalMidpoint;

- (BOOL)matches:(ALDetectedBarcode *)otherBarcode tolerance:(CGFloat)tolerance;

- (CGRect)toEnclosingRectWithTranslate:(CGPoint (^)(CGPoint))translate
                          growByFactor:(CGFloat)factor;

- (void)copyCoordinatesFromBarcode:(ALDetectedBarcode *)otherBarcode;

@end


NS_ASSUME_NONNULL_END

#endif /* ALDetectedBarcode_Private_h */
