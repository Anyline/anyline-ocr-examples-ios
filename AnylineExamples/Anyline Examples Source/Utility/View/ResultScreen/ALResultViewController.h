//
//  ALResultViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import <UIKit/UIKit.h>
#import "ALResultEntry.h"

@interface ALResultViewController : UIViewController

@property (strong, nonatomic) NSDictionary<NSString *, NSArray<ALResultEntry *>*> *resultData;
@property (strong, nonatomic) UIImage *faceImage;
@property (strong, nonatomic) UIImage *documentImage;
@property (strong, nonatomic) UIImage *documentBackImage;
@property (assign, nonatomic) BOOL shouldShowDisclaimer;
@property (assign, nonatomic) BOOL isArabicScript;

- (instancetype)initWithResultData:(NSArray<ALResultEntry *>*)resultData image:(UIImage *)image;
- (instancetype)initWithResultData:(NSArray<ALResultEntry *>*)resultData image:(UIImage *)image shouldShowDisclaimer:(BOOL)shouldShow;
- (instancetype)initWithResultData:(NSArray<ALResultEntry *>*)resultData image:(UIImage *)image faceImage:(UIImage *)faceImage shouldShowDisclaimer:(BOOL)shouldShow;
- (instancetype)initWithResultData:(NSArray<ALResultEntry *>*)resultData image:(UIImage *)image optionalImage:(UIImage *)optImage faceImage:(UIImage *)faceImage shouldShowDisclaimer:(BOOL)shouldShow;


/*
 *  TODO:
 *  Accept NSDictionary with NSString (key) and ALResultEntry (value)
 *  Use Key as Section Heaeder, Use Value for rows
 *  Adapt old constructors to wrap this constructor and only use the DICT internally
 */
- (instancetype)initWithResultDataDictionary:(NSDictionary *)resultDataDictionary
                                       image:(UIImage *)image
                               optionalImage:(UIImage *)optImage
                                   faceImage:(UIImage *)faceImage;
- (instancetype)initWithResultDataDictionary:(NSDictionary *)resultDataDictionary
                                       image:(UIImage *)image
                               optionalImage:(UIImage *)optImage
                                   faceImage:(UIImage *)faceImage
                        shouldShowDisclaimer:(BOOL)shouldShow;

@end
