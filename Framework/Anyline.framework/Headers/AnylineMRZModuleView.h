//
//  AnylineMRZModuleView.h
//  
//
//  Created by Daniel Albertini on 29/06/15.
//
//

#import "AnylineAbstractModuleView.h"
#import "ALMRZResult.h"
#import "ALMRZScanViewPlugin.h"

@protocol AnylineMRZModuleDelegate;

/**
 * The AnylineMRZModuleView class declares the programmatic interface for an object that manages easy access to Anylines MRZ scanning mode.
 * All its capabilities are bundled into this AnylineAbstractModuleView subclass. Management of the scanning process happens within the view object.
 * It is configurable via interface builder.
 *
 * Communication with the host application is managed with a delegate that conforms to AnylineMRZModuleDelegate. The information that gets read is passed to the delegate with the help of of an ALIdentification object.
 *
 */
@interface AnylineMRZModuleView : AnylineAbstractModuleView

@property (nullable, nonatomic, strong) ALMRZScanViewPlugin *mrzScanViewPlugin;

@property (nullable, nonatomic, strong) ALMRZScanPlugin *mrzScanPlugin;

/**
 *  Sets the license key and delegate.
 *
 *  @param licenseKey The Anyline license key for this application bundle
 *  @param delegate The delegate that will receive the Anyline results (hast to conform to <AnylineMRZModuleDelegate>)
 *  @param error The error that occured
 *
 *  @return Boolean indicating the success / failure of the call.
 */
- (BOOL)setupWithLicenseKey:(NSString * _Nonnull)licenseKey
                   delegate:(id<AnylineMRZModuleDelegate> _Nonnull)delegate
                      error:(NSError * _Nullable * _Nullable )error;

@end

@protocol AnylineMRZModuleDelegate <NSObject>

@optional
/**
 *  Returns the scanned value
 *
 *  @param anylineMRZModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *  @param allCheckDigitsValid Boolean indicating if all check digits in the MRZ Zone are valid.
 *  @param image The image that was used to scan the code
 *
 *  @deprecated since 3.10
 */
- (void)anylineMRZModuleView:(AnylineMRZModuleView * _Nonnull)anylineMRZModuleView
           didFindScanResult:(ALIdentification * _Nonnull)scanResult
         allCheckDigitsValid:(BOOL)allCheckDigitsValid
                     atImage:(UIImage * _Nonnull)image __deprecated_msg("Deprecated since 3.10. Use method anylineMRZModuleView:didFindScanResult: instead.");

@required

/**
 *  Returns the scanned value
 *
 *  @param anylineMRZModuleView The view that scanned the result
 *  @param scanResult The scanned value
 *
 *  @since 3.10
 */
- (void)anylineMRZModuleView:(AnylineMRZModuleView * _Nonnull)anylineMRZModuleView
               didFindResult:(ALMRZResult * _Nonnull)scanResult;

@end
