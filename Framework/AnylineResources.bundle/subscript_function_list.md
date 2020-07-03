# ALC Script Subscript Functions

The RND team decided to set a naming convention for variables used in a __subscript__ (for details see [2020-06-09 Team rant JF](https://anyline.atlassian.net/wiki/spaces/ALSDK/pages/1876525057/2020-06-09+Team+rant+JF)).
This document is an iterative file that lists the existing subscripts and their naming.
Please update the file whenever you create a new subscript!

### Naming Convention
- All variables in a subscript should start with the prefix `$fn[abbreviation max of 3 Chars]_` where the abbreviation should reflect the file name. e.g. `$fnTS_contours`.
- Exception of this rule are start variables, that are also used in the SDK

### Subscript variables

##### Anonymize ID (GDPR compliant template friendly anonymization)
- __prefix__: $fnAN
- __subscript__: module_id/functions_anonymize_id.alc
- __description__: variables for a generic templatable ID anonymization

##### Auto mode (card type identification)
- __prefix__: $fnAm
- __subscript__: module_id/functions_auto_mode.alc
- __description__: variables for the detected and expected text location overlay based card identification colculations

##### Card detection
- __prefix__: $fnCD
- __subscript__: module_id/functions_card_detection.alc
- __description__: subscripts to detect a card on a given image based on CV approaches (watershed/tracking)

##### Card rectification
- __prefix__: $fnCR
- __subscript__: module_id/functions_card_rectification.alc
- __description__: subscripts to rectify the image of the card based on the result of the card detection subscript
- __note__: heavily relies on the card detection subscript and variables

##### EAST detection
- __prefix__: $fnED
- __subscript__: module_id/functions_east_detection.alc
- __description__: subscripts to retrieve text location from images using the EAST model

##### MRZ scanning
- __prefix__: $fnMRZ
- __subscript__: module_id/functions_mrz_scanning.alc
- __description__: subscripts to address mrz usage from other scripts
- __note__: NOT up to date with the standalone mrz_scanning.alc atm

##### Template (loading)
- __prefix__: $fnT
- __subscript__: module_id/functions_template.alc
- __description__: subscripts to load specs from templates

##### Template Scanning
- __$fnTS__
- __subscript__: module_id/functions_template_scanning.alc
- __description__: generic ID scanning script that scans a given (rectified) image for a specific (detected) template.
- __note__: nested subscript inside (`anonymize_id`)
