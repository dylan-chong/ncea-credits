//
//  BubbleMain.h
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Bubble.h"
#import "BubbleMainCredits.h"
#import "AnimationManager.h"
#import "GoalTitle.h"

@class AnimationManager, BubbleMainCredits, GoalTitle;
@interface BubbleMain : Bubble

@property BubbleMainCredits *excellenceCredits;
@property BubbleMainCredits *achievedCredits;
@property BubbleMainCredits *meritCredits;

@property AnimationManager *animationManager;
@property GoalTitle* goal;

- (void)updateStats;

@end
