# Anyline SDK iOS Release Notes #


## Anyline SDK 3.7.1 ##
Release Date 2016-09-29

### Fixed ###
- A bug where libcurl will crash on some older iOS versions


## Anyline SDK 3.7.0 ##
Release Date 2016-09-23

### Improved ###
- Energy: speed improvements

### Fixed ###
- Energy: Serial number scanning
- better find resources algorithm


## Anyline SDK 3.6.1 ##
Release Date 2016-08-30

### Added ###
- Anyline Font optimised for Anyline OCR

### Improved ###
- nicer default UI Feedback


## Anyline SDK 3.6.0 ##
Release Date 2016-07-13

### New ###
- Includes a new OCR engine for the energy use cases to improve accuracy

### Fixed ###
- Watermark violation issues
- Exclude bundle from iCloud Backup
- added Anyline namespace to dispatch timer
- all config paramters are now ignored when using a custom script


## Anyline SDK 3.5.1 ##
Release Date 2016-06-07

### New ###
- added option to ignore whitespaces in AnylineOCR LINE mode (makes it faster)

### Improved ###
- MRZ: ~10-20% faster
- Energy: ~5-10% faster
- AnylineOCR:
- LINE: ~0-50% faster
- GRID: ~5-10% faster

### Updated ###
- Visual Scan Feedback updated for some use cases

### Fixed ###
- "Watermark not original" error message
- Check if AppDelegate has window


## Anyline SDK 3.5 ##
Release Date 2016-05-04

### New ###
- SDK:
- added configurable visual scan feedback

- Energy Module:
- new modes for analog meters with 4 main digits
- new modes for analog meters with 7 main digits
- new mode for analog meters with white background and 5 or 6 main digits
- new mode for analog gas meters with 6 main digits

### Improved ###
- Energy Module:
- Electric meter mode no longer requires a red area

- AnylineOCR:
- updated Voucher Code use-case with new Anyline Font
- updated ISBN use-case to scan codes starting with ISBN-10: or ISBN-13:

- Documentation:
- improved documentation on how to load a custom command file
- improved documentation on how to add an image to the cutout view config

- updated OpenSSL version

### Fixed ###
- Energy Module:
- fixed a bug that 11111 was often returned as result for some meter types
- AnylineOCR:
- fixed a bug where the reported text outline was positioned incorrectly if the cutout contained a crop
- fixed a bug where GRID mode would crash if min and maxCharHeight where not set


## Anyline SDK 3.4.1 ##
Release Date 2016-03-30

### New ###
- added experimental sharpness detection to Anyline OCR
- configure Anyline OCR via json
- set an image as cutout


## Anyline SDK 3.4 ##
Release Date 2016-02-18

### New ###
- added Anyline OCR module (generic module for custom use cases)
- added scanning of documents

### Improved ###
- Focus on tap
- MRZ speed
- Energy Module Interface
- Barcode Module Interface

### Fixed ###
- Flash Button Bugs
- A lot of typos in the interface documentation
- You can now set the scan mode before the setup method in the Energy module
- Automatic clean up when you forgot cancelScanning in the viewWillDisappear:


## Anyline SDK 3.3 ##
Release Date 2015-12-17

### New ###
- added scanning of heat meters
- added scanning of water meters
- added electric meter scanning with decimal place
- added scanning of generic digital meters

### Improved ###
- barcode scanning accuracy improved
- MRZ scanning: higher tolerance for targeting the IDs
- SDK interaction:
    - get the rect of the cutout to position your GUI around it
    - added a configurable offset the flash button
    - get information if the scanning is currently running

### Fixed ###
- various bugfixes in the configuration and the ui
- rare crashes when switching between scan modes


## Anyline SDK 3.2.2 ##
Release Date 2015-11-13

### Fixed ###
- flash button bugfixes
- update ALUIConfiguration bugfix

## Anyline SDK 3.2.1 ##
Release Date 2015-10-25

### Improved ###
- Barcode Module
- better and faster scanning
- Same barcode can now be scanned again (after 2 second timeout)
- MRZ Module
- more ID cards are now supported

