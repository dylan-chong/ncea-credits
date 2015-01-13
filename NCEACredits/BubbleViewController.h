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

@interface BubbleViewController : UIViewController <BubbleContainerDelegate, AnimationObjectDelegate, AnimationManagerDelegate, BubbleViewControllerDelegate>

@property id<BubbleViewControllerDelegate> delegate;
@property UIView *statusBarFiller;

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property (weak, nonatomic) BubbleContainer *parentBubble;
@property AnchorView *anchors;
- (void)createAnchors;
@property BOOL disableAnchorReDraw;
@property BOOL hasStartedGrowingAnimation, isDoingAnimation;
@property (nonatomic) AnimationManager *animationManager;
@property BOOL isCurrentViewController, shouldDelayCreationAnimation, hasDoneCreationAnimation, hasInitiatedCreationAnimation;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startChildBubbleCreationAnimation;
- (void)startReturnScaleAnimation;
- (void)startReturnSlideAnimation;
- (void)hasTransitionedFromParentViewController;

- (void)repositionBubbles;

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

@end
