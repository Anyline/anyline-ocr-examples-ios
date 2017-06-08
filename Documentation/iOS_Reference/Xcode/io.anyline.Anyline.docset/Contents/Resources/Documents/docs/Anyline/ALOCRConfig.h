//
//  ALOCRConfig.h
//  Anyline
//
//  Created by Daniel Albertini on 21/03/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  Predefined Regex examples as NSString
 *  This examples can be used for several usecases
 *  If you use a regex please also use the matching charWhiteList
 */
extern NSString * _Nonnull const regexForEmail;
extern NSString * _Nonnull const regexForURL;
extern NSString * _Nonnull const regexForPriceTag;
extern NSString * _Nonnull const regexForISBN;
extern NSString * _Nonnull const regexForVIN;
extern NSString * _Nonnull const regexForIMEI;

/*
 *  Predefined charWhiteList examples as NSString
 *  This examples can be used for several usecases
 *  If you use a charWhiteList please also use the matching regex
 */
extern NSString * _Nonnull const charWhiteListForEmail;
extern NSString * _Nonnull const charWhiteListForURL;
extern NSString * _Nonnull const charWhiteListForPriceTag;
extern NSString * _Nonnull const charWhiteListForISBN;
extern NSString * _Nonnull const charWhiteListForVIN ;
extern NSString * _Nonnull const charWhiteListForIMEI;

/**
 *  ALRange struct to define min & max charHeight for scanning.
 */
struct ALRange {
    NSUInteger min;
    NSUInteger max;
};
typedef struct ALRange ALRange;

/**
 *  Creates a range with min & max parameter
 *
 *  @param min The min value for the range
 *  @param max The max value for the range
 *
 *  @return New ALRange object with min & max values
 */
CG_INLINE ALRange ALRangeMake(NSUInteger min, NSUInteger max) {
    ALRange r;
    r.min = min;
    r.max = max;
    return r;
}

/**
 *  The possible scanModes for the AnylineOCR module
 */
typedef NS_ENUM(NSInteger, ALOCRScanMode) {
    /**
     *  The LINE mode is optimal for scanning one or more lines of variable length or font (like IBANs or addresses).
     */
    ALLine,
    /**
     *  The GRID mode is optimal for characters with equal size laid out in a grid
     *  with a constant font, background and character count (like loyalty codes inside bottle caps).
     */
    ALGrid,
    /**
     * The AUTO mode is optimal if you want to scan more than one use case in one mode. This mode automatically
     * tries to identify the to be scanned text within the cutout, and adjust the parameters accordingly.
     * @see <a href="https://documentation.anyline.io/toc/modules/anyline_ocr/index.html#scanmode-auto">Anyline OCR Auto Mode - Anyline Documentation</a>
     */
    ALAuto
};

/**
 *  A class used to configure the Anyline OCR module.
 */
@interface ALOCRConfig : NSObject

- (instancetype _Nullable)initWithJsonDictionary:(NSDictionary * _Nonnull)configDict;

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
 *  Property to set the tesseract tessdata files as Array of Strings. ex. @[@"eng",@"deu"]
 */
@property (nullable, nonatomic, strong) NSArray<NSString *> *tesseractLanguages;
/**
 *  Property for the character whitelist you would like to use.
 */
@property (nullable, nonatomic, strong) NSString *charWhiteList;
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

- (NSDictionary * _Nullable)startVariablesOrError:(NSError * _Nullable * _Nullable)error;

- (NSString * _Nullable)toJsonString;

@end
