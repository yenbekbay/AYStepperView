//
//  AYStepperView.m
//  AYStepperView
//
//  Created by Ayan Yenbekbay on 10/24/15.
//  Copyright © 2015 Ayan Yenbekbay. All rights reserved.
//

#import "AYStepperView.h"

#import <pop/POP.h>

static UIEdgeInsets const kStepperViewPadding = {
  15, 0, 15, 0
};
static CGFloat const kStepperLabelsSpacing = 10;
static CGFloat const kStepperPipeHeight = 5;

@interface AYStepperView ()

@property (nonatomic) UIView *pipeView;
@property (nonatomic) UIView *labelsView;
@property (nonatomic) UIView *pipeBackgroundView;
@property (nonatomic) UIView *pipeFillView;
@property (nonatomic) NSMutableArray *stepLabels;

@end

@implementation AYStepperView

#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
  self = [super initWithFrame:frame];
  if (!self) {
    return nil;
  }

  _titles = titles;
  self.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1];
  self.tintColor = [UIColor colorWithRed:0.2f green:0.29f blue:0.37f alpha:1];

  self.pipeView = [[UIView alloc] initWithFrame:CGRectMake(kStepperViewPadding.left, kStepperViewPadding.top, CGRectGetWidth(self.bounds) - kStepperViewPadding.left - kStepperViewPadding.right, CGRectGetHeight(self.bounds) / 2 - kStepperViewPadding.top)];
  [self addSubview:self.pipeView];

  self.labelsView = [[UIView alloc] initWithFrame:CGRectMake(kStepperViewPadding.left, CGRectGetMaxY(self.pipeView.frame) + kStepperViewPadding.top, CGRectGetWidth(self.bounds) - kStepperViewPadding.left - kStepperViewPadding.right, CGRectGetHeight(self.bounds) / 2 - kStepperViewPadding.top - kStepperViewPadding.bottom)];
  [self addSubview:self.labelsView];

  self.pipeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.pipeView.bounds) - kStepperPipeHeight) / 2, CGRectGetWidth(self.pipeView.bounds), kStepperPipeHeight)];
  self.pipeBackgroundView.backgroundColor = [UIColor lightGrayColor];
  [self.pipeView addSubview:self.pipeBackgroundView];

  CGRect pipeFillViewFrame = self.pipeBackgroundView.frame;
  pipeFillViewFrame.size.width = 0;
  self.pipeFillView = [[UIView alloc] initWithFrame:pipeFillViewFrame];
  self.pipeFillView.backgroundColor = self.tintColor;
  [self.pipeView addSubview:self.pipeFillView];

  _stepButtons = [NSMutableArray new];
  _stepLabels = [NSMutableArray new];
  for (NSUInteger i = 0; i < titles.count; i++) {
    UIButton *stepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.pipeView.bounds), CGRectGetHeight(self.pipeView.bounds))];
    stepButton.center = CGPointMake(CGRectGetWidth(self.pipeView.bounds) * (i + 0.5f) / titles.count, stepButton.center.y);
    stepButton.clipsToBounds = YES;
    stepButton.layer.cornerRadius = CGRectGetHeight(stepButton.bounds) / 2;
    stepButton.backgroundColor = [UIColor lightGrayColor];
    [self.pipeView addSubview:stepButton];
    [self.stepButtons addObject:stepButton];

    UILabel *stepLabel = [UILabel new];
    stepLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    stepLabel.textColor = self.tintColor;
    stepLabel.textAlignment = NSTextAlignmentCenter;
    stepLabel.text = titles[i];
    stepLabel.numberOfLines = 0;
    stepLabel.frame = (CGRect) {
      stepLabel.frame.origin, [stepLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.pipeView.bounds) / titles.count - kStepperLabelsSpacing, 0)]
    };
    stepLabel.center = CGPointMake(CGRectGetWidth(self.labelsView.bounds) * (i + 0.5f) / titles.count, CGRectGetHeight(self.labelsView.bounds) / 2);
    [self.labelsView addSubview:stepLabel];
    [self.stepLabels addObject:stepLabel];
  }
  _currentStepIndex = 0;
  [self completeStepAtIndex:0 until:1 completionBlock:nil];

  return self;
}

#pragma mark Public

- (void)updateCurrentStepIndex:(NSUInteger)currentStepIndex completionBlock:(void (^)())completionBlock {
  if (currentStepIndex >= self.titles.count || currentStepIndex == self.currentStepIndex) {
    if (completionBlock) {
      completionBlock();
    }
  } else {
    NSUInteger previousStepIndex = self.currentStepIndex;
    _currentStepIndex = currentStepIndex;
    if ((NSInteger)currentStepIndex - (NSInteger)previousStepIndex > 0) {
      [self completeStepAtIndex:previousStepIndex + 1 until:currentStepIndex + 1 completionBlock:completionBlock];
    } else {
      [self uncompleteStepAtIndex:previousStepIndex until:currentStepIndex - 1 completionBlock:completionBlock];
    }
  }
}

#pragma mark Setters

- (void)setTintColor:(UIColor *)tintColor {
  _tintColor = tintColor;
  self.pipeFillView.backgroundColor = tintColor;
  for (UILabel *label in self.stepLabels) {
    label.textColor = tintColor;
  }
  [self.stepButtons[self.currentStepIndex] setBackgroundColor:tintColor];
}

#pragma mark Private

- (void)completeStepAtIndex:(NSUInteger)index until:(NSUInteger)until completionBlock:(void (^)())completionBlock {
  if (index == until) {
    if (completionBlock) {
      completionBlock();
    }
  } else {
    [UIView animateWithDuration:0.2f animations:^{
      CGRect pipeFillViewFrame = self.pipeFillView.frame;
      pipeFillViewFrame.size.width = CGRectGetWidth(self.pipeBackgroundView.bounds) * (index + 0.5f) / self.titles.count;
      self.pipeFillView.frame = pipeFillViewFrame;
    } completion:^(BOOL finishedWidthAnimation) {
      [self completeStepAtIndex:index + 1 until:until completionBlock:completionBlock];
      UIView *stepButton = self.stepButtons[index];
      stepButton.backgroundColor = self.tintColor;
      POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
      scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
      scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
      scaleAnimation.springBounciness = 5.f;
      [stepButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }];
  }
}

- (void)uncompleteStepAtIndex:(NSUInteger)index until:(NSUInteger)until completionBlock:(void (^)())completionBlock {
  if (index == until) {
    if (completionBlock) {
      completionBlock();
    }
  } else {
    if (index > until + 1) {
      UIView *stepButton = self.stepButtons[index];
      stepButton.backgroundColor = [UIColor lightGrayColor];
      POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
      scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
      scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
      scaleAnimation.springBounciness = 5.f;
      [stepButton.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
    [UIView animateWithDuration:0.2f animations:^{
      CGRect pipeFillViewFrame = self.pipeFillView.frame;
      pipeFillViewFrame.size.width = CGRectGetWidth(self.pipeBackgroundView.bounds) * (index + 0.5f) / self.titles.count;
      self.pipeFillView.frame = pipeFillViewFrame;
    } completion:^(BOOL finishedWidthAnimation) {
      [self uncompleteStepAtIndex:index - 1 until:until completionBlock:completionBlock];
    }];
  }
}

@end
