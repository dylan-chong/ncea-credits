//
//  MainViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "SetupRootController.h"
#import <MessageUI/MessageUI.h>

#define FACEBOOK_LINK @"https://www.facebook.com/nceacredits"
#define APP_STORE_LINK @"https://itunes.apple.com/us/app/ncea-credits/id959483858?ls=1&mt=8"

@interface MainViewController : BubbleViewController <SetupRootControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) BubbleContainer *addContainer, *gradesContainer, *statsContainer, *optionsContainer;
@property BOOL hasShownSocialPopupRequest;
@property BOOL isShowingMainBubblePopup;

- (void)showSetupWindow;
- (void)updateMainBubbleStats;

@end
