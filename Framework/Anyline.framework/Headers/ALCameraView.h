//
//  ALCameraView.h
//  Anyline
//
//  Created by Daniel Albertini on 30/05/2017.
//  Copyright © 2017 9Yards GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALCaptureDeviceManager.h"

@interface ALCameraView : UIView

- (_Nullable instancetype)initWithFrame:(CGRect)frame
                   captureDeviceManager:(ALCaptureDeviceManager * _Nonnull)captureDeviceManger;

@end
