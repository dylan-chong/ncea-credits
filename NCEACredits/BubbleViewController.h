//
//  BubbleViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleContainer.h"
#import "AnimationManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AnchorView.h"

@protocol BubbleViewControllerDelegate
//child view controllers will implement the delegate to communicate with the parent
- (void)hasReturnedFromChildViewController;
- (Corner)getCornerOfParentMainBubble;
- (NSString *)getTitleOfMainBubble;
@end

@interface BubbleViewController : UIViewController <AnimationObjectDelegate, AnimationManagerDelegate, BubbleViewControllerDelegate>

- (NSString *)GET_CHILD_MAIN_BUBBLE_OVERRIDE_TITLE;

@property id<BubbleViewControllerDelegate> delegate;
@property UIView *statusBarFiller;
@property CGSize initiallyThoughtScreenSize;

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property (weak, nonatomic) BubbleContainer *parentBubble;
@property BOOL hasStartedGrowingAnimation, isDoingAnimation;
@property (nonatomic) AnimationManager *animationManager;
@property BOOL isCurrentViewController, shouldDelayCreationAnimation, hasDoneCreationAnimation, hasInitiatedCreationAnimation;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startGrowingAnimation;
- (void)startChildBubbleCreationAnimation;
- (void)startReturnScaleAnimation;
- (void)startReturnSlideAnimation;
- (void)hasTransitionedFromParentViewController;
- (void)creationAnimationHasFinished;

- (void)repositionBubbles;
- (void)hasRepositionedBubbles;

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController;
@property (strong, nonatomic) BubbleViewController *childBubbleViewController;
@property (weak, nonatomic) BubbleContainer *transitionBubble;
@property float transitionXDif, transitionYDif;
- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container;
@property BubbleContainer *lastTappedBubble;
- (void)bubbleWasPressed:(BubbleContainer *)container;

- (void)enableChildButtons;
- (void)disableChildButtons;

- (Corner)getCornerOfChildVCNewMainBubble:(BubbleContainer *)bubble;

- (BubbleContainer *)getChildBubbleContainerForTitle:(NSString *)title;

//Wiggle and anchor
- (void)startWiggle;
- (void)wiggle;
- (void)stopWiggle;
@property NSTimer *wiggleTimer;
@property BOOL drawsAnchors;
@property AnchorView *anchors;

+ (BOOL)allowsAnchorRedrawToStopWhenBubbleContainersAreStationary;
- (void)createAnchorsIfNonExistent;

- (void)mainBubbleWasPressed;
@end
