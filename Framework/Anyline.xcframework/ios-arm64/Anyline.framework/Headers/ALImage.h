#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ALColorFormatYUV,
    ALColorFormatRGB
} ALColorFormat;

NS_ASSUME_NONNULL_BEGIN

@interface ALImage : NSObject

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSUInteger bytesPerRow;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) ALColorFormat originalColorFormat;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

// generated on demand from the data buffer based on the original colorFormat, and cached
@property (nonatomic, readonly) UIImage *uiImage;

+ (ALImage *)fromUIImage:(UIImage *)uiImage;

- (instancetype)initWithData:(NSData *)data
                       width:(NSUInteger)width
                      height:(NSUInteger)height
                 bytesPerRow:(NSUInteger)bytesPerRow
         originalColorFormat:(ALColorFormat)originalColorFormat;

@end

NS_ASSUME_NONNULL_END
