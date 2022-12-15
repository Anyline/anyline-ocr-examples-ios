#import "ALBaseScanViewController.h"
#import "ALIDCountryHelper.h"
#import <Anyline/Anyline.h>

extern NSString * const kArabicIDTitleString;

extern NSString * const kCyrillicIDTitleString;

extern NSString * const kDriversLicenseTitleString;

extern NSString * const kPassportVisaTitleString;

extern NSString * const kIDCardTitleString;

@interface ALUniversalIDScanViewController : ALBaseScanViewController

@property (nonatomic, assign) ALScriptType scriptType;

@end