### Changed ###
- AnylineBarcodeModuleDelegate: added delegate method which includes the barcode type.
- MRZ Identification
- new fields issuingCountryCode and nationalityCountryCode
- deprecated countryCode (Use above new fields instead.)
- AnylineMRZModuleDelegate: added delegate method which includes a boolean if all checkdigits where computed valid.

## Anyline SDK 3.2 RC5 ##
Release Date 2015-09-23

### Fixed ###
- a problem with auto flash in energy module

### New ###
- Added default reporting to Energy module (can be disabled)

## Anyline SDK 3.2 RC4 ##

### Fixed ###
- various minor bugs 

## Anyline SDK 3.2 RC3 ##

### Fixed ###
- different logo for watermark

## Anyline SDK 3.2 RC2 ##

### Fixed ###
- crash when community edition was resumed from background

## Anyline SDK 3.2 RC1 ##

### New ###
- Community Version
- New Licensing (Update requires new License Key)
- New internal build system with nightly tests

### Improved ###
- Energy Module: Electric Meter scan improved (better 6-7 digit distinction, less errors)

### Fixed ###
- CameraOpenListener in Modules not called
- Setting barcode format in barcode module has no effect

## Anyline SDK 3.1 ##
Release Date 07.07.2015

### New ###
- Ported 50 Operations to C++
- Added Modules and Views for:
- Anyline Barcode
- Anyline Energy
- Anyline MRZ
- Visual, haptic, sound feedback for successful scanning result
- Module interfaces configurable with interface builder
- New Operations:
- Count Nonzero Pixels
- Entropy in Rect
- Barcode find and rotate
- Contour Count
- Find Rotate Angle for Contour Lines
- Rect from Contours
- Remove Data Points
- Resolve Contour Intersect Contour
- Create Mask filled
- Draw Contours
- Draw Lines
- Draw Rect
- Draw Specs
- Find Hough Lines
- Histogram Equalization
- Init Contour Template
- Init Regex
- Init Size
- Is Image Equal
- Rect Distance
- Contour Template Finder
- Contour Template Loader
- OCR Contour
- Contrast Threshold
- Gradient Threshold
- Morphology Threshold
- Bounding Rect From Spec
- Extend Rect
- Count Results
- Match Result to Spec

## Anyline SDK 2.5.0 ##
Release Date 30.01.2014

### New ###
- Filter Contours Area Operation
- Adapt DataPoint for bounding rects in line
- CMYK Channel Operation
- HSV Channel Operation
- RGB Channel Operation
- Overlay Thresholding Operation
- own OCR Engine

### Improved ###
- TextDataPoints with character count
- BSThresholding with threshold factor
- parallelized Tesseract Operation
- descriptive patrameters for CodeParser
- refactored operations to use descriptive parameters and default values

### Fixed ###
- Tesseract OCR bugfix
- Resize Operation


## Anyline SDK 2.4.2 ##
Release Date 04.12.2014

### New ###
- Cut Thresholding Operation
- RGB Channel Extraction Operation
- HSV Channel Extraction Operation
- YMBC Channel Extraction Operation
- DataPoints for Line Operations
- Filter Contours in Area Operation

### Improved ###
- Parallelisation in OCR Detection
- BS Thresholding

### Fixed ###
- OCR bugfix


## Anyline SDK 2.4.1 ##
Release Date 04.12.2014

### New ###
- Watershed Operation
- Background Segmentation Thresholding
- Reflection Detection Operation
- QR / Barcode Scanning Operation
- Sort Contours Operation
- Init Image Operation for Parser
- Draw Border Operation
- Draw Bounding Rects in Image Operation
- Combine Images Operation
- Normalize Images Operation
- Set Color with Mask Operation
- Resolve Contours X Violation Operation

### Improved ###
- DataPoints with Grid Operation
- CodeParser Improvements
- Tesseract Operation works with Image Array
- More generic Thresholding Operation

### Fixed ###
- Values Stack bugfix
- Memory leaks with arm64 
- rare occurring crashes fixed
- Digit DataPoint fixes


