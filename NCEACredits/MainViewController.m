//
//  MainViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "GradesViewController.h"
#import "OptionsViewController.h"
#import "StatsViewController.h"
#import "SetupNavigationController.h"
#import "BubbleMain.h"

//These cannot be the same
#define LOADS_FOR_APP_STORE_REVIEW 6
#define LOADS_FOR_FACEBOOOK_LIKE 3

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shouldDelayCreationAnimation = YES;
        [self createBubbleContainers];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateMainBubbleStats];
    //Show setup window
    if (![CurrentProfile hasAllNecessaryInformationFromSetup]) {
        //Hasn't shown setup
        CurrentAppDelegate.setupState = SETUP_STATE_NEW_PROFILE_INITIAL;
        [self showSetupWindow];
    } else {
        [self startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup];
    }
    
    [self showReviewPopupIfNecessary];
    [self showGoalCompletionAlertIfNecessary];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Goals    ************************************
//*************************
//****************
//*********
//****
//*

- (void)showGoalCompletionAlertIfNecessary {
    if (!CurrentProfile.hasCompletedGoal && [CurrentProfile goalIsComplete]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"CONGRATULATIONS!\n\nYou did NOT get our 1,000,000th customer prize, but you did get the next best thing!\n\nYou completed YOUR GOAL!\nHOORAY!! TIME TO CELEBRATE!!" preferredStyle:UIAlertControllerStyleAlert];
        
        //opt 1 (alert 1)
        [alert addAction:[UIAlertAction actionWithTitle:@"Ingest suspicious substance" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //opt 1 (alert 2)
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"No celebration for you!\n*snatches celebration out of your hands*" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Fine..." style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                //opt 1 (alert 3)
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"...celebrationless, the miserable teenager walks off in shame, despite completing his proudest achievement.\n\nDon't make the same mistake he did kids.\nDon't do drugs.\n\nDrugs are bad." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    //opt 1 (alert 4)
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"I'll assume you learnt your lesson. Here's your celebration back.\n\nHave fun!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Hooray!" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }]];
        
        //opt 2 (alert 1)
        [alert addAction:[UIAlertAction actionWithTitle:@"Don't ingest suspicious substance" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //opt 2 (alert 2)
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Good. You passed the idiot test.\n\nNow it's time to celebrate!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yay!" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        CurrentProfile.hasCompletedGoal = YES;
        [CurrentAppDelegate saveCurrentProfileAndAppSettings];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Show Review Popups    ************************************
//*************************
//****************
//*********
//****
//*

- (void)showReviewPopupIfNecessary {
    if (!self.hasShownSocialPopupRequest) {
        NSUInteger appLoadCount = CurrentProfile.appOpenTimes;
        
        switch (appLoadCount) {
            case LOADS_FOR_APP_STORE_REVIEW:
                [self showAppStoreReviewPopupWithConfirmation:YES];
                break;
                
            case LOADS_FOR_FACEBOOOK_LIKE:
                [self showFacebookLikePopupWithConfirmation:YES];
                break;
                
            default:
                break;
        }
    }
    
    self.hasShownSocialPopupRequest = YES;
}

- (void)showAppStoreReviewPopupWithConfirmation:(BOOL)withConfirmation {
    if (withConfirmation) {
        NSString *mess = [NSString stringWithFormat:@"Hello, it's that developer guy again.\n\nYou like NCEA Credits so much that you just have write a review on the App Store! Yes, of course you do! You obviously like it enough to open it %lu times. Why wouldn't you want to write a review?", (unsigned long)CurrentProfile.appOpenTimes];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:mess preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yea, why not?" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAppStoreReviewPopupWithConfirmation:NO];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //go to link
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK]];
    }
}

- (void)showFacebookLikePopupWithConfirmation:(BOOL)withConfirmation  {
    if (withConfirmation) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Hello fellow NCEAer,\n\nI am the developer of NCEA Credits. I am also a student working by myself to bring you this app which you love so much (yes you do).\n\nI would appreciate it if you could like my Facebook page, and recommend it to your friends (because NCEA Credits is your favourite app).\n\nThanks,\nDylan" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"MOAR likes!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showFacebookLikePopupWithConfirmation:NO];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //go to link
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FACEBOOK_LINK]];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

- (void)hasReturnedFromChildViewController {
    [super hasReturnedFromChildViewController];
    [self updateMainBubbleStats];
}

- (void)hasRepositionedBubbles {
    [super hasRepositionedBubbles];
    CurrentAppDelegate.bubbleVCisReturningToHomeScreen = NO;
}

- (void)startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup {
    self.shouldDelayCreationAnimation = NO;
    [self startChildBubbleCreationAnimation];
}

- (void)setuphasBeenDismissed {
    //Setup VC delegate method
    [self startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup];
    
    //Tutorial
    if (CurrentAppDelegate.setupState == SETUP_STATE_NEW_PROFILE_INITIAL)
        [self showTutorial];
    
    [self updateMainBubbleStats];
}

