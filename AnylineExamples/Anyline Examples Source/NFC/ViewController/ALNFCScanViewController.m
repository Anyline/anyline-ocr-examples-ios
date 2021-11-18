//
//  ALNFCScanViewController.m
//  AnylineExamples
//
//  Created by Angela Brett on 08.10.19.
//

#import "ALNFCScanViewController.h"
#import "ALResultViewController.h"
#import "ALUniversalIDFieldnameUtil.h"

API_AVAILABLE(ios(13.0))
@interface ALNFCScanViewController () <ALNFCDetectorDelegate, ALIDPluginDelegate,ALScanViewPluginDelegate,ALInfoDelegate>

@property (nonatomic, strong) ALIDScanViewPlugin *mrzScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *mrzScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;
@property (nonatomic, strong) ALNFCDetector *nfcDetector;
@property (nullable, nonatomic, strong) UIView *hintView;

//keep the last values we read from the MRZ so we can retry reading NFC if NFC failed for reasons other than getting these details wrong
@property NSString *passportNumberForNFC;
@property NSDate *dateOfBirth;
@property NSDate *dateOfExpiry;

@end

@implementation ALNFCScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NFC";
    CGFloat hintMargin = 7;
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel * hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView * hintView = [[UILabel alloc] initWithFrame:CGRectZero];
    hintViewLabel.text = @"Scan MRZ";
    [hintViewLabel sizeToFit];
    [hintView addSubview:hintViewLabel];
    hintView.frame = UIEdgeInsetsInsetRect(hintViewLabel.frame, UIEdgeInsetsMake(-hintMargin, -hintMargin, -hintMargin, -hintMargin));
    hintView.center = CGPointMake(self.view.center.x, 0);
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor constant:0].active = YES;
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor constant:0].active = YES;
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = true;
    hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hintViewLabel.textColor = [UIColor whiteColor];
    self.hintView = hintView;
    [self.view addSubview:hintView];
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALMRZConfig *mrzConfig = [[ALMRZConfig alloc] init];
    //we want to be quite confident of these fields to ensure we can read the NFC with them
    ALMRZFieldConfidences *fieldConfidences = [[ALMRZFieldConfidences alloc] init];
    fieldConfidences.documentNumber = 90;
    fieldConfidences.dateOfBirth = 90;
    fieldConfidences.dateOfExpiry = 90;
    mrzConfig.idFieldConfidences = fieldConfidences;
    
    //Create fieldScanOptions to configure individual scannable fields
    ALMRZFieldScanOptions *scanOptions = [[ALMRZFieldScanOptions alloc] init];
    scanOptions.vizAddress = ALDefault;
    scanOptions.vizDateOfIssue = ALDefault;
    scanOptions.vizSurname = ALDefault;
    scanOptions.vizGivenNames = ALDefault;
    scanOptions.vizDateOfBirth = ALDefault;
    scanOptions.vizDateOfExpiry = ALDefault;
    
    //Set scanOptions for MRZConfig
    mrzConfig.idFieldScanOptions = scanOptions;
    
    NSError *error = nil;

    //Init the anyline ID ScanPlugin with an ID, Licensekey, the delegate,
    //  the MRZConfig (which will configure the scan Plugin for MRZ scanning), and an error
    self.mrzScanPlugin = [[ALIDScanPlugin alloc] initWithPluginID:@"ModuleID" delegate:self idConfig:mrzConfig error:&error];
    if (@available(iOS 13.0, *)) {
        self.nfcDetector=[[ALNFCDetector alloc] initWithDelegate:self];
    } else {
        // Fallback on earlier versions
    }
    NSAssert(self.mrzScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanPlugin addInfoDelegate:self];
    
    
    self.mrzScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.mrzScanPlugin];
    NSAssert(self.mrzScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanViewPlugin addScanViewPluginDelegate:self];
    
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.mrzScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryNFC;
    
    // After setup is complete we add the scanView to the view of this view controller
    [self.scanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scanView];
    [self.view sendSubviewToBack:self.scanView];
    NSArray *scanViewConstraints = @[[self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                     [self.scanView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
                                     [self.scanView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor],
                                     [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];
    [self.view addConstraints:scanViewConstraints];
    [NSLayoutConstraint activateConstraints:scanViewConstraints];
    //Start Camera:
    [self.scanView startCamera];
    [self startListeningForMotion];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // We use this subroutine to start Anyline. The reason it has its own subroutine is
    // so that we can later use it to restart the scanning process.
    [self startMRZScanning];
}

- (void)updateHintPosition:(CGFloat)newPosition {
    self.hintView.center = CGPointMake(self.hintView.center.x, newPosition);
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
    [self updateHintPosition:cutoutRect.origin.y +
    self.scanView.frame.origin.y -
    50];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopMRZScanning];
}


/*
   This method is used to tell Anyline to start scanning. It gets called in
   viewDidAppear to start scanning the moment the view appears. Once a result
   is found scanning will stop automatically (you can change this behaviour
   with cancelOnResult:). When the user dismisses self.identificationView this
   method will get called again.
 */
- (void)startMRZScanning {
    [self startPlugin:self.mrzScanViewPlugin];
    self.startTime = CACurrentMediaTime();
    self.hintView.hidden = NO;
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)stopMRZScanning {
    [self.mrzScanViewPlugin stopAndReturnError:nil];
    self.hintView.hidden = YES;
}

- (void)readNFCChip {
    /*
     This is where we start reading the NFC chip of the passport. We use data from the MRZ to authenticate with the chip.
     */
    [self.nfcDetector startNfcDetectionWithPassportNumber:self.passportNumberForNFC dateOfBirth:self.dateOfBirth expirationDate:self.dateOfExpiry];
}

#pragma mark -- ALIDPluginDelegate

/*
 This is the main delegate method Anyline uses to report its results from an ID plugin such as MRZ
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin didFindResult:(ALIDResult *)scanResult {
    ALMRZIdentification *identification = (ALMRZIdentification*)scanResult.result;
    NSString *passportNumber = [[identification documentNumber] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDate *dateOfBirth = [identification dateOfBirthObject];
    NSDate *dateOfExpiry = [identification dateOfExpiryObject];
    //The passport number passed to the NFC chip must have a trailing < if there is one in the MRZ string.
    NSString *mrzString = [identification mrzString];
    NSMutableString *passportNumberForNFC = [passportNumber mutableCopy];
    NSRange passportNumberRange = [mrzString rangeOfString:passportNumber];
    if (passportNumberRange.location != NSNotFound) {
        if ([mrzString characterAtIndex:NSMaxRange(passportNumberRange)] == '<') {
            [passportNumberForNFC appendString:@"<"];
        }
    }
    [self stopMRZScanning];
    self.passportNumberForNFC = passportNumberForNFC;
    self.dateOfBirth = dateOfBirth;
    self.dateOfExpiry = dateOfExpiry;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self readNFCChip];
    });
}

#pragma mark -- ALNFCDetectorDelegate

/* This method is called after all the data has been read from the NFC chip.
 To display data as it is read instead of waiting until everything has been read, we could also implement nfcSucceededWithDataGroup1: or nfcSucceededWithDataGroup2: */
- (void)nfcSucceededWithResult:(ALNFCResult * _Nonnull)nfcResult  API_AVAILABLE(ios(13.0)){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"First Name" value:nfcResult.dataGroup1.firstName]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Last Name" value:nfcResult.dataGroup1.lastName]];
        [resultData addObject:[self resultEntryWithDate:nfcResult.dataGroup1.dateOfBirth dateString:nil title:@"Date of Birth"]];
        [resultData addObject:[self resultEntryWithDate:nfcResult.dataGroup1.dateOfExpiry dateString:nil title:@"Date of Expiry"]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:nfcResult.dataGroup1.documentNumber shouldSpellOutValue:YES]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Issuing State Code" value:nfcResult.dataGroup1.issuingStateCode]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Gender" value:nfcResult.dataGroup1.gender]];
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:nfcResult.dataGroup1.nationality]];
        
        resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;
        NSString *jsonString = [self jsonStringFromResultData:resultData];
        [self anylineDidFindResult:jsonString barcodeResult:@"" image:nfcResult.dataGroup2.faceImage scanPlugin:nil viewPlugin:nil completion:^{
            
            NSMutableDictionary *resultDataDict = [[NSMutableDictionary alloc] init];
            [resultDataDict setObject:resultData forKey:@"NFC"];
            ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData image:nfcResult.dataGroup2.faceImage];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    });
}

