//
//  ALTutorialViewController.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 21.03.21.
//

#import "ALTutorialViewController.h"

#import "UIColor+ALExamplesAdditions.h"
#import "UIFont+ALExamplesAdditions.h"

@interface ALTutorialViewController ()

@property (nonatomic, strong) UIView *topContainer;
@property (nonatomic, strong) UIImageView *tutorialImageView;
@property (nonatomic, strong) UILabel *tutorialText;

@end

@implementation ALTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)createSubViews {
    
    [self.view setBackgroundColor:[UIColor AL_BackgroundColor]];
    
    [self createTopViewWithTitle:@"How to Scan"];
    
    _tutorialImageView = [[UIImageView alloc] init];
    [self.view addSubview:_tutorialImageView];
    [_tutorialImageView setImage:[UIImage imageNamed:@"IDTutorial"]];
    [_tutorialImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _tutorialText = [[UILabel alloc] init];
    [_tutorialText setNumberOfLines:0];
    [_tutorialText setTextAlignment:NSTextAlignmentNatural];
    [_tutorialText setBackgroundColor:[UIColor clearColor]];
    [_tutorialText setText:@"The Identity Documents scan modes allow you to digitize the ID data you need.\n\nMake sure the whole document is placed within the blue detection box that is displayed in your camera view."];
    [_tutorialText setFont:[UIFont AL_proximaRegularWithSize:16]];
    [self.view addSubview:_tutorialText];
    [_tutorialText setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

- (void)createTopViewWithTitle:(NSString *)title {
    _topContainer = [[UIView alloc] init];
    [self.view addSubview:_topContainer];
    [_topContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont AL_proximaBoldWithSize:20]];
    [titleLabel setTextColor:[UIColor AL_LabelBlackWhite]];
    [_topContainer addSubview:titleLabel];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSMutableArray *constraints = @[[titleLabel.centerYAnchor constraintEqualToAnchor:_topContainer.centerYAnchor],
                                    [titleLabel.centerXAnchor constraintEqualToAnchor:_topContainer.centerXAnchor]].mutableCopy;
    
    UIButton *OKButton = [[UIButton alloc] init];
    [OKButton addTarget:self action:@selector(tapOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [OKButton setTitle:@"OK" forState:UIControlStateNormal];
    [OKButton setTitleColor:[UIColor AL_examplesBlue] forState:UIControlStateNormal];
    [OKButton setBackgroundColor:[UIColor clearColor]];
    [_topContainer addSubview:OKButton];
    [OKButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [constraints addObjectsFromArray:@[[OKButton.centerYAnchor constraintEqualToAnchor:titleLabel.centerYAnchor],
                                       [OKButton.trailingAnchor constraintEqualToAnchor:_topContainer.trailingAnchor constant:-10],
                                       [OKButton.widthAnchor constraintEqualToConstant:44],
                                       [OKButton.heightAnchor constraintEqualToConstant:44]]];
    
    [self.view addConstraints:constraints];
    
}

- (void)createSubViewsConstraints {
    
    NSMutableArray *constraints = @[[_topContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                    [_topContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                    [_topContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                    [_topContainer.heightAnchor constraintEqualToConstant:52]].mutableCopy;
    
    [constraints addObjectsFromArray:@[[_tutorialImageView.topAnchor constraintEqualToAnchor:_topContainer.bottomAnchor constant:49],
                                       [_tutorialImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                       [_tutorialImageView.widthAnchor constraintEqualToConstant:272],
                                       [_tutorialImageView.heightAnchor constraintEqualToConstant:272]]];
    
    [constraints addObjectsFromArray:@[[_tutorialText.topAnchor constraintEqualToAnchor:_tutorialImageView.bottomAnchor constant:39],
                                       [_tutorialText.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:23],
                                       [_tutorialText.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-23]]];
    
    [self.view addConstraints:constraints];
    [NSLayoutConstraint activateConstraints:constraints];
}

//MARK: IBAction

- (IBAction)tapOkButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
