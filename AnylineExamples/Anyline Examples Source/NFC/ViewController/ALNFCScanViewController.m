#import "ALNFCScanViewController.h"
#import "AnylineExamples-Swift.h"
#import <Anyline/Anyline.h>

API_AVAILABLE(ios(13.0))
@interface ALNFCScanViewController () <ALNFCDetectorDelegate, ALScanPluginDelegate>

@property (nonatomic, strong) ALNFCDetector *nfcDetector;
@property (nonatomic, strong) ALScanViewPlugin *scanViewPlugin;
@property (nonatomic, strong) ALScanViewConfig *scanViewConfig;

@property (nonatomic, strong, nullable) UIView *hintView;

// keep the last values we read from the MRZ so we can retry reading NFC if
// NFC failed for reasons other than getting these details wrong
@property (nonatomic, copy) NSString *passportNumberForNFC;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) NSDate *dateOfExpiry;

@end

@implementation ALNFCScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NFC";
    self.controllerType = ALScanHistoryNFC;

    BOOL NFCEnabled = [self checkNFCCapability];
    if (!NFCEnabled) {
        return;
    }

    if (@available(iOS 13.0, *)) {
        self.nfcDetector = [[ALNFCDetector alloc] initWithDelegate:self];
    }

    self.hintView = [self.class makeHintView];
    [self.view addSubview:self.hintView];
    [self.hintView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.hintView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"mrz_nfc_config"
                                                             ofType:@"json"];
    NSString *configStr = [NSString stringWithContentsOfFile:jsonFilePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:NULL];
    id JSONConfigObj = [configStr asJSONObject];

    // instead of directly creating a scan view plugin, we can let a factory determine
    // whether the result is a plain ALScanViewPlugin or an ALViewPluginComposite.
    self.scanViewPlugin = (ALScanViewPlugin *)[ALScanViewPluginFactory withJSONDictionary:JSONConfigObj];

    self.scanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:JSONConfigObj error:nil];

    // Tweak the MRZ tolerances here if necessary.
    // [self configureScanViewConfig];

    self.scanViewPlugin.scanPlugin.delegate = self;

    self.scanView = [[ALScanView alloc] initWithFrame:CGRectZero
                                       scanViewPlugin:self.scanViewPlugin
                                       scanViewConfig:self.scanViewConfig
                                                error:nil];
    
    [self installScanView:self.scanView];

    [self.scanView startCamera];

    //    self.mrzScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.mrzScanPlugin];
    //    NSAssert(self.mrzScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    //    [self.mrzScanViewPlugin addScanViewPluginDelegate:self];
    //
    //
    //    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.mrzScanViewPlugin];
    

    [self.view addSubview:self.scanView];

    // TODO: we also used the erstwhile ScanInfoDelegate in the old version
    // to track the cutout position.
    // [self startListeningForMotion];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanViewPlugin startWithError:nil];
    self.startTime = CACurrentMediaTime();
    self.hintView.hidden = NO;
}

- (BOOL)checkNFCCapability {
    // NOTE: Apart from the iOS version + device requirement, also make sure to
    // check that the app was provisioned with the Near Field Communications
    // Tag Reading capability.
    if (@available(iOS 13.0, *)) {
        if ([ALNFCDetector readingAvailable]) {
            return YES;
        }
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NFC Not Supported"
                                                                   message:@"NFC Tag Reading is not enabled for this device."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak __block typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    return NO;
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    // get passport number, date of birth, date of expiry

    ALMrzResult *mrzResult = scanResult.pluginResult.mrzResult;

    NSDate *dateOfBirth = [self.class formattedStringToDate:mrzResult.dateOfBirthObject];
    NSDate *dateOfExpiry = [self.class formattedStringToDate:mrzResult.dateOfExpiryObject];

    NSMutableString *passportNumberForNFC = [[mrzResult.documentNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
    NSRange passportNumberRange = [mrzResult.mrzString rangeOfString:passportNumberForNFC];
    if (passportNumberRange.location != NSNotFound) {
        if ([mrzResult.mrzString characterAtIndex:NSMaxRange(passportNumberRange)] == '<') {
            [passportNumberForNFC appendString:@"<"];
        }
    }

    if (passportNumberForNFC.length > 0) {
        [self.scanViewPlugin stop];
        self.hintView.hidden = YES;

        __weak __block typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.nfcDetector startNfcDetectionWithPassportNumber:passportNumberForNFC
                                                          dateOfBirth:dateOfBirth
                                                       expirationDate:dateOfExpiry];
        });
    }


    self.dateOfBirth = dateOfBirth;
    self.dateOfExpiry = dateOfExpiry;
    self.passportNumberForNFC = passportNumberForNFC;
}

