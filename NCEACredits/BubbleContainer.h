//
//  BubbleContainer.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bubble.h"
#import "AnimationObject.h"

@class AnimationManager;

typedef NS_ENUM(NSInteger, BubbleType) {
    MainBubble = 1,
    TitleBubble,
    SubtitleBubble
};

typedef CGRect (^PositionCalculationBlock) (void);

@interface BubbleContainer : UIView <AnimationObjectDelegate>

@property Bubble *bubble;
@property BubbleType bubbleType;
@property CGRect rectToMoveTo;
@property AnimationManager *animationManager;
@property UIColor *colour;
@property NSString *imageName;
@property (nonatomic, copy) PositionCalculationBlock calulatePosition;

- (id)initMainBubbleWithFrameCalculator:(PositionCalculationBlock)b;
- (id)initTitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title frameBubbleForStartingPosition:(CGRect)startingFrame andDelegate:(BOOL)hasDelegate;
- (id)initSubtitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour title:(NSString *)title frameBubbleForStartingPosition:(CGRect)startingFrame andDelegate:(BOOL)hasDelegate;

- (AnimationManager *)getAnimationManagerForMainBubbleGrowth;
- (void)startGrowingMainBubbleAnimation;
- (NSArray *)getAnimationObjectsForSlidingAnimation;

- (NSArray *)getAnimationObjectsForXDif:(float)xDif andYDif:(float)yDif;
- (NSArray *)getAnimationObjectsToGoToOrigin:(CGPoint)origin;

@end
