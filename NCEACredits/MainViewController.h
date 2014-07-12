//
//  MainViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "SetupModalController.h"

@interface MainViewController : BubbleViewController

@property (weak, nonatomic) BubbleContainer *addContainer, *gradesContainer, *statsContainer, *optionsContainer;
@property SetupModalController *setupController;

@end
