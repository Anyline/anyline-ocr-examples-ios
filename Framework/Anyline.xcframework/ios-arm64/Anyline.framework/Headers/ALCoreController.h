//
//  ALCoreController.h
//  Anyline
//
//  Created by Daniel Albertini on 25.03.13.
//  Copyright (c) 2013 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALImageProvider.h"
#import "ALAssetController.h"

@class ALImage;

@protocol ALCoreControllerDelegate;

/**
 *  The Anyline Controller is the small but powerful interface to our image 
 *  processing / text recognition. Loaded with different Configurations files it
 *  can execute totally different tasks.
 */
@interface ALCoreController : NSObject

/**
 *  With this boolean you can control if the SDK runs on an async queue
 *  or if you want to run it on your current thread.
 */
@property (nonatomic, assign) BOOL asyncSDK;

@property (nonatomic, assign, getter=isRunning) BOOL running;

@property (nonatomic, assign, getter=isSingleRun) BOOL singleRun;

/**
 *  The delegate property.
 *  You must set the delegate if you want to get any results out 
 *  of the Anyline SDK.
 */
@property (nonatomic, weak) id<ALCoreControllerDelegate> _Nullable delegate;

/**
 *  Initializes a new ALCoreController with a delegate. In order
 *  to correctly run Anyline you will have to load an appropriate configuration.
 *
 *  @param delegate         The delegate where for the Anyline callbacks.
 *
 *  @return A new instance of ALCoreController.
 */
- (instancetype _Nullable)initWithDelegate:(id<ALCoreControllerDelegate> _Nullable)delegate error:(NSError *_Nullable*_Nullable)error;

/**
 This method initialises the core without loading any scripts
 *  @param error will be set to nil if setup is finished, or an error object when setup failed.
 * @return whether setup succeeded
 */
- (BOOL)initCoreWithError: (NSError *_Nullable *_Nullable)error;

/**
 *  This method loads the Anyline SDK with an configuration string.
 *
 *  @param script     The string which represents the configuration.
 *  @param bundlePath The bundlePath where the additional ressources are located.
 *  @param product The product identifier
 *  @param assetController The asset controller, if there is one
 *  @param error will be set to nil if setup is finished, or an error object when setup failed.
 */
- (BOOL)loadScript:(NSString *_Nonnull)script
        bundlePath:(NSString *_Nonnull)bundlePath
           product:(NSString *_Nonnull)product
   assetController:(ALAssetController *_Nullable)assetController
             error:(NSError *_Nullable *_Nullable)error;

/**
 *  This method loads the Anyline SDK with an configuration string.
 *
 *  @param script     The string which represents the configuration.
 *  @param scriptName The filename of the script.
 *  @param bundlePath The bundlePath where the additional ressources are located.
 *  @param product The product identifier
 *  @param assetController The asset controller, if there is one
 *  @param error will be set to nil if setup is finished, or an error object when setup failed.
 */
- (BOOL)loadScript:(NSString *_Nonnull)script
        scriptName:(NSString *_Nonnull)scriptName
        bundlePath:(NSString *_Nonnull)bundlePath
           product:(NSString *_Nonnull)product
   assetController:(ALAssetController *_Nullable)assetController
             error:(NSError *_Nullable *_Nullable)error;

/**
 *  This method loads the Anyline SDK with an configuration file which is located 
 *  at the bundlePath. The configuration must ether be an .alc unencrypted file 
 *  or an .ale encrypted file.
 *
 *  @param cmdFileName Configuration filename. Ether .alc or .ale. Located at 
 *                     the bundlePath
 *  @param bundlePath  The bundlePath where the configuration and the additional 
 *                     ressources are located.
 *  @param product The product identifier
 *  @param assetController The asset controller, if there is one  
 *  @param error will be set to nil if setup is finished, or an error object when setup failed.
 */
