//
//  AYViewController.m
//  AYStepperView
//
//  Created by Ayan Yenbekbay on 12/01/2015.
//  Copyright (c) 2015 Ayan Yenbekbay. All rights reserved.
//

#import "AYViewController.h"

#import <AYStepperView/AYStepperView.h>
#import <MBXPageViewController/MBXPageViewController.h>

static CGFloat const kFormStepperViewHeight = 100;

@interface AYViewController () <MBXPageControllerDataSource, MBXPageControllerDataDelegate>

@property (nonatomic) AYStepperView *stepperView;
@property (nonatomic) MBXPageViewController *pageController;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger currentStep;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIViewController *firstStepViewController;
@property (nonatomic) UIViewController *secondStepViewController;
@property (nonatomic) UIViewController *thirdStepViewController;

@end

@implementation AYViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSLocalizedString(@"Complete the form", nil);
  self.view.backgroundColor = [UIColor whiteColor];

  [self setUpViews];
  [self setUpViewControllers];
  self.currentIndex = 0;
  self.currentStep = 0;

  self.pageController = [MBXPageViewController new];
  self.pageController.MBXDataSource = self;
  self.pageController.MBXDataDelegate = self;
  [self.pageController reloadPages];

  for (UIScrollView *view in self.pageController.view.subviews) {
    if ([view isKindOfClass:[UIScrollView class]]) {
      view.scrollEnabled = NO;
    }
  }
}

#pragma mark Private

- (void)setUpViews {
  self.stepperView = [[AYStepperView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.bounds), kFormStepperViewHeight) titles:@[NSLocalizedString(@"Start", nil), NSLocalizedString(@"Continue", nil), NSLocalizedString(@"Complete", nil)]];
  self.stepperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  self.stepperView.userInteractionEnabled = YES;
  [self.view addSubview:self.stepperView];

  self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.stepperView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.stepperView.frame))];
  [self.view addSubview:self.containerView];
}

- (void)setUpViewControllers {
  NSArray *colors = @[
    [UIColor colorWithRed:0.18f green:0.8f blue:0.44f alpha:1],
    [UIColor colorWithRed:0.2f green:0.6f blue:0.86f alpha:1],
    [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1]
  ];
  self.firstStepViewController = [UIViewController new];
  self.secondStepViewController = [UIViewController new];
  self.thirdStepViewController = [UIViewController new];
  [@[self.firstStepViewController, self.secondStepViewController, self.thirdStepViewController] enumerateObjectsUsingBlock :^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
    viewController.view.backgroundColor = colors[idx];
  }];
}

#pragma mark MBXPageControllerDataSource

- (NSArray *)MBXPageButtons {
  return self.stepperView.stepButtons;
}

- (UIView *)MBXPageContainer {
  return self.containerView;
}

- (NSArray *)MBXPageControllers {
  return @[self.firstStepViewController, self.secondStepViewController, self.thirdStepViewController];
}

#pragma mark MBXPageControllerDataDelegate

- (void)MBXPageChangedToIndex:(NSInteger)index {
  _currentIndex = (NSUInteger)index;
  self.view.userInteractionEnabled = NO;
  [self.stepperView updateCurrentStepIndex:(NSUInteger)index completionBlock:^{
    self.view.userInteractionEnabled = YES;
  }];
}

@end
