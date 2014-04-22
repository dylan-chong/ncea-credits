//
//  PanScroller.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollArrowView.h"

@protocol PanScrollerDelegate <NSObject>
@required
- (void)currentValueChanged:(double)value;
@end


@interface PanScroller : NSObject

@property UIPanGestureRecognizer *gesture;
@property UIView *containerView;
@property ScrollArrowView *upArrow, *downArrow;

@property NSTimer *inertiaTimer;
@property double currentInertia;

@property double max, currentValue;
@property id <PanScrollerDelegate>delegate;

#warning TODO: opposite scrolling mode
- (id)initWithMax:(double)max currentValue:(double)cv container:(UIView *)container andDelegate:(id)delegate;
- (void)resetArrowPositionsAndSetNewMax:(double)m;
+ (CGSize)getContainerSize:(UIView *)container;

- (void)scrollToDecimal:(double)decimal;

- (void)show;
- (void)hide;

@end