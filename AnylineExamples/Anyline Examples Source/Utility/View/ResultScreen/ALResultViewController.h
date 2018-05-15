//
//  ALResultViewController.h
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import <UIKit/UIKit.h>
#import "ALResultEntry.h"

@interface ALResultViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<ALResultEntry *> *resultData;
@property (strong, nonatomic) UIImage *image;

//optional:
@property (strong, nonatomic) NSString *optionalTitle;
@property (strong, nonatomic) UIImage *optionalImage;

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData image:(UIImage *)image;

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData image:(UIImage *)image optionalImageTitle:(NSString *)optTitle optionalImage:(UIImage *)optImage;

@end
