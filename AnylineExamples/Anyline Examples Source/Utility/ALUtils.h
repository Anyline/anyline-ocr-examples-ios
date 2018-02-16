//
//  ALUtils.h
//  AnylineEnergy
//
//  Created by Milutin Tomic on 27/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Anyline/Anyline.h>
#import "Reading.h"
#import "ALMeter.h"

typedef void(^ALSyncBlock)(BOOL success);

@interface ALUtils : NSObject

+ (void)syncReading:(Reading *)reading withBlock:(ALSyncBlock)block;

+ (ALFlashMode)defaultFlashMode;

+ (BOOL)isScannerTypeImplemented:(ALScannerType)scannerType;
    
@end

#pragma mark - Makros

//View instantiation and controller hookup
#define vSelfLink(nibName) [[NSBundle.mainBundle loadNibNamed:nibName owner:self options:nil] objectAtIndex:0]
#define v(nibName) [[NSBundle.mainBundle loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0]

//Info.plist
#define InfoPlist [[NSBundle mainBundle] infoDictionary]

//Delayed execution
void ExecuteAfter(CGFloat delay, void(^block)(void));
void ExecuteAfterCancellable(NSString *cancelIdentifier, CGFloat delay, void(^block)(void));

//Views
static inline id TranslateAutoresizing(UIView *view) {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}

#pragma mark - Types

typedef void(^VoidBlock)(void);
typedef BOOL(^BoolBlock)(void);