## Anyline SDK 2.4 ##
Release Date 28.10.2014

### New ###
- Mean Color in Rect Operation
- Color Distance Calculation Operation
- Validate Result Operation
- Clean Result Operation
- Find DataPoints Operation with configurable grid
- support for italic 7-segments

### Improved ###
- Interpreter refactored
- Improved Error & Exception handling

### Fixed ###
- fixed some possible Leaks
- fixed GPUImage bugs
- fixed minor issues with iOS 8


## Anyline SDK 2.3.5 ##
Release Date 01.10.2014

### Improved ###
- better OCR training capabilities

### Fixed ###
- Various Bugfixes


## Anyline SDK 2.3.4 ##
Release Date 23.09.2014

### New ###
- Square Angle Correction Operation
- Expand Square Operation
- Auto Rotate Image Operation
- Find Digit Position with Bounding Rects Operation
- Threshold Edge Detection GPU Operation

### Improved ###
- Find Square Operation
- ALSquare Bounding Rect Methods

### Fixed ###
- Various Bugfixes


## Anyline SDK 2.3.3 ##
Release Date 11.09.2014

### New ###
- Adaptive Luminance Thresholding Operation
- new Brightness in Rectangle Operation
- Luminance for Brightness Operation

### Improved ###
- Tesseract adaptive learning
- improved find data point
- find bounding squares with constraints
- better find data point area

### Fixed ###
- iOS8 color thresholding bug


## Anyline SDK 2.3.2 ##
Release Date 23.08.2014

### New ###
- Adapt Digit Position Operation with bounding rects
- Init Number Operation
- BS Thresholding Operation

### Improved ###
- Area constraint added for ApproxPolyDP Operation
- flipping values stack with none flipping support

### Fixed ###
- Observer removal bugfix
- reset equal count in values stack


## Anyline SDK 2.3.1 ##
Release Date 12.08.2014

### New ###
- new GetEqualCount Operation
- validation delegate for DisplayResult
- Init Operation for the ValuesStackFlipping

### Improved ###
- FindLargestSquareWithSizeRatio now works with Specs
- FindLargestSquareWithSizeRatio with ratio tolerance
- Transform Operation now works with Specs
- Flipping Values Stack now can accept single partial results
- DetectDigits with optional threshold parameter

### Fixed ###
- bugfixes for the ValuesStackFlipping
- bugfix for processing queue remove observer crash


## Anyline SDK 2.3 ##
Release Date 05.08.2014

### New ###
- modernised scripting language
- header part in scripting language
- support for encrypted command files
- support for reporting successful/unsuccessful scans
- specs are now defined with json
- validation delegate
- reporting KPIs

### Improved ###
- overall performance
- compatibility to android sdk

### Fixed ###
- various bugfixes


## Anyline SDK 2.2.1 ##
Release Date 29.07.2014

### Improved ###
- Exception handling
- Image processing clean ups

### Fixed ###
- Quality Calculation


## Anyline SDK 2.2 ##
Release Date 14.07.2014

### Improved ###
- better Image handling
- better thread managment
- better adapt digit positions
- overall performance improvements


## Anyline SDK 2.1 ##
Release Date 04.06.2014

### New ###
- iOS Interface Documentation added
- Anyline is now a fake dynamic library
- Anyline version & build number added
- Color Thresholding Operations
- Server Socket for Anylicious

### Fixed ###
- various bugfixes

### Improved ###
- better Image handling


## Anyline SDK 2.0 ##
Release Date 29.04.2014

### New ###
- Completely refactored the Anyline Framework.
- Anyline is now structured around Image Processing Operations.
- behaviour of Anyline is controlled over .alc command files.
- Simpler interface to communicate with Anyline.
- Overall faster performance.
- UI Stuff removed from Anyline binary.
- A lot of new Operations for the GPU.


## Anyline SDK 1.1 ##
Release Date 05.02.2014

### Improved ###
- Improved Display Overlay View with round corners.


## Anyline SDK 1.0 ##
Release Date 10.01.2014

### New ###
- Initial working version of Anyline for 7-segments.
