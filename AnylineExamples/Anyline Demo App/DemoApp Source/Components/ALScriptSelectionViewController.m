//
//  ALScriptSelectionViewController.m
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 18.05.21.
//

#import "ALScriptSelectionViewController.h"
#import "UIFont+ALExamplesAdditions.h"
#import "UIColor+ALExamplesAdditions.h"

@interface ALScriptSelectionViewController ()

@property (nonatomic, strong) UIButton *latinScriptButton;
@property (nonatomic, strong) UIButton *arabicScriptbutton;
@property (nonatomic, assign) BOOL hasChangedScript;

@end

@implementation ALScriptSelectionViewController

+ (UIBarButtonItem *)createBarButtonForScriptSelection:(UIViewController *)viewController {
    UIButton *scriptSelectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [scriptSelectionButton setContentMode:UIViewContentModeScaleAspectFit];
    [scriptSelectionButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [scriptSelectionButton setImage:[UIImage imageNamed:@"script_selection"] forState:UIControlStateNormal];
    [scriptSelectionButton setTintColor:[UIColor AL_BackButton]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([viewController respondsToSelector:@selector(selectScriptPressed:)]) {
        [scriptSelectionButton addTarget:viewController action:@selector(selectScriptPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
#pragma clang diagnostic pop
    
    UIBarButtonItem *scriptSelectionBarItem = [[UIBarButtonItem alloc] initWithCustomView:scriptSelectionButton];
    NSLayoutConstraint *scriptButtonWidth = [scriptSelectionBarItem.customView.widthAnchor constraintEqualToConstant:40];
    [scriptButtonWidth setActive:YES];
    return scriptSelectionBarItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    UIView *bottomSheet = [[UIView alloc] init];
    [self.view addSubview:bottomSheet];
    [bottomSheet setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomSheet setBackgroundColor:[UIColor AL_BackgroundColor]];
    [bottomSheet.layer setCornerRadius:20];
    
    UILabel *topTitle = [[UILabel alloc] init];
    [topTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topTitle setBackgroundColor:[UIColor clearColor]];
    [topTitle setText:@"Select Script"];
    [topTitle setTextAlignment:NSTextAlignmentCenter];
    [topTitle setFont:[UIFont AL_proximaSemiboldWithSize:20]];
    [topTitle setTextColor:[UIColor AL_LabelBlackWhite]];
    
    UIImage *checkMarkImage = [UIImage imageNamed:@"checkmark_script_selection"];
    UIButton *latinButton = [[UIButton alloc] init];
    [latinButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [latinButton setBackgroundColor:[UIColor clearColor]];
    [latinButton setTitle:@"Latin" forState:UIControlStateNormal];
    [latinButton setTitleColor:[UIColor AL_LabelBlackWhite] forState:UIControlStateNormal];
    [latinButton setTitleColor:[UIColor AL_LabelBlackWhite] forState:UIControlStateHighlighted];
    [latinButton setImage:checkMarkImage forState:UIControlStateSelected];
    [latinButton setImage:checkMarkImage forState:UIControlStateHighlighted];
    [latinButton setTintColor:[UIColor AL_LabelBlackWhite]];
    [latinButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [latinButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [latinButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [latinButton setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, 0)];
    self.latinScriptButton = latinButton;
    
    UIButton *arabicButton = [[UIButton alloc] init];
    [arabicButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [arabicButton setBackgroundColor:[UIColor clearColor]];
    [arabicButton setTitle:@"Arabic" forState:UIControlStateNormal];
    [arabicButton setTitleColor:[UIColor AL_LabelBlackWhite] forState:UIControlStateNormal];
    [arabicButton setTitleColor:[UIColor AL_LabelBlackWhite] forState:UIControlStateHighlighted];
    [arabicButton setImage:checkMarkImage forState:UIControlStateSelected];
    [arabicButton setImage:checkMarkImage forState:UIControlStateHighlighted];
    [arabicButton setTintColor:[UIColor AL_LabelBlackWhite]];
    [arabicButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [arabicButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [arabicButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [arabicButton setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
    self.arabicScriptbutton = arabicButton;
    
    [bottomSheet addSubview:topTitle];
    [bottomSheet addSubview:latinButton];
    [bottomSheet addSubview:arabicButton];
    
    
    NSMutableArray *bottomSheetConstraints = @[[bottomSheet.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
                                               [bottomSheet.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0],
                                               [bottomSheet.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-0],
                                               [bottomSheet.heightAnchor constraintEqualToConstant:210]].mutableCopy;
    
    [bottomSheetConstraints addObjectsFromArray:@[[topTitle.topAnchor constraintEqualToAnchor:bottomSheet.topAnchor constant:40],
                                                  [topTitle.leadingAnchor constraintEqualToAnchor:bottomSheet.leadingAnchor constant:0],
                                                  [topTitle.trailingAnchor constraintEqualToAnchor:bottomSheet.trailingAnchor constant:-0]]];
    
    [bottomSheetConstraints addObjectsFromArray:@[[latinButton.topAnchor constraintEqualToAnchor:topTitle.bottomAnchor constant:19],
                                                  [latinButton.leadingAnchor constraintEqualToAnchor:bottomSheet.leadingAnchor constant:46],
                                                  [latinButton.trailingAnchor constraintEqualToAnchor:bottomSheet.trailingAnchor constant:-26]]];
    
    [bottomSheetConstraints addObjectsFromArray:@[[arabicButton.topAnchor constraintEqualToAnchor:latinButton.bottomAnchor constant:16],
                                                  [arabicButton.leadingAnchor constraintEqualToAnchor:bottomSheet.leadingAnchor constant:46],
                                                  [arabicButton.trailingAnchor constraintEqualToAnchor:bottomSheet.trailingAnchor constant:-26]]];
    
    [self.view addConstraints:bottomSheetConstraints];
    [NSLayoutConstraint activateConstraints:bottomSheetConstraints];
    [self setLatinScriptButtonActions];
    [self setArabicScriptButtonActions];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)setLatinScriptButtonActions {
    [self.latinScriptButton addTarget:self action:@selector(selectedScriptSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.latinScriptButton addTarget:self action:@selector(setUnselectedButton:) forControlEvents:UIControlEventTouchDown];
}

- (void)setArabicScriptButtonActions {
    [self.arabicScriptbutton addTarget:self action:@selector(selectedScriptSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.arabicScriptbutton addTarget:self action:@selector(setUnselectedButton:) forControlEvents:UIControlEventTouchDown];
}

- (void)setUnselectedButton:(UIButton*)sender {
    [sender setSelected:NO];
}

- (void)selectedScriptSelected:(UIButton*)sender {
    [sender setSelected:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeScript:(BOOL)isArabic {
    if (self.delegate) {
        [self.delegate changeScript:isArabic];
    }
}

@end
