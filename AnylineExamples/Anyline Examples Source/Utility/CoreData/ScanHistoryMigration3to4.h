//
//  ScanHistoryMigration3to4.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanHistoryMigration3to4 : NSEntityMigrationPolicy

- (NSData *)newFaceImageAttribute;
- (NSData *)migrationToArrayData:(NSData *)imageData;

@end

NS_ASSUME_NONNULL_END
