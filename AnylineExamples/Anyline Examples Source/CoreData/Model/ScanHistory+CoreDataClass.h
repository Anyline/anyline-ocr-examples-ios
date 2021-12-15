//
//  ScanHistory+CoreDataClass.h
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "NSManagedObject+ALExamplesAdditions.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ALScanHistoryNone = 0,
    ALScanHistoryGasMeter = 1,
    ALScanHistoryWaterMeter = 2,
    ALScanHistoryDigitalMeter = 3,
    ALScanHistoryHeatMeter = 4,
    ALScanHistoryMrz = 5,
    ALScanHistoryBarcode = 6,
    ALScanHistoryIban = 7,
    ALScanHistoryVoucherCode = 8,
    ALScanHistoryRedBull = 9,
    ALScanHistoryBottleCap = 10,
    ALScanHistoryScrabble = 11,
    ALScanHistoryIsbn = 12,
    ALScanHistoryRecordNumber = 13,
    ALScanHistoryHashtag = 14,
    ALScanHistoryDocument = 15,
    ALScanHistoryElectricMeter = 16,
    ALScanHistoryLicensePlates = 17,
    ALScanHistoryLicensePlatesAT = 18,
    ALScanHistoryLicensePlatesDE = 19,
    ALScanHistoryAnalogMeter = 20,
    ALScanHistoryDialMeter = 21,
    ALScanHistoryBadge = 22,
    ALScanHistorySerial = 23,
    ALScanHistoryVIN = 24,
    ALScanHistoryContainer = 25,
    ALScanHistoryDrivingLicense = 26, // DEPRECATED
    ALScanHistoryGermanIDFront = 27, // DEPRECATED
    ALScanHistoryCattleTag = 28,
    ALScanHistoryTIN = 29,
    ALScanHistoryNFC = 30,
    ALScanHistoryUniversalID = 31,
    ALScanHistoryBarcodePDF417 = 32,
    ALScanHistoryBottleCapPepsi = 33,
    //be sure to add any new types to ALScanHistoryType_toString!
} ALScanHistoryType;

extern NSString * _Nonnull const ALScanHistoryType_toString[];

@interface ScanHistory : NSManagedObject

//+ (ScanHistory *)insertNewObjectWithType:(ALScanHistoryType)type
//                                  result:(NSString *)result
//                           barcodeResult:(NSString *)barcodeResult
//                                   image:(UIImage *)image
//                  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
//                                   error:(NSError **)error;

+ (ScanHistory *)insertNewObjectWithType:(ALScanHistoryType)type
                                  result:(NSString *)result
                           barcodeResult:(NSString *)barcodeResult
                               faceImage:(UIImage *)faceImage
                                  images:(NSArray *)images
                  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                   error:(NSError **)error;

- (id)copyWithZone:(NSZone *)zone;
@end

NS_ASSUME_NONNULL_END

#import "ScanHistory+CoreDataProperties.h"
