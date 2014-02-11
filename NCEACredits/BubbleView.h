//
//  BubbleView.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleContainer.h"
#import "AnchorView.h"
#import "BubbleViewController.h"

@protocol BubbleViewTransitionDelegate <NSObject>
@optional
- (void)reverseTransitionToPreviousBubbleContainerPosition;
@end

@interface BubbleView : UIView <BubbleContainerDelegate, AnimationObjectDelegate, AnimationManagerDelegate, BubbleViewTransitionDelegate>

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property AnchorView *anchors;
@property BOOL disableAnchorReDraw;
@property BOOL hasStartedGrowingAnimation, isDoingAnimation;
@property (nonatomic) AnimationManager *animationManager;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startChildBubbleCreationAnimation;

- (void)repositionBubbles;

@property id<BubbleViewTransitionDelegate> delegate;
- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController;
@property (strong, nonatomic) BubbleViewController *childBubbleViewController;
@property (weak, nonatomic) BubbleContainer *transitionBubble;
@property float transitionXDif, transitionYDif;
- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container;

- (void)enableChildButtons;
- (void)disableChildButtons;

@end
