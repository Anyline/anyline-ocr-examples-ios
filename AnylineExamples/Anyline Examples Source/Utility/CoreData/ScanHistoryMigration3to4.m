//
//  ScanHistoryMigration3to4.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//

#import "ScanHistoryMigration3to4.h"
#import <UIKit/UIKit.h>

@implementation ScanHistoryMigration3to4

- (NSData *)newFaceImageAttribute {
    return nil;
}

- (NSData *)migrationToArrayData:(NSData *)imageData {
    UIImage *img = [UIImage imageWithData:imageData];
    NSError *error = nil;
    NSArray *imageArray = [NSArray arrayWithObject:img];
    NSData *imageArrayData = [NSKeyedArchiver archivedDataWithRootObject:imageArray requiringSecureCoding:NO error:&error];
    return imageArrayData;
}

@end
