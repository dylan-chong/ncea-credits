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

@protocol BubbleViewControllerTransitionDelegate <NSObject>
//child view controllers will implement the delegate to communicate with the parent
- (void)reverseTransitionToPreviousBubbleContainerPosition;
@end

@interface BubbleViewController : UIViewController <BubbleContainerDelegate, AnimationObjectDelegate, AnimationManagerDelegate, BubbleViewControllerTransitionDelegate>

@property id<BubbleViewControllerTransitionDelegate> delegate;

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property AnchorView *anchors;
@property BOOL disableAnchorReDraw;
@property BOOL hasStartedGrowingAnimation, isDoingAnimation;
@property (nonatomic) AnimationManager *animationManager;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startChildBubbleCreationAnimation;

- (void)repositionBubbles;

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController;
@property (strong, nonatomic) BubbleViewController *childBubbleViewController;
@property (weak, nonatomic) BubbleContainer *transitionBubble;
@property float transitionXDif, transitionYDif;
- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container;

- (void)enableChildButtons;
- (void)disableChildButtons;
@end
