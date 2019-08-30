//
//  CustomerSelfReadingConfirmationViewController.m
//  AnylineEnergy
//
//  Created by Milutin Tomic on 29/10/15.
//  Copyright © 2015 Milutin Tomic. All rights reserved.
//

#import "CustomerSelfReadingConfirmationViewController.h"
#import "ALToggleControl.h"
#import "CustomerDataView.h"
#import "Customer.h"
#import "CustomerSelfReadingViewController.h"
#import "ALUtils.h"

#import "NSManagedObjectContext+ALExamplesAdditions.h"
#import "NSManagedObject+ALExamplesAdditions.h"

@interface CustomerSelfReadingConfirmationViewController ()

@property (strong, nonatomic) IBOutlet UIView *customerDataContainer;
@property (strong, nonatomic) IBOutlet ALToggleControl *checkMarkToggle;
@property (strong, nonatomic) IBOutlet UILabel *confirmationLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) Reading *reading;

@end

@implementation CustomerSelfReadingConfirmationViewController

- (instancetype)initWithReading:(Reading *)reading {
    self = [super init];
    if (self) {
        self.reading = reading;
    }
    return self;
}

static void * kIsOnContext = &kIsOnContext;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Confirmation", @"title");
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    CustomerDataView *customerView = TranslateAutoresizing(v(@"CustomerDataView"));
    customerView.facets = CustomerDataFacetCustomerID | CustomerDataFacetAddress | CustomerDataFacetReadingValueBig | CustomerDataFacetReadingDate | CustomerDataFacetReadingImage;
    customerView.customer = self.reading.customer;
    [self.customerDataContainer addSubview:customerView];
    
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customerView]|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full width
    [self.customerDataContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customerView]|" options:0 metrics:nil views:@{@"customerView": customerView}]];// full height
    
    NSString *confirmationText = [NSString stringWithFormat:NSLocalizedString(@"I, %@, certify that the data above is complete and correct.", @"string"), self.reading.customer.name];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.tailIndent = -0.60;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName: style
                                 };
    
    self.confirmationLabel.attributedText = [[NSAttributedString alloc] initWithString:confirmationText attributes:attributes];
    
    [self.checkMarkToggle setIsOn:NO];
    self.checkMarkToggle.backgroundColor = [UIColor clearColor];
    self.checkMarkToggle.imageWhenOn = [UIImage imageNamed:@"checkbox on"];
    self.checkMarkToggle.imageWhenOff = [UIImage imageNamed:@"checkbox off"];
    
    [self.checkMarkToggle addObserver:self forKeyPath:@"isOn" options:0 context:kIsOnContext];
    
    self.sendButton.enabled = NO;
}

- (void)dealloc {
    [self.checkMarkToggle removeObserver:self forKeyPath:@"isOn"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)sendReading {
    [ALUtils syncReading:self.reading withBlock:^(BOOL success) {
        if (success) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reading sync."
                                                                                     message:@"Your reading has been received."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self popToCustomerSelfReading];

            }]];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
            [self.reading.managedObjectContext saveToPersistentStoreAndWait];
            
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reading sync."
                                                                                     message:@"Could not send reading.\nPlease try again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:dismissAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == kIsOnContext) {
        self.sendButton.enabled = self.checkMarkToggle.isOn;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Actions

- (void)popToCustomerSelfReading{
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    for (UIViewController *vc in navigationController.viewControllers) {
        if ([vc isKindOfClass:[CustomerSelfReadingViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (IBAction)labelTappedAction:(id)sender {
    self.checkMarkToggle.isOn = !self.checkMarkToggle.isOn;
}

- (IBAction)cancelAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendAction:(id)sender {
    // we take it -2 here because the current reading is -1
    Reading *previousReading = [[[self.reading.customer.readings allObjects]sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(sort)) ascending:YES]]] objectAtIndex:self.reading.customer.readings.count - 2];
    
    NSInteger currentValue = [self.reading.readingValue integerValue];
    NSInteger lastValue = [previousReading.readingValue integerValue];
    NSInteger actualDelta = currentValue - lastValue;
    NSInteger expectedDelta = [self.reading.customer.annualConsumption integerValue];
    
    CGFloat tolerance = .2;
    
    NSInteger upperDeltaBound = round((1.0 + tolerance) * (CGFloat)expectedDelta);
    NSInteger lowerDeltaBound = round((1.0 - tolerance) * (CGFloat)expectedDelta);
    
    if (lowerDeltaBound <= actualDelta && actualDelta <= upperDeltaBound) {
        // all good -> current value seems plausible
        [self sendReading];
    } else {
        // Meter reading is out of "tolerance" range, warn user.
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendReading];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"The meter reading you have entered is outside of the expected range of values.", @"warning")
                                                                                 message:[NSString stringWithFormat:NSLocalizedString(@"Please confirm that your meter shows the following value:\n\n%@", @"warning"), self.reading.readingValue]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
    
}

@end
