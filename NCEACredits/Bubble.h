//
//  Bubble.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleText.h"

#define BUBBLE_WITHOUT_ICON_TEXT_FIELD_SPACE_FILL_DECIMAL sqrt(0.5)

@protocol BubbleDelegate <NSObject>

- (void)redrawAnchors;

@end

@interface Bubble : UIView

@property id<BubbleDelegate> delegate;
@property BOOL usesDelegateToCallRedrawAnchors;

@property UIColor *colour;
@property UIImageView *icon;
@property BubbleText *title;

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate;
- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour title:(NSString *)title andDelegate:(BOOL)hasDelegate;

- (void)startWiggle;
- (void)wiggle;
- (void)stopWiggle;
- (float)secondsForPixelsToMoveBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB;
@property float wiggleSpeedPixelsPerFrame, wiggleTurnSpeed;
@property float direction;
@property BOOL wiggles, disableWiggleForTransition, clockwise, callsDelegateAfterWiggle;
@property NSTimer *wiggleTimer;

- (CGPoint)getAnchorPoint;

@end