- (void)showSetupWindow {
    [SetupNavigationController showStoryboardFromViewController:self];
}

- (void)updateMainBubbleStats {
    [((BubbleMain *)self.mainBubble.bubble) updateStats];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Tutorial Sorta    ************************************
//*************************
//****************
//*********
//****
//*

- (void)showTutorial {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Welcome to %@!", AppName]
                                                                   message:@"Tap the 'Add' button; enter details like subject and quick name; then save. Rinse and repeat!\n\nDon't forget that grades and the AS Number are optional.\n\nHappy credit counting!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"I'm ready!" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self flashAddButton];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)flashAddButton {
    [Styles flashStartWithView:_addContainer numberOfTimes:FLASH_DEFAULT_TIMES sizeIncreaseMultiplierOr0ForDefault:0];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Bubble Containers    ************************************
//*************************
//****************
//*********
//****
//*

- (void)createBubbleContainers {
    PositionCalculationBlock mainBlock = ^(void) {
        return  [Styles mainContainerRect];
    };
    
    self.mainBubble = [[BubbleContainer alloc] initMainBubbleWithFrameCalculator:mainBlock];
    [self.view addSubview:self.mainBubble];
    
    
    PositionCalculationBlock addBlock = ^(void) {
        return  [Styles titleContainerRectWithCorner:TopLeft];
    };
    
    PositionCalculationBlock subjectsBlock = ^(void) {
        return  [Styles titleContainerRectWithCorner:TopRight];
    };
    
    PositionCalculationBlock statsBlock = ^(void) {
        return  [Styles titleContainerRectWithCorner:BottomLeft];
    };
    
    PositionCalculationBlock optionsBlock = ^(void) {
        return  [Styles titleContainerRectWithCorner:BottomRight];
    };
    
    [self setMainBubble:self.mainBubble
        andChildBubbles:[NSArray arrayWithObjects:
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:addBlock colour:[Styles greenColour] iconName:@"Add.png" title:@"Add" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:subjectsBlock colour:[Styles purpleColour] iconName:@"Subjects.png" title:@"Edit" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:statsBlock colour:[Styles blueColour] iconName:@"Stats.png" title:@"Stats" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:optionsBlock colour:[Styles orangeColour] iconName:@"Options.png" title:@"Options" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
                         nil]];
    
    _addContainer = self.childBubbles[0];
    [self.view addSubview:_addContainer];
    
    _gradesContainer = self.childBubbles[1];
    [self.view addSubview:_gradesContainer];
    
    _statsContainer = self.childBubbles[2];
    [self.view addSubview:_statsContainer];
    
    _optionsContainer = self.childBubbles[3];
    [self.view addSubview:_optionsContainer];
    
    [self.view bringSubviewToFront:self.mainBubble];
    
    [self addControlEventsToBubbleContainers];
    self.mainBubble.animationManager = [self.mainBubble getAnimationManagerForMainBubbleGrowth];
    
    [self startChildBubbleCreationAnimation];
}

- (void)addControlEventsToBubbleContainers {
    
    [self.mainBubble addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainBubbleTapped:)]];
    [_addContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addContainerPressed)]];
    [_gradesContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gradesContainerPressed)]];
    [_statsContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statsContainerPressed)]];
    [_optionsContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionsContainerPressed)]];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Child Container Press Events    ************************************
//*************************
//****************
//*********
//****
//*

//------------------------------ Child Bubbles ------------------------------
- (void)addContainerPressed {
    if (!self.isShowingMainBubblePopup) {
        [self bubbleWasPressed:_addContainer];
        
        AddViewController *b = [[AddViewController alloc] initWithMainBubble:_addContainer delegate:self andAssessmentOrNil:nil];
        [self startTransitionToChildBubble:_addContainer andBubbleViewController:b];
    }
}

- (void)gradesContainerPressed {
    if (!self.isShowingMainBubblePopup) {
        [self bubbleWasPressed:_gradesContainer];
        
        if ([CurrentProfile getNumberOfAssessmentsInCurrentYear] > 0) {
            GradesViewController *b = [[GradesViewController alloc] initWithMainBubble:_gradesContainer delegate:self andStaggered:YES];
            [self startTransitionToChildBubble:_gradesContainer andBubbleViewController:b];
        } else {
            [self noAssessmentsAlert];
        }
    }
}

- (void)statsContainerPressed {
    if (!self.isShowingMainBubblePopup) {
        if (!self.isShowingMainBubblePopup) {
            [self bubbleWasPressed:_statsContainer];
            
            if ([CurrentProfile getNumberOfAssessmentsInCurrentYear] > 0) {
                StatsViewController *b = [[StatsViewController alloc] initWithMainBubble:_statsContainer delegate:self andStaggered:YES];
                [self startTransitionToChildBubble:_statsContainer andBubbleViewController:b];
            } else {
                [self noAssessmentsAlert];
            }
        }
    }
}

