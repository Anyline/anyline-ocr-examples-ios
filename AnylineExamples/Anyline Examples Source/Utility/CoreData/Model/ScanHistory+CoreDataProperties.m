//
//  ScanHistory+CoreDataProperties.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//
//

#import "ScanHistory+CoreDataProperties.h"

@implementation ScanHistory (CoreDataProperties)

+ (NSFetchRequest<ScanHistory *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ScanHistory"];
}

@dynamic barcodeResult;
@dynamic images;
@dynamic result;
@dynamic timestamp;
@dynamic type;
@dynamic faceImage;

@end
