//
//  OptionsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 27/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "OptionsViewController.h"
#import "SetupNavigationController.h"

#define OptionsBubbleTitleShowSetup @"Edit Profile"
#define OptionsBubbleTitleSwitchProfile @"Switch Profile"
#define OptionsBubbleTitleNewProfile @"New Profile"
#define OptionsBubbleTitleDeleteProfile @"Delete Profile"
#define OptionsBubbleTitleAnimationSpeed @"Speed"

#define CANNOT_DELETE_STRING_FORMAT @"%@ (Cannot delete current)"

@implementation OptionsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSArray *titles = @[OptionsBubbleTitleShowSetup,
                        #warning TODO: delete profile
                        OptionsBubbleTitleSwitchProfile,
                        OptionsBubbleTitleNewProfile,
                        OptionsBubbleTitleDeleteProfile,
//                        OptionsBubbleTitleAnimationSpeed
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
    } else if ([title isEqualToString:OptionsBubbleTitleSwitchProfile]) {
        [self switchProfilePressed];
    } else if ([title isEqualToString:OptionsBubbleTitleShowSetup]) {
        [self showSetupPressed];
    } else if ([title isEqualToString:OptionsBubbleTitleNewProfile]) {
        [self newProfilePressed];
    } else if ([title isEqualToString:OptionsBubbleTitleDeleteProfile]) {
        [self deleteProfilePressed];
    }
}

- (void)showSetupPressed {
    CurrentAppSettings.setupState = SETUP_STATE_EDIT_PROFILE;
    [SetupNavigationController showStoryboardFromViewController:self];
}

- (void)newProfilePressed {
    CurrentAppSettings.setupState = SETUP_STATE_NEW_PROFILE_NOT_INITIAL;
    [SetupNavigationController showStoryboardFromViewController:self];
}

- (void)animationSpeedPressed {
   
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Delete    ************************************
//*************************
//****************
//*********
//****
//*

- (void)deleteProfilePressed {
    NSArray *names = [ApplicationDelegate getUsedProfileNames];
    //    NSString *current = CurrentProfile.profileName;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Pick a profile to delete" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *title;
    for (NSString *name in names) {
        
        if ([name isEqualToString:CurrentProfile.profileName])
            title = [NSString stringWithFormat:CANNOT_DELETE_STRING_FORMAT, name];
        else
            title = name;
        
        UIAlertAction *a = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self confirmDeleteProfileWithAction:action];
        }];
        [alert addAction:a];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmDeleteProfileWithAction:(UIAlertAction *)action {
    if ([action.title isEqualToString:[NSString stringWithFormat:CANNOT_DELETE_STRING_FORMAT, CurrentProfile.profileName]]) {
        //Current selected
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"You cannot delete your current profile. Please switch to a different one, then delete this one." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //Not current
        NSString *mess = [NSString stringWithFormat:@"Are you sure you want to delete the profile called '%@'?", action.title];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *confirmationAction) {
            //Delete
            [self deleteProfileWithTitle:action.title];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)deleteProfileWithTitle:(NSString *)profTitle {
    [ApplicationDelegate deleteProfileWithProfileName:profTitle];
    
    NSString *deletedMess = [NSString stringWithFormat:@"Profile '%@' was deleted.", profTitle];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:deletedMess preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Switch Profile    ************************************
//*************************
//****************
//*********
//****
//*

- (void)switchProfilePressed {
    NSArray *names = [ApplicationDelegate getUsedProfileNames];
    //    NSString *current = CurrentProfile.profileName;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Pick a profile" preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *name in names) {
        UIAlertAction *a = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //Tapped
            [ApplicationDelegate switchToProfile:action.title];
            
            NSString *mess = [NSString stringWithFormat:@"Profile '%@' was loaded.", action.title];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [alert addAction:a];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Return from profile    ************************************
//*************************
//****************
//*********
//****
//*

- (void)setupWillBeDismissed {
    //Don't delete - delegate method must exist
}

@end