// MARK: - ALNFCDetectorDelegate

/// This method is called after all the data has been read from the NFC chip. To display
/// data as it is read instead of waiting until everything has been read, we could also
/// implement nfcSucceededWithDataGroup1: or nfcSucceededWithDataGroup2:
/// - Parameter nfcResult: NFCResult object
- (void)nfcSucceededWithResult:(ALNFCResult * _Nonnull)nfcResult API_AVAILABLE(ios(13.0)) {

    NSMutableArray <ALResultEntry *> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"First Name" value:nfcResult.dataGroup1.firstName]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Last Name" value:nfcResult.dataGroup1.lastName]];
    [resultData addObject:[self resultEntryWithDate:nfcResult.dataGroup1.dateOfBirth dateString:nil title:@"Date of Birth"]];
    [resultData addObject:[self resultEntryWithDate:nfcResult.dataGroup1.dateOfExpiry dateString:nil title:@"Date of Expiry"]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:nfcResult.dataGroup1.documentNumber shouldSpellOutValue:YES]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Issuing State Code" value:nfcResult.dataGroup1.issuingStateCode]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Gender" value:nfcResult.dataGroup1.gender]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:nfcResult.dataGroup1.nationality]];

    // resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;

    NSString *jsonString = [ALResultEntry JSONStringFromList:resultData];

    __weak __block typeof(self) weakSelf = self;
    [self anylineDidFindResult:jsonString
                 barcodeResult:nil
                         image:nfcResult.dataGroup2.faceImage
                    scanPlugin:self.scanViewPlugin.scanPlugin
                    viewPlugin:self.scanViewPlugin
                    completion:^{

        NSMutableDictionary *resultDataDict = [[NSMutableDictionary alloc] init];
        [resultDataDict setObject:resultData forKey:@"NFC"];

        dispatch_async(dispatch_get_main_queue(), ^{
            ALResultViewController *vc = [[ALResultViewController alloc] initWithResults:resultData];
            vc.imagePrimary = nfcResult.dataGroup2.faceImage;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    }];
}

- (void)nfcFailedWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {

    __weak __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        NSLog(@"NFC failed with error code: %ld, document number: %@", (long)error.code, weakSelf.passportNumberForNFC);
        // In most cases we don't really need to do anything special here since the NFC UI already shows
        // that it failed. We shouldn't get ALNFCTagErrorNFCNotSupported either because we check +readingAvailable
        // before even showing NFC, so this is just an example of how else that situation could be handled.

        if (error.code == ALNFCTagErrorNFCNotSupported) {
            [weakSelf showAlertWithTitle:@"NFC Not Supported"
                                 message:@"NFC passport reading is not supported on this device."
                              completion:nil];
        }
        if (error.code == ALNFCTagErrorResponseError || // error ALNFCTagErrorResponseError can mean the MRZ key was wrong
            error.code == ALNFCTagErrorUnexpectedError) { // error ALNFCTagErrorUnexpectedError can mean the user pressed the

            // we could do this, but the dialog error would already be sufficient so this would be redundant.
//            NSString *NFCErrorMessage = [NSString stringWithFormat:@"There was an error reading the NFC passport: %@", error.localizedDescription];
//            [weakSelf showAlertWithTitle:@"NFC Error"
//                                 message:NFCErrorMessage
//                              completion:nil];

            // 'Cancel' button while scanning. It could also mean the phone lost the connection with the NFC chip because it was moved.
            [weakSelf.scanViewPlugin startWithError:nil];
            weakSelf.startTime = CACurrentMediaTime();
        } else {
            // the MRZ details are correct, but something else went wrong. We can try reading the NFC chip again without rescanning the MRZ.
            [weakSelf.nfcDetector startNfcDetectionWithPassportNumber:weakSelf.passportNumberForNFC
                                                      dateOfBirth:weakSelf.dateOfBirth
                                                   expirationDate:weakSelf.dateOfExpiry];
        }

    });


}

