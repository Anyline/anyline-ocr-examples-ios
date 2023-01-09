//
//  ScanHistory+CoreDataProperties.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//
//

#import "ScanHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScanHistory (CoreDataProperties)

+ (NSFetchRequest<ScanHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *barcodeResult;
@property (nullable, nonatomic, retain) NSData *images;
@property (nullable, nonatomic, copy) NSString *result;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, retain) NSData *faceImage;

@end

NS_ASSUME_NONNULL_END