- (void)optionsContainerPressed {
    if (!self.isShowingMainBubblePopup) {
        [self bubbleWasPressed:_optionsContainer];
        
        OptionsViewController *opt = [[OptionsViewController alloc] initWithMainBubble:_optionsContainer delegate:self andStaggered:YES];
        [self startTransitionToChildBubble:_optionsContainer andBubbleViewController:opt];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Main Container Tap    ************************************
//*************************
//****************
//*********
//****
//*

//------------------------------ Main Bubble ------------------------------

- (void)mainBubbleTapped:(id)sender {
    [self showQuickSettingsActionSheet];
    
    //Log
    [CurrentProfile logJSONText];
    [CurrentAppSettings logJSONText];
    [self logAssessmentGrades];
}

- (void)showQuickSettingsActionSheet {
    if (!self.isDoingAnimation) {
        self.isShowingMainBubblePopup = YES;
        //Popup
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Pick an action." preferredStyle:UIAlertControllerStyleActionSheet];
        
        //add actions
        [alert addAction:[UIAlertAction actionWithTitle:@"Edit Profile (with Goals and Years)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            CurrentAppDelegate.setupState = SETUP_STATE_EDIT_PROFILE;
            [self showSetupWindow];
            self.isShowingMainBubblePopup = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Send us Feedback" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [OptionsViewController showMailPopupInViewControllerWithMFMailComposeDelegate:self];
            self.isShowingMainBubblePopup = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Like on Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showFacebookLikePopupWithConfirmation:NO];
            self.isShowingMainBubblePopup = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Write a Review" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showAppStoreReviewPopupWithConfirmation:NO];
            self.isShowingMainBubblePopup = NO;
        }]];
        if (MAKE_FAKE_ASSESSMENTS && DEBUG_MODE_ON) {
            [alert addAction:[UIAlertAction actionWithTitle:@"Make Dummy Assessments" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self makeFakeAssessments];
                self.isShowingMainBubblePopup = NO;
            }]];
        }
        
        //iphone only cancel button
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            self.isShowingMainBubblePopup = NO;
        }]];
        
        //popover location
        UIPopoverPresentationController *pop = [alert popoverPresentationController];
        pop.sourceRect = self.mainBubble.frame;
        pop.sourceView = self.view;
        [self presentViewController:alert animated:YES completion:nil];
    }
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
#pragma mark - ***************************    Other    ************************************
//*************************
//****************
//*********
//****
//*

- (void)noAssessmentsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Looks like you don't have any assessments yet. Click the Add button on the left to create some. You can then edit them from the Subjects menu." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Debug    ************************************
//*************************
//****************
//*********
//****
//*

- (void)makeFakeAssessments {
    //Make fakes only when no assessments
    if ([CurrentProfile getCurrentYear].assessmentCollection.assessments.count == 0) {
        NSArray *faketitles = @[@"mmmm", @"tttt", @"hhhh", @"zzzz", @"pppp", @"dddd"];
        
        for (NSString *title in faketitles) {
            int x = arc4random_uniform(5) + 3;
            
            for (int a = 0; a < x; a ++) {
                Assessment *a = [[Assessment alloc] initWithPropertiesOrNil:nil];
                a.subject = title;
                a.quickName = [NSString stringWithFormat:@"%i", arc4random_uniform(999999)];
                a.gradeSet.final = [self getRandomGradeText];
                a.gradeSet.preliminary = [self getRandomGradeText];
                a.gradeSet.expected = [self getRandomGradeText];
                
                [CurrentProfile addAssessmentOrReplaceACurrentOne:a];
            }
        }
        
        [self updateMainBubbleStats];
    }
}

- (NSString *)getRandomGradeText {
    NSArray *grades = @[GradeTextExcellence, GradeTextMerit, GradeTextAchieved, GradeTextNotAchieved, GradeTextNone];
    NSInteger a = arc4random_uniform((u_int32_t)grades.count);
    NSLog(@"Grade: %@", grades[a]);
    return grades[a];
}

- (void)logAssessmentGrades {
    NSArray *assess = [CurrentProfile getCurrentYear].assessmentCollection.assessments;
    NSMutableString *log = [[NSMutableString alloc] initWithString:@"\n\n\n//*\n//****\n//*********\n//****************\n//*************************\n//********************************************    Assessment Grades    \n//*************************\n//****************\n//*********\n//****\n//*\n\n\n"];
#define FC(string) (string.length > 0) ? [string substringToIndex:1] : @" "
    for (Assessment *a in assess) {
        [log appendString: [NSString stringWithFormat:@"- Sub '%@', Qn '%@' \t| FG '%@', PG '%@', EG '%@' \n", a.subject, a.quickName, FC(a.gradeSet.final), FC(a.gradeSet.preliminary), FC(a.gradeSet.expected)]];
    }
    
    NSLog(@"%@", log);
}


@end
