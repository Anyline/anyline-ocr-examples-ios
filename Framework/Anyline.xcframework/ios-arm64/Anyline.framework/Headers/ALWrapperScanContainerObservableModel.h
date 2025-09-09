//
//  ALWrapperScanContainerObservableModel.h
//  Anyline
//
//  Created by Igor on 05.08.25.
//

#import <Foundation/Foundation.h>
#import "../ALWrapperSessionParameters.h"

extern NSString *const WrapperScanContainerObservableScanStartRequestKey;
extern NSString *const WrapperScanContainerObservableScanStopRequestKey;

@interface ALWrapperScanContainerObservableModel : NSObject

@property (nonatomic, strong) ALWrapperSessionScanStartRequest *scanStartRequest;

@property (nonatomic, strong) ALWrapperSessionScanStopRequest *scanStopRequest;

@end