- (BOOL)loadCmdFile:(NSString *_Nonnull)cmdFileName
         bundlePath:(NSString *_Nonnull)bundlePath
            product:(NSString *_Nonnull)product
    assetController:(ALAssetController *_Nullable)assetController
              error:(NSError *_Nullable *_Nullable)error;

/**
 *  Starts a continious image processing workflow where the images are provided from the 
 *  image provider interface. Should for example be called in the viewDidAppear:
 *
 *  @param imageProvider The image provider which is responsible for providing the frames for the
 *                       computation.
 *  @param error         The error if the processing can not be started.
 *
 *  @return Boolean indicating the success / failure of the start process.
 */
- (BOOL)startWithImageProvider:(id<ALImageProvider> _Nonnull)imageProvider error:(NSError *_Nullable *_Nullable)error;

/**
 *  Starts a continious image processing workflow where the images are provided from the
 *  image provider interface. Should for example be called in the viewDidAppear:
 *
 *  @param imageProvider    The image provider which is responsible for providing the frames for the
 *                          computation.
 *  @param startVariables   Variables which will be added to the process and can be referenced in the
 *                          Anyline Command File.
 *  @param error            The error if the processing can not be started.
 *
 *  @return Boolean indicating the success / failure of the start process.
 */
- (BOOL)startWithImageProvider:(id<ALImageProvider> _Nonnull)imageProvider
                startVariables:(NSDictionary *_Nullable)startVariables
                         error:(NSError *_Nullable *_Nullable)error;

/**
 *  Stops a previously started image processing workflow. Should be called ex. in viewDidDisappear:
 *  or viewWillDisappear:
 *
 *  @param error The error if processing workflow could not be stopped
 *
 *  @return Boolean indicating the success / failure of the stop.
 */
- (BOOL)stopAndReturnError:(NSError *_Nullable *_Nullable)error;


/**
 *  Starts a single image run with an UIImage.
 *
 *  @param image The image or video frame which should be processed. This image is referenced as $image
 *               in the .alc configuation file.
 *  @param error If an error occured while trying to start processing, it is passed here.
 *
 *  @return BOOL indicating if the processing could be started.
 */
- (BOOL)processImage:(UIImage *_Nonnull)image error:(NSError *_Nullable *_Nullable)error;

/**
 *  Starts a single image run with an UIImage and a start variable dictionary.
 *
 *  @param image     The image or video frame which should be processed. This image is referenced as $image
 *                   in the .alc configuation file.
 *  @param variables Variables which will be added for this single process. They can be used and 
 *                   controlled in the .alc files. @see ALConfig for global config variables.
 *  @param error     If an error occured while trying to start processing, it is passed here.
 *
 *  @return BOOL indicating if the processing could be started.
 */
- (BOOL)processImage:(UIImage *_Nonnull)image
      startVariables:(NSDictionary *_Nullable)variables
               error:(NSError *_Nullable *_Nullable)error;

/**
 *  Starts a single image run with an ALImage.
 *
 *  @param alImage The image or video frame which should be processed. This image is referenced as $image
 *                 in the .alc configuation file.
 *  @param error   If an error occured while trying to start processing, it is passed here.
 *
 *  @return BOOL indicating if the processing could be started.
 */
- (BOOL)processALImage:(ALImage *_Nonnull)alImage error:(NSError *_Nullable *_Nullable)error;

/**
 *  Starts a single image run with an ALImage and a start variable dictionary.
 *
 *  @param alImage   The image or video frame which should be processed. This image is referenced as $image
 *                   in the .alc configuation file.
 *  @param variables Variables which will be added for this single process. They can be used and
 *                   controlled in the .alc files. @see ALConfig for global config variables.
 *  @param error     If an error occured while trying to start processing, it is passed here.
 *
 *  @return BOOL indicating if the processing could be started.
 */
- (BOOL)processALImage:(ALImage *_Nonnull)alImage
        startVariables:(NSDictionary *_Nullable)variables
                 error:(NSError *_Nullable *_Nullable)error;

