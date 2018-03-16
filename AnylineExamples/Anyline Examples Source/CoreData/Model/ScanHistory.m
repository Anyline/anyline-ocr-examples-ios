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

@end