- (void)nfcFailedWithError:(NSError * _Nonnull)error {
    NSLog(@"NFC failed with error:%@, mrz:%@",error.localizedDescription,self.passportNumberForNFC);
    //In most cases we don't really need to do anything special here since the NFC UI already shows that it failed. We shouldn't get ALNFCTagErrorNFCNotSupported either because we check +readingAvailable before even showing NFC, so this is just an example of how else that situation could be handled.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code == ALNFCTagErrorNFCNotSupported) {
            [self showAlertWithTitle:@"NFC Not Supported" message:@"NFC passport reading is not supported on this device."];
        }
        if (error.code == ALNFCTagErrorResponseError || //error ALNFCTagErrorResponseError can mean the MRZ key was wrong
            error.code == ALNFCTagErrorUnexpectedError) { //error ALNFCTagErrorUnexpectedError can mean the user pressed the 'Cancel' button while scanning. It could also mean the phone lost the connection with the NFC chip because it was moved.
            [self startMRZScanning]; //run the MRZ scanner so we can try again.
        } else {
            //the MRZ details are correct, but something else went wrong. We can try reading the NFC chip again without rescanning the MRZ.
            [self readNFCChip];
            
        }
    });
}


- (ALResultEntry *)resultEntryWithDate:(NSDate *)date dateString:(NSString *)dateString title:(NSString *)title {
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

@end
