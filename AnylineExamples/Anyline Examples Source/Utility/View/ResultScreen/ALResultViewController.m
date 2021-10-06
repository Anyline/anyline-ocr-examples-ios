//
//  ALResultViewController.m
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

#import "ALResultViewController.h"
#import <Foundation/Foundation.h>
#import "UIFont+ALExamplesAdditions.h"
#import "ALResultCell.h"
#import "ALResultEntry.h"
#import "UIColor+ALExamplesAdditions.h"
#import "NSAttributedString+ALExamplesAdditions.h"
#import "ALUniversalIDFieldnameUtil.h"

static NSString *disclaimerString = @"The result fields above display a selection of scannable ID information only. Please review the documentation for a full list of scannable ID information.";
static NSString *WEBLINK_ANYLINE_DOCUMENTATION_PRODUCTID = @"https://documentation.anyline.com/toc/products/id/index.html";

@interface ALResultViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *entryArray;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *faceImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UITextView *disclaimerTextView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSLayoutConstraint *tableViewHeightConstraint;

@end


@implementation ALResultViewController

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData image:(UIImage *)image {
    return [self initWithResultDataDictionary:@{ @"Result Data" : resultData}
                                        image:image
                                optionalImage:nil
                                    faceImage:nil
                         shouldShowDisclaimer:NO];
}

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData
                             image:(UIImage *)image
              shouldShowDisclaimer:(BOOL)shouldShow {
    return [self initWithResultDataDictionary:@{ @"Result Data" : resultData}
                                        image:image
                                optionalImage:nil
                                    faceImage:nil
                         shouldShowDisclaimer:shouldShow];
}

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData
                             image:(UIImage *)image
                         faceImage:(UIImage *)faceImage
              shouldShowDisclaimer:(BOOL)shouldShow {
    return [self initWithResultDataDictionary:@{ @"Result Data" : resultData}
                                        image:image
                                optionalImage:nil
                                    faceImage:faceImage
                         shouldShowDisclaimer:shouldShow];
}

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData
                             image:(UIImage *)image
                     optionalImage:(UIImage *)optImage
              shouldShowDisclaimer:(BOOL)shouldShow {
    return [self initWithResultDataDictionary:@{ @"Result Data" : resultData}
                                        image:image
                                optionalImage:optImage
                                    faceImage:nil
                         shouldShowDisclaimer:shouldShow];
}

- (instancetype)initWithResultData:(NSMutableArray<ALResultEntry *>*)resultData
                             image:(UIImage *)image
                     optionalImage:(UIImage *)optImage
                         faceImage:(UIImage *)faceImage
              shouldShowDisclaimer:(BOOL)shouldShow {
    return [self initWithResultDataDictionary:@{ @"Result Data" : resultData}
                                        image:image
                                optionalImage:optImage
                                    faceImage:faceImage
                         shouldShowDisclaimer:shouldShow];
}

- (instancetype)initWithResultDataDictionary:(NSDictionary *)resultDataDictionary
                                       image:(UIImage *)image
                               optionalImage:(UIImage *)optImage
                                   faceImage:(UIImage *)faceImage {
    return [self initWithResultDataDictionary:resultDataDictionary image:image optionalImage:optImage faceImage:faceImage shouldShowDisclaimer:NO];;
}


- (instancetype)initWithResultDataDictionary:(NSDictionary *)resultDataDictionary
                                       image:(UIImage *)image
                               optionalImage:(UIImage *)optImage
                                   faceImage:(UIImage *)faceImage
                        shouldShowDisclaimer:(BOOL)shouldShow {
    self = [super init];
    if (self) {
        _documentImage = image;
        _resultData = resultDataDictionary;
        _documentBackImage = optImage;
        _faceImage = faceImage;
        _shouldShowDisclaimer = shouldShow;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.title = @"Result Data";
    UIBarButtonItem *shareBarItem;
    
    shareBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(askToShareItems:)];
    [shareBarItem setTintColor:[UIColor AL_LabelBlackWhite]];

    
    self.navigationItem.rightBarButtonItem = shareBarItem;
    self.view.backgroundColor = [UIColor AL_BackgroundColor];
    [self setupScrollView];
    [self setupScrollViewContent];
    [self setupConfirmButton];
    [self setupContraints];
}

