//
//  ALDataGroup2.h
//  Anyline
//
//  Created by Angela Brett on 07.10.19.
//  Copyright © 2019 Anyline GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Data Group 2 of the data read from a passport NFC chip, containing the face image
@interface ALDataGroup2 : NSObject

/// The face image read from the passport's NFC chip
@property UIImage *faceImage;

- (instancetype)initWithFaceImage:(UIImage *)faceImage;

@end

NS_ASSUME_NONNULL_END
