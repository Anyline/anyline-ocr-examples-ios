//
//  ScanHistory+CoreDataClass.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 28.03.21.
//
//

#import "ScanHistory+CoreDataClass.h"

NSString * const ALScanHistoryType_toString[] = {
    [ALScanHistoryNone] = @"0",
    [ALScanHistoryGasMeter] = @"Gas Meter",
    [ALScanHistoryWaterMeter] = @"Water Meter",
    [ALScanHistoryDigitalMeter] = @"Digital Meter",
    [ALScanHistoryHeatMeter] = @"Heat Meter",
    [ALScanHistoryDialMeter] = @"Dial Meter",
    [ALScanHistoryMrz] = @"MRZ",
    [ALScanHistoryBarcode] = @"Barcode",
    [ALScanHistoryIban] = @"IBAN",
    [ALScanHistoryVoucherCode] = @"Voucher",
    [ALScanHistoryRedBull] = @"RedBull",
    [ALScanHistoryBottleCap] = @"Bottlecaps",
    [ALScanHistoryScrabble] = @"Scrabble",
    [ALScanHistoryIsbn] = @"ISBN",
    [ALScanHistoryRecordNumber] = @"Records",
    [ALScanHistoryHashtag] = @"Hashtag",
    [ALScanHistoryDocument] = @"Document",
    [ALScanHistoryElectricMeter] = @"Electric Meter",
    [ALScanHistoryAnalogMeter] = @"Analog Meter",
    [ALScanHistoryLicensePlates] = @"License Plates Auto-detect",
    [ALScanHistoryLicensePlatesAT] = @"License Plates Austria",
    [ALScanHistoryLicensePlatesDE] = @"License Plates Germany",
    [ALScanHistoryBadge] = @"Badge Scanner",
    [ALScanHistorySerial] = @"Serial Scanner",
    [ALScanHistoryVIN] = @"Vin Scanner",
    [ALScanHistoryContainer] = @"Container Scanner",
    [ALScanHistoryDrivingLicense] = @"Driving License", // deprecated
    [ALScanHistoryGermanIDFront] = @"German ID Front", // deprecated
    [ALScanHistoryCattleTag] = @"Cattle Tag",
    [ALScanHistoryTIN] = @"Tire Identification Number",
    [ALScanHistoryTireSizeConfiguration] = @"Tire Size Configuration",
    [ALScanHistoryCommercialTireID] = @"Commercial Tire ID",
    [ALScanHistoryNFC] = @"NFC Reader",
    [ALScanHistoryUniversalID] = @"Universal ID",
    [ALScanHistoryBarcodePDF417] = @"PDF 417",
    [ALScanHistoryBottleCapPepsi] = @"Pepsi Code",
    [ALScanHistoryVehicleRegistrationCertificate] = @"Vehicle Registration Certificate",
    [ALScanHistoryTireMake] = @"Tire Make",
};

@implementation ScanHistory

+ (ScanHistory *)insertNewObjectWithType:(ALScanHistoryType)type
                                  result:(NSString *)result
                           barcodeResult:(NSString *)barcodeResult
                               faceImage:(UIImage *)faceImage
                                  images:(NSArray *)images
                  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                   error:(NSError **)error {
    ScanHistory *item = [NSEntityDescription insertNewObjectForEntityForName:@"ScanHistory" inManagedObjectContext:managedObjectContext];
    
    item.type = @(type);
    item.result = result;
    item.barcodeResult = barcodeResult;
    
    NSError *archiveDataError = nil;
    item.images = [NSKeyedArchiver archivedDataWithRootObject:images requiringSecureCoding:NO error:&archiveDataError];
    
    item.faceImage = UIImagePNGRepresentation(faceImage);
    item.timestamp = [NSDate date];
    
    [managedObjectContext save:error];
    
    return item;
}

-(id)copyWithZone:(NSZone *)zone {
    return [self duplicateUnassociated];
}


/*
 * Source: https://gist.github.com/steakknife/3bae589c4da8eba9b361#file-nsmanagedobject-duplicate-m
 */

- (instancetype)duplicateUnassociated {
    ScanHistory *result = [[ScanHistory alloc]
                           initWithEntity:self.entity
                           insertIntoManagedObjectContext:nil];
    [self duplicateToTarget:result];
    return result;
}

- (void)duplicateToTarget:(ScanHistory *)target {
    NSEntityDescription *entityDescription = self.objectID.entity;
    NSArray *attributeKeys = entityDescription.attributesByName.allKeys;
    NSDictionary *attributeKeysAndValues = [self dictionaryWithValuesForKeys:attributeKeys];
    [target setValuesForKeysWithDictionary:attributeKeysAndValues];
}
@end
