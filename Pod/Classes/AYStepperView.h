//
//  AYStepperView.h
//  AYStepperView
//
//  Created by Ayan Yenbekbay on 10/24/15.
//  Copyright © 2015 Ayan Yenbekbay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYStepperView : UIView

#pragma mark Properties

/**
 *  Tint color for the stepper view. Affects the colors of the labels and the pipe background.
 */
@property (nonatomic) UIColor *tintColor;
/**
 *  Contains the titles for the steps.
 */
@property (nonatomic, readonly) NSArray *titles;
/**
 *  Contains the buttons for the steps.
 */
@property (nonatomic, readonly) NSMutableArray *stepButtons;
/**
 *  Current active step index.
 */
@property (nonatomic, readonly) NSUInteger currentStepIndex;

#pragma mark Methods

/**
 *  Create a stepper view with specified frame and step titles.
 *
 *  @param frame  The frame rectangle for the view, measured in points.
 *  @param titles Array of titles for steps.
 *
 *  @return Newly created AYStepperView object.
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
/**
 *  Change the active step index with animation.
 *
 *  @param currentStepIndex Step index to set as active.
 *  @param completionBlock  Action to be performed when the animation is completed.
 */
- (void)updateCurrentStepIndex:(NSUInteger)currentStepIndex completionBlock:(void (^)())completionBlock;

@end
