#import <UIKit/UIKit.h>

#import "ALBaseScanViewController.h"
#import "Customer.h"
#import "CustomerSelfReading.h"
#import "Order.h"

@interface ALEnergyMeterScanViewController : ALBaseScanViewController

@property (nonatomic, strong) Customer *customer;
@property (nonatomic, strong) CustomerSelfReading *csr;
@property (nonatomic, strong) Order *order;

@end
