//
//  OptionsViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 27/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"
#import <MessageUI/MessageUI.h>

@interface OptionsViewController : SimpleSelectionViewController <MFMailComposeViewControllerDelegate>

+ (void)showMailPopupInViewControllerWithMFMailComposeDelegate:(UIViewController<MFMailComposeViewControllerDelegate> *)controller;

@end
