#import <Foundation/Foundation.h>
#import "Exception/anyline_exception.h"
#include "License/license_exception.h"

@interface NSError (CPPWrapper)

+ (NSError *)AL_errorFromSyntaxException:(al::SyntaxException)syntaxException;

+ (NSError *)AL_errorFromAnylineException:(al::AnylineException)anylineException;

+ (NSError *)AL_errorFromLicenseException:(al::license::LicenseException)licenseException;

+ (NSError *)AL_errorFromArgumentException:(al::ArgumentException)argumentException;

+ (NSError *)AL_errorFromRunFailure:(al::RunFailure)runFailure;

+ (NSError *)AL_errorFromAssetException:(al::AssetException)assetException;

@end
