//
//  ALPassportScanViewController.m
//  AnylineExamples
//
//  Created by Matthias on 24/05/15.
//  Copyright (c) 2015 9yards GmbH. All rights reserved.
//

#import "ALMRZScanViewController.h"
#import "ALIdentificationView.h"
#import <Anyline/Anyline.h>
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALUniversalIDFieldnameUtil.h"
#import "ALResultViewController.h"
#import "ALTutorialViewController.h"
#import "NSString+Util.h"

// The controller has to conform to <AnylineMRZModuleDelegate> to be able to receive results
@interface ALMRZScanViewController ()<ALIDPluginDelegate, ALInfoDelegate, ALScanViewPluginDelegate>

// The Anyline module used to scan machine readable zones
@property (nonatomic, strong) ALIDScanViewPlugin *mrzScanViewPlugin;
@property (nonatomic, strong) ALIDScanPlugin *mrzScanPlugin;
@property (nullable, nonatomic, strong) ALScanView *scanView;

@end

@implementation ALMRZScanViewController
/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    self.title = (self.title && self.title.length > 0) ? self.title : @"MRZ";
    
    if (![[[NSBundle mainBundle] bundleIdentifier] localizedCaseInsensitiveContainsString:@"bundle"]) {
        UIBarButtonItem *infoBarItem;
        if (@available(iOS 13.0, *)) {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(infoPressed:)];
        } else {
            infoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStylePlain target:self action:@selector(infoPressed:)];
        }
        self.navigationItem.rightBarButtonItem = infoBarItem;
    }
    
    // Initializing the scan view. It's a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [self scanViewFrame];
    
    ALMRZConfig *mrzConfig = [[ALMRZConfig alloc] init];
    
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
    NSAssert(self.mrzScanPlugin, @"Setup Error: %@", error.debugDescription);
    [self.mrzScanPlugin addInfoDelegate:self];
    
    
    self.mrzScanViewPlugin = [[ALIDScanViewPlugin alloc] initWithScanPlugin:self.mrzScanPlugin];
    NSAssert(self.mrzScanViewPlugin, @"Setup Error: %@", error.debugDescription);
    
    //turn on the new 'usesAnimatedRect' visual feedback, which uses animations around the cutout itself rather than the parts inside it where characters are detected.
    //mrzScanViewPlugin and cutoutConfig return copies of the configs so they can not be changed in-place
    ALScanViewPluginConfig *pluginConfig = self.mrzScanViewPlugin.scanViewPluginConfig;
    ALCutoutConfig * cutoutConfig = pluginConfig.cutoutConfig;
    cutoutConfig.usesAnimatedRect = YES;
    cutoutConfig.strokeWidth = 3.0;
    pluginConfig.cutoutConfig = cutoutConfig;
    self.mrzScanViewPlugin.scanViewPluginConfig = pluginConfig;
    
    [self.mrzScanViewPlugin addScanViewPluginDelegate:self];
    
    
    self.scanView = [[ALScanView alloc] initWithFrame:frame scanViewPlugin:self.mrzScanViewPlugin];
    
    self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    self.controllerType = ALScanHistoryMrz;
    
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
    [self startAnyline];
}

- (void)anylineScanViewPlugin:(ALAbstractScanViewPlugin *)anylineScanViewPlugin updatedCutout:(CGRect)cutoutRect {
    //Update Position of Warning Indicator
    [self updateWarningPosition:
     cutoutRect.origin.y +
     cutoutRect.size.height +
     self.scanView.frame.origin.y +
     80];
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mrzScanViewPlugin stopAndReturnError:nil];
}


/*
   This method is used to tell Anyline to start scanning. It gets called in 
   viewDidAppear to start scanning the moment the view appears. Once a result 
   is found scanning will stop automatically (you can change this behaviour 
   with cancelOnResult:). When the user dismisses self.identificationView this
   method will get called again.
 */
- (void)startAnyline {
    [self startPlugin:self.mrzScanViewPlugin];
    self.startTime = CACurrentMediaTime();
}

- (IBAction)infoPressed:(id)sender {
    ALTutorialViewController *vc = [[ALTutorialViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- AnylineMRZModuleDelegate

/*
 This is the main delegate method Anyline uses to report its results
 */
- (void)anylineIDScanPlugin:(ALIDScanPlugin *)anylineIDScanPlugin didFindResult:(ALIDResult *)scanResult {
    ALMRZIdentification *identification = (ALMRZIdentification*)scanResult.result;
    
    [self.mrzScanViewPlugin stopAndReturnError:nil];
    //MRZ Fields
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname" value:[identification surname]]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names" value:[identification givenNames]]];
    
    [resultData addObject:[self resultEntryWithDate:[identification dateOfBirthObject] dateString:[identification dateOfBirth] title:@"Date of Birth"]];
    [resultData addObject:[self resultEntryWithDate:[identification dateOfExpiryObject] dateString:[identification dateOfExpiry] title:@"Date of Expiry"]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Type" value:[identification documentType] isMandatory:NO]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Document Number" value:[identification documentNumber] shouldSpellOutValue:YES]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Nationality" value:[identification nationalityCountryCode] isMandatory:NO]];
    
    if (identification.personalNumber.trimmed.length > 0) {
        [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Personal Number" value:[identification personalNumber] isMandatory:NO]];
    }
    
    //VIZ Fields
    NSMutableArray <ALResultEntry*> *vizResultData = [[NSMutableArray alloc] init];
    if (identification.vizSurname.trimmed.length > 0) {
        [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Surname"
                                                                value:[identification vizSurname]]];
    }
    
    if (identification.vizGivenNames.trimmed.length > 0) {
      [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Given Names"
                                                              value:[identification vizGivenNames]]];
    }
    if (identification.vizAddress.trimmed.length > 0) {
        [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Address"
                                                                value:[identification vizAddress] isMandatory:NO]];
    }
    if (identification.vizDateOfBirth.trimmed.length > 0) {
        [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfBirthObject]
                                                dateString:[identification vizDateOfBirth]
                                                     title:@"Date of Birth"]];
    }
    if (identification.vizDateOfIssue.trimmed.length > 0) {
        [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfIssueObject]
                                                dateString:[identification vizDateOfIssue]
                                                     title:@"Date of Issue"]];
    }
    if (identification.vizDateOfExpiry.trimmed.length > 0) {
        [vizResultData addObject:[self resultEntryWithDate:[identification vizDateOfExpiryObject]
                                                dateString:[identification vizDateOfExpiry]
                                                     title:@"Date of Expiry"]];
    }
    
    if (identification.personalNumber.trimmed.length > 0) {
        [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Personal Number"
                                                                value:[identification personalNumber] isMandatory:NO]];
    }
    
    [vizResultData addObject:[[ALResultEntry alloc] initWithTitle:@"Sex"
                                                            value:[identification sex] isMandatory:NO]];
    
    [resultData addObjectsFromArray:vizResultData];
    resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;
    NSString *jsonString = [self jsonStringFromResultData:resultData];
    
    [self anylineDidFindResult:jsonString
                 barcodeResult:@""
                     faceImage:[identification faceImage]
                        images:@[scanResult.image]
                    scanPlugin:anylineIDScanPlugin
                    viewPlugin:self.mrzScanViewPlugin
                    completion:^{
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData
                                                                                  image:scanResult.image
                                                                              faceImage:[identification faceImage]
                                                                   shouldShowDisclaimer:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }];
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
