//
//  ScrollArrowView.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StandardScrollArrowWidth 25
#define StandardScrollArrowHeight 5
#define StandardScrollArrowSpaceFromEdge 25

#define StandardScrollArrowShowAlpha 0.5

@interface ScrollArrowView : UIView

@property UIView *container;
@property BOOL isUp;
@property BOOL enabled;

- (id)initWithContainer:(UIView *)container upDirectionInsteadOfDown:(BOOL)isUp andSizeOrZero:(CGSize)size;
- (void)resetPositionAnimated:(BOOL)animated;

- (void)show;
- (void)hide;

@end