- (void)askToShareItems:(id)sender {
    NSArray *resultDataArray = [self.resultData objectForKey:@"Result Data"];
    NSMutableString *shareText = [NSMutableString stringWithString:@"Anyline Scanner Result\n\n"];
    
    for (ALResultEntry *entry in resultDataArray) {
        [shareText appendFormat:@"%@: %@\n", entry.title, entry.value];
    }
    
    UIActivityViewController *activityController =  [[UIActivityViewController alloc] initWithActivityItems:@[shareText, self.documentImage]
                                                                                      applicationActivities:nil];
    [activityController setValue:@"Anyline Scanner Result" forKey:@"Subject"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    } else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)setupScrollView {
    //Setup Content ScrollView
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsVerticalScrollIndicator = YES;
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.userInteractionEnabled = YES;
    self.contentScrollView.backgroundColor = [UIColor AL_BackgroundColor];
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupConfirmButton {
    //Setup Confirm Button
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont AL_proximaBoldWithSize:18]];
    [self.confirmButton.titleLabel setTextColor:[UIColor whiteColor]];
    self.confirmButton.backgroundColor = [UIColor AL_examplesBlue];
    [self.confirmButton.layer setCornerRadius:50/2];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setupScrollViewContent {
    
    self.faceImageView = [[UIImageView alloc] init];
    self.faceImageView.image = self.faceImage;
    
    [self.contentScrollView addSubview:self.faceImageView];
    [self.faceImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Setup TableView
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[ALResultCell class] forCellReuseIdentifier:@"alResultCell"];
    [self.tableView setSectionHeaderHeight:0];
    self.tableView.userInteractionEnabled = true;
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor AL_BackgroundColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //Add view to scrollView
    [self.contentScrollView addSubview:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Setup Image View
    self.firstImageView = [[UIImageView alloc] init];
    self.firstImageView.image = self.documentImage;
    self.firstImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentScrollView addSubview:self.firstImageView];
    [self.firstImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Setup Image View
    self.secondImageView = [[UIImageView alloc] init];
    self.secondImageView.image = self.documentBackImage;
    self.secondImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentScrollView addSubview:self.secondImageView];
    [self.secondImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if (_shouldShowDisclaimer) {
        self.disclaimerTextView = [[UITextView alloc] init];
        [self setHyperlinkInsideTextView];
        [self.disclaimerTextView setScrollEnabled:NO];
        [self.disclaimerTextView setClipsToBounds:NO];
        [self.disclaimerTextView setUserInteractionEnabled:YES];
        [self.disclaimerTextView setEditable:NO];
        [self.contentScrollView addSubview:self.disclaimerTextView];
        [self.disclaimerTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

- (void)setupContraints {
    CGFloat verticalPadding = 10;
    CGFloat horizontalPadding = 30;
    NSMutableArray *constraints = @[[self.contentScrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                    [self.contentScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                    [self.contentScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]].mutableCopy;
    NSLayoutYAxisAnchor *topTableVieWConstraints = self.contentScrollView.topAnchor;
    if (self.faceImage) {
        NSLayoutConstraint *horizontalConstraint;
        if (self.isArabicScript) {
            horizontalConstraint = [self.faceImageView.trailingAnchor constraintEqualToAnchor:self.contentScrollView.trailingAnchor constant:-horizontalPadding];
        } else {
            horizontalConstraint = [self.faceImageView.leadingAnchor constraintEqualToAnchor:self.contentScrollView.leadingAnchor constant:horizontalPadding];
        }
        [constraints addObjectsFromArray:@[[self.faceImageView.topAnchor constraintEqualToAnchor:self.contentScrollView.topAnchor constant:verticalPadding],
                                           horizontalConstraint,
                                           [self.faceImageView.widthAnchor constraintLessThanOrEqualToConstant:100],
                                           [self.faceImageView.heightAnchor constraintLessThanOrEqualToConstant:100]]];
        topTableVieWConstraints = self.faceImageView.bottomAnchor;
    }
    
    self.tableViewHeightConstraint = [self.tableView.heightAnchor constraintEqualToConstant:100];
    [constraints addObjectsFromArray:@[[self.tableView.topAnchor constraintEqualToAnchor:topTableVieWConstraints constant:verticalPadding],
                                       [self.tableView.leadingAnchor constraintEqualToAnchor:self.contentScrollView.leadingAnchor constant:20],
                                       [self.tableView.trailingAnchor constraintEqualToAnchor:self.contentScrollView.trailingAnchor constant:-20],
                                       self.tableViewHeightConstraint,
                                       [self.tableView.bottomAnchor constraintEqualToAnchor:self.firstImageView.topAnchor constant:-verticalPadding]]];
    
    CGFloat ratio = self.documentImage.size.height / self.documentImage.size.width;
    CGFloat width = self.view.bounds.size.width-(horizontalPadding*2);
    CGFloat height = width*ratio;
    [constraints addObjectsFromArray:@[[self.firstImageView.topAnchor constraintEqualToAnchor:self.tableView.bottomAnchor constant:verticalPadding],
                                       [self.firstImageView.leadingAnchor constraintEqualToAnchor:self.contentScrollView.leadingAnchor constant:horizontalPadding],
                                       [self.firstImageView.trailingAnchor constraintEqualToAnchor:self.contentScrollView.trailingAnchor constant:-horizontalPadding],
                                       [self.firstImageView.heightAnchor constraintLessThanOrEqualToConstant:isnan(height) ? 0 : height],
                                       [self.firstImageView.widthAnchor constraintEqualToConstant:isnan(width) ? 0 : width],
                                       [self.firstImageView.bottomAnchor constraintEqualToAnchor:self.secondImageView.topAnchor constant:-verticalPadding]]];

    ratio = self.documentBackImage.size.height / self.documentBackImage.size.width;
    height = width*ratio;
    NSLayoutAnchor *secondImageViewBottomAnchor = _shouldShowDisclaimer ? self.disclaimerTextView.topAnchor : self.contentScrollView.bottomAnchor;
    [constraints addObjectsFromArray:@[[self.secondImageView.topAnchor constraintEqualToAnchor:self.firstImageView.bottomAnchor constant:verticalPadding],
                                       [self.secondImageView.leadingAnchor constraintEqualToAnchor:self.contentScrollView.leadingAnchor constant:horizontalPadding],
                                       [self.secondImageView.trailingAnchor constraintEqualToAnchor:self.contentScrollView.trailingAnchor constant:-horizontalPadding],
                                       [self.secondImageView.heightAnchor constraintEqualToConstant:isnan(height) ? 0 : height],
                                       [self.secondImageView.widthAnchor constraintEqualToAnchor:self.firstImageView.widthAnchor],
                                       [self.secondImageView.bottomAnchor constraintEqualToAnchor:secondImageViewBottomAnchor constant:-verticalPadding]]];
    if (_shouldShowDisclaimer) {
        CGSize size = [self.disclaimerTextView sizeThatFits:CGSizeMake(width, 100)];
        CGFloat disclaimerHeight = size.height;
        [constraints addObjectsFromArray:@[[self.disclaimerTextView.topAnchor constraintEqualToAnchor:self.secondImageView.bottomAnchor constant:verticalPadding],
                                           [self.disclaimerTextView.leadingAnchor constraintEqualToAnchor:self.contentScrollView.leadingAnchor constant:horizontalPadding],
                                           [self.disclaimerTextView.trailingAnchor constraintEqualToAnchor:self.contentScrollView.trailingAnchor constant:-horizontalPadding],
                                           [self.disclaimerTextView.bottomAnchor constraintEqualToAnchor:self.contentScrollView.bottomAnchor constant:-verticalPadding],
                                           [self.disclaimerTextView.heightAnchor constraintEqualToConstant:disclaimerHeight]]];
    }
    
    [constraints addObjectsFromArray:@[[self.confirmButton.topAnchor constraintEqualToAnchor:self.contentScrollView.bottomAnchor constant:verticalPadding],
                                       [self.confirmButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-horizontalPadding],
                                       [self.confirmButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:horizontalPadding],
                                       [self.confirmButton.heightAnchor constraintEqualToConstant:50],
                                       [self.confirmButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-verticalPadding]]];
    
    
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView layoutIfNeeded];
    self.tableViewHeightConstraint.constant = self.tableView.contentSize.height;
}

#pragma mark - UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"alResultCell";
    ALResultCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ALResultCell alloc] init];
    }
    
    ALResultEntry *entry = [self.resultData[[[self.resultData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor AL_BackgroundColor];
    [cell setResultEntry:entry];
    if (self.isArabicScript) {
        [cell alignLabelsTextRight];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = [self.resultData[[[self.resultData allKeys] objectAtIndex:section]] count];
    return self.isArabicScript ? rowCount - 1 : rowCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = window.safeAreaInsets.top;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topPadding, self.view.frame.size.width, [self headerSize])];
    view.backgroundColor = [UIColor AL_BackgroundColor];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultData allKeys].count;
}

#pragma mark - Utility methods

- (CGFloat)headerSize {
    return 7.0;
}

- (void)setHyperlinkInsideTextView {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:disclaimerString];
    NSRange linkRange = [[attString mutableString] rangeOfString:@"documentation"];
    [attString addAttributes:@{NSLinkAttributeName : [NSURL URLWithString:WEBLINK_ANYLINE_DOCUMENTATION_PRODUCTID]} range:linkRange];
    
    [self.disclaimerTextView setAttributedText:[attString withFont:[UIFont AL_proximaRegularWithSize:16]]];
    [self.disclaimerTextView setTextColor:[UIColor AL_LabelBlackWhite]];
}

#pragma mark - IBAction methods
- (void)confirmAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    
    ALResultEntry *entry = [self.resultData[[[self.resultData allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    pasteboard.string = entry.value;
}

@end
