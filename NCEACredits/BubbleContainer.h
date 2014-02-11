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

typedef enum {
    MainBubble = 1,
    TitleBubble = 2,
    SubtitleBubble = 3
} BubbleType;

@protocol BubbleContainerDelegate <BubbleDelegate>

@end

typedef CGRect (^PositionCalculationBlock) (void);

@interface BubbleContainer : UIView <BubbleDelegate, AnimationObjectDelegate>

@property id<BubbleContainerDelegate> delegate;

@property Bubble *bubble;
@property BubbleType bubbleType;
@property CGRect rectToMoveTo;
@property AnimationManager *animationManager;
@property UIColor *colour;
@property (nonatomic, copy) PositionCalculationBlock calulatePosition;

- (id)initMainBubbleWithFrameCalculator:(PositionCalculationBlock)b;
- (id)initTitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate;
- (id)initSubtitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour title:(NSString *)title andDelegate:(BOOL)hasDelegate;

- (AnimationManager *)getAnimationManagerForMainBubbleGrowth;
- (void)startGrowingMainBubbleAnimation;
- (NSArray *)getAnimationObjectsForXDif:(float)xDif andYDif:(float)yDif;
- (NSArray *)getAnimationObjectsForSlidingAnimation;

+ (CGRect)getCentreOfMainBubbleWithSize:(CGSize)size;

@end
