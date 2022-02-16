//
//  ALDefStruct.h
//  Anyline
//
//  Created by Renato Neves Ribeiro on 26.01.22.
//  Copyright © 2022 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ALRange struct to define min & max charHeight for scanning.
 */
typedef struct {
    NSUInteger min;
    NSUInteger max;
} ALRange;

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
 *  The possible scanModes for the AnylineOCR plugin
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
     * @see <a href="https://documentation.anyline.com/toc/modules/anyline_ocr/index.html#scanmode-auto">Anyline OCR Auto Mode - Anyline Documentation</a>
     */
    ALAuto
};
