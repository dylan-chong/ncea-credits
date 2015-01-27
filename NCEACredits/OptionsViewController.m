//
//  OptionsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 27/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "OptionsViewController.h"
#import "SetupNavigationController.h"
#import "OptionsProfileViewController.h"

#define OptionsBubbleTitleAnimationSpeed @"Speed"
#define OptionsBubbleTitleSendFeedback @"Send Feedback"
#define OptionsBubbleTitleProfileSettings @"Profile Settings"

#define FEEDBACK_RECIPIENT @[@"dylanchongit@gmail.com"]
#define FEEDBACK_SUBJECT [NSString stringWithFormat:@"NCEA Credits v%@ Feedback: ", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]
#define FEEDBACK_BODY @"Hello, \n\nI have some feedback for NCEA Credits: \n\n\nThanks"

@implementation OptionsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSArray *titles = @[OptionsBubbleTitleProfileSettings,
                        OptionsBubbleTitleAnimationSpeed,
                        OptionsBubbleTitleSendFeedback
                        ];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for (NSString *t in titles) {
        [pairs addObject:[SubjectColourPair pairWithSubject:t andColour:nil]]; //nil colour - defaults to main bubble colour
    }
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectColourPairs:pairs target:self staggered:YES corner:[self getCornerOfChildVCNewMainBubble:self.mainBubble] andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}


//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Press    ************************************
//*************************
//****************
//*********
//****
//*
- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    NSString *title = container.bubble.title.text;
    
    if ([title isEqualToString:OptionsBubbleTitleAnimationSpeed]) {
        [self animationSpeedPressed];
    } else if ([title isEqualToString:OptionsBubbleTitleSendFeedback]) {
        [self sendFeedbackPressed];
    } else if ([title isEqualToString:OptionsBubbleTitleProfileSettings]) {
        [self profileSettingsPressedWithContainer:container];
    }
}

- (void)profileSettingsPressedWithContainer:(BubbleContainer *)container {
    OptionsProfileViewController *vc = [[OptionsProfileViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
    [self startTransitionToChildBubble:container andBubbleViewController:vc];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Send Feedback    ************************************
//*************************
//****************
//*********
//****
//*

- (void)sendFeedbackPressed {
    [[self class] showMailPopupInViewControllerWithMFMailComposeDelegate:self];
}

+ (void)showMailPopupInViewControllerWithMFMailComposeDelegate:(UIViewController<MFMailComposeViewControllerDelegate> *)controller {
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setSubject:FEEDBACK_SUBJECT];
    [mailVC setToRecipients:FEEDBACK_RECIPIENT];
    [mailVC setMessageBody:FEEDBACK_BODY isHTML:NO];
    [mailVC setMailComposeDelegate:controller];
    [controller presentViewController:mailVC animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) NSLog(@"%@", [error localizedDescription]);
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Animation Speed    ************************************
//*************************
//****************
//*********
//****
//*

- (void)animationSpeedPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Pick the speed for the animations." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Faster" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setAnimationSpeed:AnimationSpeedSelectionFaster withTitle:action.title];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Fast" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setAnimationSpeed:AnimationSpeedSelectionFast withTitle:action.title];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Medium (Default)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setAnimationSpeed:AnimationSpeedSelectionNormal withTitle:action.title];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Slow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setAnimationSpeed:AnimationSpeedSelectionSlow withTitle:action.title];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Slower" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self setAnimationSpeed:AnimationSpeedSelectionSlower withTitle:action.title];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)setAnimationSpeed:(AnimationSpeedSelection)selection withTitle:(NSString *)title {
    CurrentAppSettings.animationSpeed = selection;
    [CurrentAppDelegate saveCurrentProfileAndAppSettings];
    
    NSString *mess = [NSString stringWithFormat:@"Animation speed set to '%@'.", title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