/**
 *  Sets a parameter with a key in the Interpreter.
 *
 *  @param parameter Parameter to set.
 *  @param key       The key for the parameter.
 */
- (void)setParameter:(id _Nonnull )parameter forKey:(NSString *_Nonnull)key;

/**
 *  The Version number of the current Anyline framework.
 *
 *  @warning The Anyline SDK must be added to the Copy Bundle Ressources
 *           to make this method work correctly.
 *
 *  @return The Version number as String
 */
+ (NSString *_Nonnull)versionNumber;

/**
 *  The Build number of the current Anyline framework.
 *
 *  @warning The Anyline SDK must be added to the Copy Bundle Ressources
 *           to make this method work correctly.
 *
 *  @return The Build number as String
 */
+ (NSString *_Nonnull)buildNumber;


/**
 *  Expiration Date of a License Key.
 *
 *  @param licenseKey A NSString containing the licenseKey
 *
 *  @return license expiration Date as NSString
 */
+ (NSString *_Nullable)licenseExpirationDateForLicense:(NSString *_Nonnull)licenseKey;

+ (NSBundle *_Nonnull)frameworkBundle;

/**
 * Reporting ON Switch, off by default
 *
 * @param enable if YES, anyline will report for QA failed scan tries. Use reportImageForLog in ALC file, 
 *               and use the reportScanResultState: for reporting
 */
- (void) enableReporting:(BOOL) enable;

- (void)reportIncludeValues:(NSString *_Nonnull)values;

- (NSArray *_Nonnull)runStatistics;

/**
 *  Adds a statement to pass down to the core headers
 *
 *
 *  @param key The name for the value.
 *  @param value The value passed down.
 */
- (void)addHeaderStatementKey:(NSString *_Nonnull)key andValue:(id _Nonnull)value;

@end

/**
 *  The ALCoreController Delegate methods must be implemented to get results of the Anyline processing.
 *  All delegate callbacks are garanteed to be executed in the Main Thread.
 */
@protocol ALCoreControllerDelegate <NSObject>

@required

/**
 *  Tells the delegate that the processing has successfully finished and gives the delegate the final
 *  output object.
 *
 *  This delegate method must be inplemented to receive any results from the AnylineSDK
 *
 *  @param object The result object of the processing.
 *                The result is specified with the RETURN statement in the .alc file.
 */
- (void)anylineCoreController:(ALCoreController *_Nonnull)coreController didFinishWithOutput:(id _Nonnull)object;

@optional

/**
 *  Tells the delegate that the processing has not completed successfully. Possible reason would be 
 *  for example that the display or paper frame could not be found.
 *
 *  @param reason A NSError object with ALErrorDomain and an appropriate status.
 */
- (void)anylineCoreController:(ALCoreController *_Nonnull)coreController didAbortRun:(NSError * _Nonnull)reason;

/**
 *  Tells the delegate a specified intermediate result. Which intermediate results are reported
 *  can be specified in the .alc command file with the REPORT function.
 *
 *  This method is optional. It provides intermediate results, therefore Anyline did not completed the
 *  task yet.
 *
 *  @param variableName The variable name in the .alc file which should be reported.
 *  @param value        The value of the reported variable.
 */
- (void)anylineCoreController:(ALCoreController *_Nonnull)coreController
              reportsVariable:(NSString *_Nonnull)variableName
                        value:(id _Nonnull)value;

/**
 *  Tells the delegate that there was a parsing error.
 *
 *  If this method is not implemented the SDK raises an exception with the parsing error.
 *
 *  @param error The parsing error which occured.
 */
- (void)anylineCoreController:(ALCoreController *_Nonnull)coreController parserError:(NSError *_Nonnull)error;

- (void)reportIncludeFullFrame:(ALImage *_Nonnull)image cropRect:(CGRect)rect;

@end
