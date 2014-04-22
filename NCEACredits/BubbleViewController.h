//
//  BubbleViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleContainer.h"
#import "AnchorView.h"
#import <QuartzCore/QuartzCore.h>

@protocol BubbleViewControllerTransitionDelegate
//child view controllers will implement the delegate to communicate with the parent
- (void)hasReturnedFromChildViewController;
@end

@interface BubbleViewController : UIViewController <BubbleContainerDelegate, AnimationObjectDelegate, AnimationManagerDelegate, BubbleViewControllerTransitionDelegate>

@property id<BubbleViewControllerTransitionDelegate> delegate;
@property UIView *statusBarFiller;

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property (weak, nonatomic) BubbleContainer *parentBubble;
@property AnchorView *anchors;
- (void)createAnchors;
@property BOOL disableAnchorReDraw;
@property BOOL hasStartedGrowingAnimation, isDoingAnimation;
@property (nonatomic) AnimationManager *animationManager;
@property BOOL isCurrentViewController;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startChildBubbleCreationAnimation;
- (void)startReturnScaleAnimation;
- (void)startReturnSlideAnimation;

- (void)repositionBubbles;

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController;
@property (strong, nonatomic) BubbleViewController *childBubbleViewController;
@property (weak, nonatomic) BubbleContainer *transitionBubble;
@property float transitionXDif, transitionYDif;
- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container;

- (void)enableChildButtons;
- (void)disableChildButtons;
@end
