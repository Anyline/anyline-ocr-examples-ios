//
//  ALOCRConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBaseOCRConfig.h"
#import "ALDefStruct.h"

/**
 *  A class used to configure the Anyline OCR scan plugin.
 */
@interface ALOCRConfig : ALBaseOCRConfig

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict
                                           error:(NSError * _Nullable * _Nullable)error;
/**
 *  The scan mode.
 *  @see ALOCRScanMode
 */
@property (nonatomic, assign) ALOCRScanMode scanMode;
/**
 *  Property to set a custom command file (path not string) to improve scanning for your use-case.
 *  Get in touch with Anyline to receive your custum command file.
 */
@property (nullable, nonatomic, strong) NSString *customCmdFilePath;
/**
 *  Property to set a custom command file (string not path) to improve scanning for your use-case.
 *  Get in touch with Anyline to receive your custum command file.
 */
@property (nullable, nonatomic, strong) NSString *customCmdFileString;
/**
 *  Property to set the character height.
 */
@property (nonatomic, assign) ALRange charHeight;

/**
 *  Property to set the any file as an absolute String paths to the file.
 *
 *  Note this method requires the full path with fileending and not only the file name like the old deprecated method.
 */
@property (nullable, nonatomic, strong) NSString *model __deprecated_msg("Deprecated since Anyline 33. Use property models instead.");

/**
 *  Property to set the any file as an array of absolute String paths to the file. If a relative path is given we search all NSBundle
 *
 */
@property (nullable, nonatomic, strong) NSArray<NSString *> *models;

/**
 *  Property to set the any files as Array of String paths to the files.
 *
 *  Note this method requires the full path with fileending and not only the file name like the old deprecated method.
 *
 *  Warning Only the first model will be used.
 */
@property (nullable, nonatomic, copy, readonly) NSArray<NSString *> *languages __deprecated_msg("Deprecated since Anyline 26. Use property model instead.");

/**
 Set languages without loading them yet (useful if the language files are to be downloaded from Anyline Trainer)
 */
- (void)setLanguages:(NSArray<NSString *> * _Nonnull)languages __deprecated_msg("Deprecated since Anyline 26. Use property model instead.");

- (BOOL)hasLanguages __deprecated_msg("Deprecated since Anyline 26. Check property model instead.");

/**
 Set languages and immediately attempt to load them.
 
 Warning Only the first model will be used.
 */
- (BOOL)setLanguages:(NSArray<NSString *> * _Nonnull)languages error:(NSError * _Nullable * _Nullable)error __deprecated_msg("Deprecated since Anyline 26. Use property model instead.");
/**
 *  Property for the character whitelist you would like to use.
 */
@property (nullable, nonatomic, strong) NSString *characterWhitelist;

/**
 *  Property for the validation regex.
 */
@property (nullable, nonatomic, strong) NSString *validationRegex;
/**
 *  The min confidence to accept the result. Between 0-100, but should normally be at least 50.
 *  The spped / accurracy of Anyline can be controlled with this property.
 */
@property (nonatomic, assign) NSUInteger minConfidence;
/**
 *  Removes small contours as noise.
 *
 *  This property is for Line mode only.
 *
 *  @warming Do not use activate this property when scanning for example i dots or :.
 *           This would remove those contours.
 */
@property (nonatomic, assign) BOOL removeSmallContours;
/**
 * Set this to true if whitespaces should be removed within a line.
 * Also causes faster processing, because optimizations can be made if whitespaces are not relevant.
 * (only used in {@link ScanMode#LINE} mode)
 *
 * @param removeWhitespaces true if whitespaces should be removed
 */
@property (nonatomic, assign) BOOL removeWhitespaces;
/**
 * <p>
 * Experimental parameter to set the minimum sharpness (value between 0-100; 0 to turn sharpness detection off;
 * only used in {@link ScanMode#LINE}).
 *
 * The goal of the minimum sharpness is to avoid a time consuming ocr step,
 * if the image is blurry and good results are therefor not likely. Detecting sharpness is however difficult,
 * good values for the minimum are use case dependent.
 *
 * The detected sharpness will be reported in anylineOCRModuleView:reportsVariable:value: with identifier
 * "$sharpness" and also in error message in anylineOCRModuleView:reportsRunFailure:,
 * if the minimum sharpness is not reached (with the error code ALOCRErrorSharpnessNotReached).
 * </p><p>
 * <b>NOTE: Experimental means that this may be removed or changed in the future.</b>
 * </p>
 *
 * @since 3.4.1
 */
@property (nonatomic, assign) NSUInteger minSharpness;
/**
 *  The X character count
 *
 *  This property is for Grid mode only.
 */
@property (nonatomic, assign) NSUInteger charCountX;
/**
 *  The Y character count
 *
 *  This property is for Grid mode only.
 */
@property (nonatomic, assign) NSUInteger charCountY;
/**
 *  The average distance between characters in X direction,
 *  measured in percentage of character width.
 *
 *  This property is for Grid mode only.
 */
@property (nonatomic, assign) double charPaddingXFactor;
/**
 *  The average distance between characters in Y direction,
 *  measured in percentage of character height.
 *
 *  This property is for Grid mode only.
 */
@property (nonatomic, assign) double charPaddingYFactor;
/**
 *  YES to set to bright text on dark background,
 *  NO to set to dark text on bright background.
 *
 *  This property is for Grid mode only.
 */
@property (nonatomic, assign) BOOL isBrightTextOnDark;

- (NSDictionary * _Nullable)startVariablesOrError:(NSError * _Nullable * _Nullable)error assetPath:(NSString *_Nullable)assetPath;

- (NSString * _Nullable)toJsonString;

@end
