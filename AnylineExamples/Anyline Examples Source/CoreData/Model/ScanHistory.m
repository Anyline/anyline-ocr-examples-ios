//
//  ScanHistory.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 13/05/16.
//  Copyright © 2016 9yards GmbH. All rights reserved.
//

#import "ScanHistory.h"

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
    [ALScanHistoryDrivingLicense] = @"Driving License",
    [ALScanHistoryGermanIDFront] = @"German ID Front",
    [ALScanHistoryCattleTag] = @"Cattle Tag",
    [ALScanHistoryTIN] = @"TIN Scanner",
    [ALScanHistoryNFC] = @"NFC Reader",
    [ALScanHistoryUniversalID] = @"Universal ID",
    [ALScanHistoryBarcodePDF417] = @"PDF 417",
    [ALScanHistoryBottleCapPepsi] = @"Pepsi Code",
};

@implementation ScanHistory

+ (ScanHistory *)insertNewObjectWithType:(ALScanHistoryType)type
                                  result:(NSString *)result
                           barcodeResult:(NSString *)barcodeResult
                                   image:(UIImage *)image
                  inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                   error:(NSError **)error {
    ScanHistory *item = [NSEntityDescription insertNewObjectForEntityForName:@"ScanHistory" inManagedObjectContext:managedObjectContext];
    
    item.type = @(type);
    item.result = result;
    item.barcodeResult = barcodeResult;
    item.image = UIImagePNGRepresentation(image);
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
