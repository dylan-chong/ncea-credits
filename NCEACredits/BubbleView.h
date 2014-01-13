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

@interface BubbleView : UIScrollView <BubbleContainerDelegate, AnimationObjectDelegate, AnimationManagerDelegate>

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property AnchorView *anchors;
@property BOOL hasStartedGrowingAnimation;
@property AnimationManager *growingAnimationManager, *transitionAnimationManager;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;
- (void)startChildBubbleCreationAnimation;

- (void)startTransitionToChildBubble:(BubbleContainer *)b;
@property (weak, nonatomic) BubbleContainer *transitionBubble;
@property float transitionXDif, transitionYDif;

- (void)enableChildButtons;
- (void)disableChildButtons;

@end
