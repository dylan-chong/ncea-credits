//
//  MainViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "SetupRootController.h"

@interface MainViewController : BubbleViewController <SetupRootControllerDelegate>

@property (weak, nonatomic) BubbleContainer *addContainer, *gradesContainer, *statsContainer, *optionsContainer;

- (void)showSetupWindow;
- (void)updateMainBubbleStats;

@end
