//
//  ALLivenessVerificationViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18.01.21.
//

#import "ALFaceAuthentificationViewController.h"
#import <AnylineFaceAuthentication/AnylineFaceAuthentication-Swift.h>
#import "ALAppDemoLicenses.h"
#import "UIFont+ALExamplesAdditions.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"
#import "ALUniversalIDFieldnameUtil.h"

#define kPublicProdFaceScanEncryptionKey \
@"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAylyQZr7haCsQ5OeBGZP0\nMA+k5z6iLu1XrCfQOHsBzNRe67aScP0CPwTQ+gDy+h0keQunBgShvb2ZN67LuHtO\nxbtJhXTrSJ6m8wSb0jHYaUZpjgjgsv+6ig1aXOAxidx+Vd7zwfBy7WjhNSJgTNU+\nY1lY1ZVlj1nY4lqfgCtC7t0Y6qenIL6KmSebQRrB+RjcO77HKj2bxNpq8roZj0JD\nFG1Asd9l3LqYKS4gX1dqbSgLLtLAAhcBMpHF/HqtnaJQpe1f9lfZt7H3UTBdZdOQ\nuluf4QteyPxVT1vKV2FIjU6hXGjLgcTjn0FLyM2w38tOOYS8zlNYdliZ272l5uxh\nQQIDAQAB\n-----END PUBLIC KEY-----"

@interface ALFaceAuthentificationViewController() <AnylineFaceAuthenticationDelegate, NSURLSessionDelegate>

@property (nonatomic, retain) FaceAuthenticationViewController *faceAuthenticationViewController;

@property (nonatomic, retain) UIButton *restartButton;

@property (nonatomic, retain) UITextView *infoView;

@end


@implementation ALFaceAuthentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // prevent the FaceAuth sub-view from showing under the navbar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    if (![self checkFaceAuthCapability]) {
        return;
    }
    
    [self getFaceTecProductionKey:^(NSString * _Nullable key, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error trying to get FaceTec production key: %@", [error localizedDescription]);
            return;
        }
        
        AnylineFaceAuthenticationSDK *sdk = [AnylineFaceAuthenticationSDK sdk];

        [sdk setupProdModeWithAnylineLicenseKey:kDemoAppLicenseKey
                                  encryptionKey:kPublicProdFaceScanEncryptionKey
                           faceTecLicenseString:key
                            deviceKeyIdentifier:@"dtBkVYeM01q8U5VTykshIXNkq4xbWIy4"
                                    endpointUrl:@"https://face.anyline.com/v1"
                                     completion:^(BOOL success, NSError * _Nullable error) {
            
            if (error) {
                NSString *title = @"Error";
                NSString *message = error.localizedDescription;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSAssert(false, @"Init failed");
                }];
                [alertController addAction:dismissAction];
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            self.faceAuthenticationViewController = [sdk createViewControllerWithDelegate:self facetecConfig:nil];
            [self configureViews];
            [self installFaceAuthVC];
        }];
    }];
}

