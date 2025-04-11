#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ALAbstractGeometry
// Passed-in JSON objects are directly accessed as NSDictionary (or NSArray
// as the case may require). It doesn't guarantee the object is constructed
// correctly if you don't give it the correct types. It won't throw
// an exception, but may just leave the unmatched values zero or null.

- (instancetype _Nullable)initWithJSONObject:(id)JSONObj;

- (id _Nullable)asJSONObject;

@end


@interface ALGeometry: NSObject<ALAbstractGeometry>

+ (ALGeometry * _Nullable)withJSONDictionary:(NSDictionary * _Nonnull)dict;

+ (NSDictionary * _Nullable)asJSONDictionary:(ALGeometry *)geometry;

@end


@interface ALPoint: ALGeometry

@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;

- (instancetype)initWithCGPoint:(CGPoint)point;

- (CGPoint)cgPoint;

+ (ALPoint *)fromX:(NSInteger)x y:(NSInteger)y;

+ (ALPoint *)fromCGPoint:(CGPoint)point;

@end


@interface ALRect: ALGeometry

@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, readonly) CGRect rect;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y
                    width:(NSInteger)width height:(NSInteger)height;

- (instancetype)initWithArray:(NSArray<NSNumber *> *)jsonArray;

- (instancetype)initWithRect:(const CGRect)rect;

// is this the right type to use?
- (CGFloat)area;

@end

@interface ALSquare: ALGeometry

@property (nonatomic, readonly) ALPoint *tl;
@property (nonatomic, readonly) ALPoint *tr;
@property (nonatomic, readonly) ALPoint *bl;
@property (nonatomic, readonly) ALPoint *br;

- (instancetype)initWithTopLeft:(ALPoint *)topLeft
                       topRight:(ALPoint *)topRight
                     bottomLeft:(ALPoint *)bottomLeft
                    bottomRight:(ALPoint *)bottomRight;

- (CGFloat)boundingWidth;
- (CGFloat)boundingHeight;

- (BOOL)isEmpty;

@end


@interface ALContourVector: ALGeometry

// NOTE: for JSONObj in the default constructor, only
// NSArray<NSDictionary<NSString *, NSNumber *> *> * is suitable

@property (nonatomic, readonly) NSArray<ALRect *> *rects;

@end


@interface ALSquareVector: ALGeometry

@property (nonatomic, readonly) NSArray<ALSquare *> *squares;

@end

NS_ASSUME_NONNULL_END
