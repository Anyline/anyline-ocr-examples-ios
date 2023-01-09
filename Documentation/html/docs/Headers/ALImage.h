#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALImage : NSObject

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSUInteger bytesPerRow;
@property (nonatomic, strong) NSData *data;

@property (nonatomic, readonly) UIImage *uiImage;

- (instancetype)initWithData:(NSData *)data width:(NSUInteger)width height:(NSUInteger)height bytesPerRow:(NSUInteger)bytesPerRow;

@end

NS_ASSUME_NONNULL_END
