//
//  BubbleContainer.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bubble.h"
#import "BubbleMain.h"
#import "Styles.h"
#import "AnimationObject.h"
#import "AnimationManager.h"

@protocol BubbleContainerDelegate <BubbleDelegate>
@optional
- (void)slidingAnimationHasCompleted;
@end

@interface BubbleContainer : UIView <BubbleDelegate, AnimationObjectDelegate, AnimationManagerDelegate>

@property id<BubbleContainerDelegate> delegate;

@property Bubble *bubble;
@property BOOL isMainBubbleContainer;
@property CGRect rectToMoveTo;
@property AnimationManager *animationManager;

- (id)initMainBubble;
- (id)initTitleBubbleWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate;
- (void)startSlidingAnimation;
- (void)startGrowingAnimationWithAnimationManager:(AnimationManager *)a;
+ (AnimationManager *)getAnimationManagerForGrowingAnimationWithStartingScaleFactor:(float)factor andDelegate:(id)delegate;
- (void)startGrowingMainBubbleAnimation;

@end