/// Adds the AnylineFaceAuthenticationViewController as a child to this view controller
- (void)installFaceAuthVC {
    NSAssert(self.faceAuthenticationViewController != nil, @"faceAuthVC should not be nil");

    [self addChildViewController:self.faceAuthenticationViewController];
    [self.view addSubview:self.faceAuthenticationViewController.view];

    // constraints
    UIView *faceView = self.faceAuthenticationViewController.view;
    faceView.translatesAutoresizingMaskIntoConstraints = NO;

    [faceView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [faceView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [faceView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [faceView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-50].active = YES;

    [self.faceAuthenticationViewController didMoveToParentViewController:self];
}

- (void)configureViews {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addTarget:self action:@selector(didPressRetryButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"START OVER" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:1 alpha:1]];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    [btn.titleLabel setFont:[UIFont AL_proximaSemiboldWithSize:22]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12.0f;
    
    [self.view addSubview:btn];
    
    [btn.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [btn.heightAnchor constraintEqualToConstant:60].active = YES;
    [btn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [btn.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20].active = YES;
        
    self.restartButton = btn;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = @"";
    [textView sizeToFit];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:textView];
    self.infoView = textView;

    [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20].active = YES;
    [textView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [textView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20].active = YES;
    [textView.bottomAnchor constraintEqualToAnchor:self.restartButton.topAnchor constant:-20].active = YES;
}

- (void)didPressRetryButton:(UIButton *)button {
    [self installFaceAuthVC];
}

- (void)removeFaceAuthVC {
    [self.faceAuthenticationViewController removeFromParentViewController];
    [self.faceAuthenticationViewController.view removeFromSuperview];
}

/// Checks the currently-set up license key whether it has the "FAU" (face authentication) scope. If it doesn't,
/// the demo will not run. Also returns whether the check succeeded or not.
- (BOOL)checkFaceAuthCapability {
    NSError *error;
    [[ALLicenseCheck sharedInstance] checkFaceAuthenticationSupport:&error];
    if (error != nil) {
        NSString *title = @"Error";
        NSString *message = [NSString stringWithFormat:@"There was a problem loading Face Authentication. The error: %@", error.localizedDescription];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        __weak __block typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

// MARK: - Misc

+ (NSString *)strForUniversalIDIdentification:(ALUniversalIDIdentification *)identification {
    
    NSMutableArray<NSString *> *identificationValues = [NSMutableArray arrayWithCapacity:6];
    NSArray *fieldNamesOfInterest = @[
        @"firstName", @"lastName", @"fullName", @"formattedDateOfBirth", @"formattedDateOfIssue",
        @"formattedDateOfExpiry", @"dateOfBirth", @"dateOfIssue", @"dateOfExpiry", @"documentNumber",
        @"documentType", @"issuingCountryCode", @"documentDiscriminator", @"personalNumber", @"sex",
        @"address", @"nationalityCountryCode", @"licenseClass", @"eyes", @"hair", @"height", @"weight",
        @"restrictions", @"endorsements", @"drivingLicenseString",
    ];
    for (NSString *fieldName in fieldNamesOfInterest) {
        if ([identification hasField:fieldName]) {
            [identificationValues addObject:[NSString stringWithFormat:@"%@: %@",
                                             fieldName,
                                             [identification valueForField:fieldName]]];
        }
    }
    return [identificationValues componentsJoinedByString:@"\n"];
}

// MARK: - FaceAuthenticationViewControllerDelegate

- (void)faceAuthentication:(AnylineFaceAuthenticationSDK *)faceAuthentication
        completedWithError:(NSError *)error {
    
    NSString *message = [NSString stringWithFormat:@"Something went wrong, please try again later. The error: %@", [error localizedDescription]];
    if (error.code == -1009) {
        message = @"Face Authentication requires an Internet connection. Make sure that you are connected and start again.";
    }
    
    self.infoView.text = message;
    [self.infoView sizeToFit];
    self.restartButton.hidden = NO;
}

- (void)faceAuthenticationProceedToLivenessCheck:(AnylineFaceAuthenticationSDK *)faceAuthentication {
}

- (void)faceAuthentication:(AnylineFaceAuthenticationSDK *)faceAuthentication
   completedWithScanResult:(ALIDResult<id> *)scanResult
          livenessDetected:(BOOL)livenessDetected
        livenessFaceBase64:(NSString *)livenessFaceBase64
                matchLevel:(enum MatchLevel)matchLevel {

    ALUniversalIDIdentification *identification = (ALUniversalIDIdentification *)scanResult.result;
    NSMutableString *resultHistoryString = [NSMutableString string];
    NSMutableArray<ALResultEntry *> *resultData = [NSMutableArray array];

    [resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil
                                     addIDSubResult:identification
                                     titleSuffix:@""
                                     resultHistoryString:resultHistoryString]];

    // include the country detected for this ID
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Country"
                                                         value:identification.layoutDefinition.country]];
    resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;

    NSString *matchString = [FaceAuthentication matchStringForLevelWithMatchLevel:matchLevel];
    ALResultEntry *matchResult = [[ALResultEntry alloc] initWithTitle:@"Match Level"
                                                                value:matchString
                                                  shouldSpellOutValue:YES];
    [resultData insertObject:matchResult atIndex:0];

    // Insert hardcoded liveness check "PASS" - I believe you can't get a failing liveness
    // check when you reach this point.
    NSString *livenessCheckResult = @"Failed";
    if (livenessDetected) {
        livenessCheckResult = @"Passed";
    }
    ALResultEntry *livenessResult = [[ALResultEntry alloc] initWithTitle:@"Liveness Check"
                                                                   value:livenessCheckResult
                                                     shouldSpellOutValue:YES];
    [resultData insertObject:livenessResult atIndex:0];

    UIImage *livenessFaceImage = nil;
    NSData *livenessFaceData = [[NSData alloc] initWithBase64EncodedString:livenessFaceBase64 options:0];
    if (livenessFaceData.length > 0) {
        livenessFaceImage = [[UIImage alloc] initWithData:livenessFaceData];
    }

    ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData
                                                                              image:scanResult.image
                                                                      optionalImage:livenessFaceImage
                                                                          faceImage:nil
                                                               shouldShowDisclaimer:YES];

    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - Miscellaneous

- (void)getFaceTecProductionKey:(void (^)(NSString * _Nullable key, NSError * _Nullable error))completion {
    
    NSString *finalUrl = @"https://face.anyline.com/key";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalUrl]];

    [request setHTTPMethod:@"GET"];
    [request addValue:@"kabdtnHLrN3xxf1W8dVoK59bCjG6xBIbrb7T9U45" forHTTPHeaderField:@"x-api-key"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *latestNetworkRequest = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            NSLog(@"Exception raised while attempting HTTPS call.");
            if (error == nil) {
                error = [NSError errorWithDomain:@"com.anyline.faceverification"
                                            code:106
                                        userInfo:@{ NSLocalizedDescriptionKey: @"Response data is nil" }];
            }
            completion(nil, error);
            return;
        }
    
        NSDictionary<NSString *, id> *responseJSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (responseJSONObject == nil) {
            NSLog(@"Exception raised while attempting HTTPS call.");
            if (error == nil) {
                error = [NSError errorWithDomain:@"com.anyline.faceverification"
                                            code:106
                                        userInfo:@{ NSLocalizedDescriptionKey: @"Response could not be parsed as JSON" }];
            }
            completion(nil, error);
            return;
        }
        NSString *appId = responseJSONObject[@"appId"];
        NSString *expiryDate = responseJSONObject[@"expiryDate"];
        NSString *key = responseJSONObject[@"key"];
        NSString *productionKeyString = [NSString stringWithFormat:@"appId = %@\nexpiryDate = %@\nkey = %@\n",
                                         appId, expiryDate, key];
        completion(productionKeyString, nil);
    }];
    
    [latestNetworkRequest resume];
    
}

@end
