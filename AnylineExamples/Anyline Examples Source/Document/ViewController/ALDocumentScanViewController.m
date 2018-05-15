
#import "ALDocumentScanViewController.h"
#import "Anyline/AnylineDocumentModuleView.h"
#import "NSUserDefaults+ALExamplesAdditions.h"
#import "ALRoundedView.h"
#import "ALAppDemoLicenses.h"

NSString * const kDocumentScanLicenseKey = kDemoAppLicenseKey;

@class AnylineDocumentModuleView;

@interface ALDocumentScanViewController () <AnylineDocumentModuleDelegate>

@property (nonatomic, strong) AnylineDocumentModuleView *documentModuleView;
@property (nonatomic, strong) ALRoundedView *roundedView;
@property (nonatomic, assign) NSInteger showingLabel;

@end

@implementation ALDocumentScanViewController

/*
 We will do our main setup in viewDidLoad. Its called once the view controller is getting ready to be displayed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the background color to black to have a nicer transition
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = NSLocalizedString(@"Scan Document", @"Scan Document");
    
    // Initializing the the module. Its a UIView subclass. We set the frame to fill the whole screen
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame = CGRectMake(
                       frame.origin.x,
                       frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                       frame.size.width,
                       frame.size.height - self.navigationController.navigationBar.frame.size.height
                       );
    self.documentModuleView = [[AnylineDocumentModuleView alloc] initWithFrame:frame];
    
    NSError *error = nil;
    // We tell the module to bootstrap itself with the license key and delegate. The delegate will later get called
    // by the module once we start receiving results.
    BOOL success = [self.documentModuleView setupWithLicenseKey:kDocumentScanLicenseKey delegate:self error:&error];
    
    // Stop scanning after a result has been found
    self.documentModuleView.cancelOnResult = YES;

    // setupWithLicenseKey:delegate:error returns true if everything went fine. In the case something wrong
    // we have to check the error object for the error message.
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Setup Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    self.documentModuleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.documentModuleView.postProcessingEnabled = true;
    
    // After setup is complete we add the module to the view of this view controller
    [self.view addSubview:self.documentModuleView];
    
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.documentModuleView}]];
    
    id topGuide = self.topLayoutGuide;
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[moduleView]|" options:0 metrics:nil views:@{@"moduleView" : self.documentModuleView, @"topGuide" : topGuide}]];
    
    [self.documentModuleView enableReporting:[NSUserDefaults AL_reportingEnabled]];
    
    self.controllerType = ALScanHistoryDocument;
    

    // This view notifies the user of any problems that occur while he is scanning
    self.roundedView = [[ALRoundedView alloc] initWithFrame:CGRectMake(20, 115, self.view.bounds.size.width - 40, 30)];
    self.roundedView.fillColor = [UIColor colorWithRed:98.0/255.0 green:39.0/255.0 blue:232.0/255.0 alpha:0.6];
    self.roundedView.textLabel.text = @"";
    self.roundedView.alpha = 0;
    [self.view addSubview:self.roundedView];
}

/*
 This method will be called once the view controller and its subviews have appeared on screen
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*
     This is the place where we tell Anyline to start receiving and displaying images from the camera.
     Success/error tells us if everything went fine.
     */
    NSError *error;
    BOOL success = [self.documentModuleView startScanningAndReturnError:&error];
    if( !success ) {
        // Something went wrong. The error object contains the error description
        [[[UIAlertView alloc] initWithTitle:@"Start Scanning Error"
                                    message:error.debugDescription
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

/*
 Cancel scanning to allow the module to clean up
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self.documentModuleView cancelScanningAndReturnError:nil];
}

- (void)viewDidLayoutSubviews {
    [self updateWarningPosition:
     self.documentModuleView.cutoutRect.origin.y +
     self.documentModuleView.cutoutRect.size.height +
     self.documentModuleView.frame.origin.y +
     90];
}

#pragma mark -- AnylineDocumentModuleDelegate

/*
 This is the main delegate method Anyline uses to report its scanned codes
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
                        hasResult:(UIImage *)transformedImage
                        fullImage:(UIImage *)fullFrame
                  documentCorners:(ALSquare *)corners {
    UIViewController *viewController = [[UIViewController alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewController.view.bounds];
    imageView.center = CGPointMake(imageView.center.x, imageView.center.y + 30);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = transformedImage;
    [viewController.view addSubview:imageView];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

/*
 This method receives errors that occured during the scan.
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
  reportsPictureProcessingFailure:(ALDocumentError)error {
    [self showUserLabel:error];
}

/*
 This method receives errors that occured during the scan.
 */
- (void)anylineDocumentModuleView:(AnylineDocumentModuleView *)anylineDocumentModuleView
  reportsPreviewProcessingFailure:(ALDocumentError)error {
    [self showUserLabel:error];
}

#pragma mark -- Helper Methods

/*
 Shows a little round label at the bottom of the screen to inform the user what happended
 */
- (void)showUserLabel:(ALDocumentError)error {
    NSString *helpString = nil;
    switch (error) {
        case ALDocumentErrorNotSharp:
            helpString = @"Document not Sharp";
            break;
        case ALDocumentErrorSkewTooHigh:
            helpString = @"Wrong Perspective";
            break;
        case ALDocumentErrorImageTooDark:
            helpString = @"Too Dark";
            break;
        case ALDocumentErrorShakeDetected:
            helpString = @"Shake";
            break;
        default:
            break;
    }
    
    // The error is not in the list above or a label is on screen at the moment
    if(!helpString || self.showingLabel == 1) {
        return;
    }
    
    self.showingLabel = 1;
    self.roundedView.textLabel.text = helpString;
    
    
    // Animate the appearance of the label
    CGFloat fadeDuration = 0.8;
    [UIView animateWithDuration:fadeDuration animations:^{
        self.roundedView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:fadeDuration animations:^{
            self.roundedView.alpha = 0;
        } completion:^(BOOL finished) {
            self.showingLabel = 0;
        }];
    }];
}

@end
