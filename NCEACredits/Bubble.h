//
//  Bubble.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BubbleDelegate <NSObject>

- (void)redrawAnchors;

@end

@interface Bubble : UIView

@property id<BubbleDelegate> delegate;
@property BOOL usesDelegateToCallRedrawAnchors;

@property UIColor *colour;
@property UIImageView *icon;
@property UILabel *title;

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate;

- (void)startWiggle;
- (void)wiggle;
- (void)stopWiggle;
- (float)secondsForPixelsToMoveBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB;
@property float wiggleSpeedFPS, wiggleSpeedPixelsPerFrame, wiggleTurnSpeed;
@property float direction;
@property BOOL wiggles, clockwise, callsDelegateAfterWiggle;
@property NSTimer *wiggleTimer;

@end