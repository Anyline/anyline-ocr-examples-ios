//
//  ALLivenessVerificationViewController.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 18.01.21.
//

#import "ALFaceAuthentificationViewController.h"
#import "ALResultEntry.h"
#import "ALResultViewController.h"
#import <MessageUI/MessageUI.h>

#import "AnylineExamples-Swift.h"

#import "ALUniversalIDFieldnameUtil.h"
#import "ALSelectionTable.h"

#import "ALIdentityDocumentsExampleManager.h"
#import "ALScriptSelectionViewController.h"

#import <FaceTecSDK/FaceTecSDK.h>
#import "AnylineExamples-Swift.h"
#import "ALUtils.h"

#import <AnylineFaceAuthentication/AnylineFaceAuthentication.h>
#import <AnylineFaceAuthentication/AnylineFaceAuthentication-Swift.h>

#import "UIViewController+ALExamplesAdditions.h"

/*
 * Configuration
 */
NSString * const kScanIDLabelText = @"Scan your ID";

@interface ALFaceAuthentificationViewController ()<FaceAuthenticationDelegate, ALScriptSelectionDelegate>


@property (nonatomic, strong) NSMutableString *resultHistoryString;

@property (nonatomic, strong) FaceAuthenticationPluginController *faceAuthenticationViewController;

@end

@implementation ALFaceAuthentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    BOOL success = [AnylineFaceAuthenticationSDK.sdk setupDevelopmentModeWithAnylineLicenseKey:kDemoAppLicenseKey
                                                                                         error:&error
                                                                                    completion:^(BOOL success) {
        NSAssert(success, @"Init failed");
        
        self.faceAuthenticationViewController = [AnylineFaceAuthenticationSDK.sdk createViewControllerWithDelegate:self];
        
        [self addChildViewController:self.faceAuthenticationViewController];
        [self.view addSubview:self.faceAuthenticationViewController.view];
        [self.faceAuthenticationViewController didMoveToParentViewController:self];
        
    }];
    NSAssert(success, @"Init failed");
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -- FaceVerificationDelegate Delegate

- (void)onErrorWithFaceAuthenticationController:(FaceAuthenticationPluginController * _Nonnull)faceAuthenticationController
                                          error:(NSError * _Nonnull)error {
    if (error.code == 18446744073709550607) {
        [self showAlertWithTitle:@"No Internet Connection"
                         message:@"Face Authentication requires an Internet connection. Make sure that you are connected and start again."
                  dismissHandler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self showAlertWithTitle:@"Error"
                         message:@"Something went wrong, please try again later."
                  dismissHandler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)onFaceAuthenticationCompletedWithFaceAuthenticationController:(FaceAuthenticationPluginController * _Nonnull)faceAuthenticationController
                                                       livenessResult:(id<FaceTecSessionResult> _Nonnull)livenessResult
                                                           scanResult:(ALIDResult<id> * _Nonnull)scanResult
                                                                match:(BOOL)match
                                                           matchLevel:(NSInteger)matchLevel {
    NSLog(@"Finished the whole process. Starting Result controller");
    // Handle a UniversalID result
    ALUniversalIDIdentification *identification = (ALUniversalIDIdentification *)scanResult.result;
    NSMutableString *resultHistoryString = [NSMutableString string];
    NSMutableArray <ALResultEntry*> *resultData = [[NSMutableArray alloc] init];
    
    [resultData addObjectsFromArray:[ALUniversalIDFieldnameUtil addIDSubResult:identification titleSuffix:@"" resultHistoryString:resultHistoryString]];
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Detected Country" value:identification.layoutDefinition.country]];
    resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;
    
    NSString *matchString = @"";
    
    switch (matchLevel) {
        case 1:
            matchString = @"99%";
            break;
        case 2:
            matchString = @"99.6%";
            break;
        case 3:
            matchString = @"99.8%";
            break;
        case 4:
            matchString = @"99.9%";
            break;
        case 5:
            matchString = @"99.99%";
            break;
        case 6:
            matchString = @"99.999%";
            break;
        case 7:
            matchString = @"99.9998%";
            break;
        
        default:
            matchString = @"Failed";
            break;
    }
    
    [resultData addObject:[[ALResultEntry alloc] initWithTitle:@"Face Match Level" value:matchString]];
    
    resultData = [ALUniversalIDFieldnameUtil sortResultDataUsingFieldNamesWithSpace:resultData].mutableCopy;
    
    NSString *jsonString = [self jsonStringFromResultData:resultData];

    UIImage *faceImage = [self stringToUIImage:livenessResult.auditTrailCompressedBase64[0]];
    [self anylineDidFindResult:jsonString
                 barcodeResult:@""
                     faceImage:[scanResult.result faceImage]
                        images:@[scanResult.image, faceImage]
                    scanPlugin:nil
                    viewPlugin:nil
                    completion:^{
        
        
        
        ALResultViewController *vc = [[ALResultViewController alloc] initWithResultData:resultData
                                                                                  image:scanResult.image
                                                                          optionalImage:faceImage
                                                                              faceImage:[scanResult.result faceImage]
                                                                   shouldShowDisclaimer:YES];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    

    NSLog(@"Finished the whole process. Finished launching result");
}

-(UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
