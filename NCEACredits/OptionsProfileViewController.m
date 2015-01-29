//
//  OptionsProfileViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 27/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "OptionsProfileViewController.h"

#define OptionsBubbleTitleShowSetup @"Edit Profile"
#define OptionsBubbleTitleSwitchProfile @"Switch Profile"
#define OptionsBubbleTitleNewProfile @"New Profile"
#define OptionsBubbleTitleDeleteProfile @"Delete Profile"

#define CANNOT_DELETE_STRING_FORMAT @"%@ (Cannot delete current)"

@implementation OptionsProfileViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSArray *titles = @[OptionsBubbleTitleShowSetup,
                        OptionsBubbleTitleNewProfile,
                        OptionsBubbleTitleSwitchProfile,
                        OptionsBubbleTitleDeleteProfile];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for (NSString *t in titles) {
        [pairs addObject:[SubjectColourPair pairWithSubject:t andColour:nil]]; //nil colour - defaults to main bubble colour
    }
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectColourPairs:pairs target:self staggered:YES corner:[self getCornerOfChildVCNewMainBubble:self.mainBubble] andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (void)flashHomeButton {
    [Styles flashStartWithView:self.homeButton numberOfTimes:FLASH_DEFAULT_TIMES sizeIncreaseMultiplierOr0ForDefault:2.0];
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

    if ([title isEqualToString:OptionsBubbleTitleSwitchProfile]) {
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
    CurrentAppDelegate.setupState = SETUP_STATE_EDIT_PROFILE;
    [SetupNavigationController showStoryboardFromViewController:self];
}

- (void)newProfilePressed {
    CurrentAppDelegate.setupState = SETUP_STATE_NEW_PROFILE_NOT_INITIAL;
    [SetupNavigationController showStoryboardFromViewController:self];
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
    NSArray *names = [CurrentAppDelegate getUsedProfileNames];
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
        [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //Not current
        NSString *mess = [NSString stringWithFormat:@"Are you sure you want to delete the profile called '%@'?", action.title];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes, I'm sure" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *confirmationAction) {
            //Delete
            [self deleteProfileWithTitle:action.title];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"NOO!" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)deleteProfileWithTitle:(NSString *)profTitle {
    [CurrentAppDelegate deleteProfileWithProfileName:profTitle];
    
    NSString *deletedMess = [NSString stringWithFormat:@"Profile '%@' was deleted.", profTitle];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:deletedMess preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
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
    NSArray *names = [CurrentAppDelegate getUsedProfileNames];
    //    NSString *current = CurrentProfile.profileName;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Pick a profile" preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *name in names) {
        UIAlertAction *a = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //Tapped
            [CurrentAppDelegate switchToProfile:action.title];
            
            NSString *mess = [NSString stringWithFormat:@"Profile '%@' was loaded.", action.title];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                [self flashHomeButton];
            }]];
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

//Delegate method
- (void)setuphasBeenDismissed {
    NSString *mess = [NSString stringWithFormat:@"Profile '%@' was saved", CurrentProfile.profileName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if ([self.lastTappedBubble.bubble.title.text isEqualToString:OptionsBubbleTitleNewProfile]) {
            //flash home button if new profile created
            [self flashHomeButton];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