// MARK: - Accessories

+ (UIView *)makeHintView {
    CGFloat hintMargin = 7;

    UILabel *hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView *hintView = [[UILabel alloc] initWithFrame:CGRectZero];
    hintViewLabel.text = @"Scan MRZ";
    [hintViewLabel sizeToFit]; // this may not be necessary
    [hintView addSubview:hintViewLabel];

    // TODO: how do i write this better (pref using constraints)
    hintView.frame = UIEdgeInsetsInsetRect(hintViewLabel.frame, UIEdgeInsetsMake(-hintMargin, -hintMargin, -hintMargin, -hintMargin));
    hintView.translatesAutoresizingMaskIntoConstraints = NO;
    // hintView.center = CGPointMake(self.view.center.x, 0);
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor constant:0].active = YES;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor constant:0].active = YES;
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = true;
    hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hintViewLabel.textColor = [UIColor whiteColor];

    return hintView;
}

- (ALResultEntry *)resultEntryWithDate:(NSDate *)date
                            dateString:(NSString *)dateString
                                 title:(NSString *)title {

    BOOL isAvailable = [self checkDateIfAvailable:date dateString:dateString];
    if (!isAvailable) {
        return [[ALResultEntry alloc] initWithTitle:title value:nil];
    }
    
    NSString *value = [self stringForDate:date];
    return [[ALResultEntry alloc] initWithTitle:title value:value isAvailable:isAvailable];
}

- (BOOL)checkDateIfAvailable:(NSDate *)date dateString:(NSString *)dateString {
    if (!date && dateString.length == 0) {
        return NO;
    }
    return YES;
}

+ (NSDate *)formattedStringToDate:(NSString *)formattedStr {
    // From this: "Sun Apr 12 00:00:00 UTC 1977" to this: "04/12/1977"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    dateFormatter.dateFormat = @"E MMM d HH:mm:ss zzz yyyy";
    NSDate *d = [dateFormatter dateFromString:formattedStr];
    return d;
}

- (NSString *)stringForDate:(NSDate *)date {
    if (!date) {
        return @"Date not valid";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    return [dateFormatter stringFromDate:date];
}

- (void)configureScanViewConfig {
    //    ALMRZConfig *mrzConfig = [[ALMRZConfig alloc] init];
    //    //we want to be quite confident of these fields to ensure we can read the NFC with them
    //    ALMRZFieldConfidences *fieldConfidences = [[ALMRZFieldConfidences alloc] init];
    //    fieldConfidences.documentNumber = 90;
    //    fieldConfidences.dateOfBirth = 90;
    //    fieldConfidences.dateOfExpiry = 90;
    //    mrzConfig.idFieldConfidences = fieldConfidences;
    //
    //    //Create fieldScanOptions to configure individual scannable fields
    //    ALMRZFieldScanOptions *scanOptions = [[ALMRZFieldScanOptions alloc] init];
    //    scanOptions.vizAddress = ALDefault;
    //    scanOptions.vizDateOfIssue = ALDefault;
    //    scanOptions.vizSurname = ALDefault;
    //    scanOptions.vizGivenNames = ALDefault;
    //    scanOptions.vizDateOfBirth = ALDefault;
    //    scanOptions.vizDateOfExpiry = ALDefault;
    //
    //    //Set scanOptions for MRZConfig
    //    mrzConfig.idFieldScanOptions = scanOptions;
}

//- (void)updateHintPosition:(CGFloat)newPosition {
//    self.hintView.center = CGPointMake(self.hintView.center.x, newPosition);
//}

@end
