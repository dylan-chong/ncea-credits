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
        CurrentAppSettings.setupState = SETUP_STATE_NEW_PROFILE_INITIAL;
        [self showSetupWindow];
    } else {
        [self startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup];
    }
    
}

- (void)hasReturnedFromChildViewController {
    [super hasReturnedFromChildViewController];
    [self updateMainBubbleStats];
}

- (void)startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup {
    if (MAKE_FAKE_ASSESSMENTS && DEBUG_MODE_ON) [self makeFakeAssessments];
    
    [self updateMainBubbleStats];
    
    self.shouldDelayCreationAnimation = NO;
    [self startChildBubbleCreationAnimation];
}

- (void)setupWillBeDismissed {
    //Setup VC delegate method
    [self startCreationAnimationsWhichMayHaveBeenDelayedDueToPossibleRequirementOfSetup];
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
#pragma mark - ***************************************************************
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
    self.mainBubble.delegate = self;
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
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:subjectsBlock colour:[Styles pinkColour] iconName:@"Subjects.png" title:@"Edit" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
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
#pragma mark - ***************************    Container Press Events    ************************************
//*************************
//****************
//*********
//****
//*

- (void)mainBubbleTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Credits:\nThis counts the number of credits of assessments with final grades. (For NCEA Levels 2 and 3, you start with an extra 20 credits.) You can tap the blue 'Stats' tab to view more information like predictions about the number of credits you expect to have (make sure to set an 'Expected Grade' in the 'Add' screen).\n\nGoals:\nThis shows the number of credits required to reach the required goal (e.g. Excellence Endorsement). You can change this in the setup screen by tapping the orange 'Options' tab, then 'Show Setup'. Note that in NCEA Level 1, 10 literacy and 10 numeracy credits are also required (see the 'Stats' tab to see the number of these credits)." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    //Log
    [CurrentProfile logJSONText];
    [CurrentAppSettings logJSONText];
    [self logAssessmentGrades];
}

- (void)addContainerPressed {
    [self bubbleWasPressed:_addContainer];
    
    AddViewController *b = [[AddViewController alloc] initWithMainBubble:_addContainer delegate:self andAssessmentOrNil:nil];
    [self startTransitionToChildBubble:_addContainer andBubbleViewController:b];
}

- (void)gradesContainerPressed {
    [self bubbleWasPressed:_gradesContainer];
    
    if ([CurrentProfile getNumberOfAssessmentsInCurrentYear] > 0) {
        GradesViewController *b = [[GradesViewController alloc] initWithMainBubble:_gradesContainer delegate:self andStaggered:YES];
        [self startTransitionToChildBubble:_gradesContainer andBubbleViewController:b];
    } else {
        [self noAssessmentsAlert];
    }
}

- (void)statsContainerPressed {
    [self bubbleWasPressed:_statsContainer];
    
    if ([CurrentProfile getNumberOfAssessmentsInCurrentYear] > 0) {
        StatsViewController *b = [[StatsViewController alloc] initWithMainBubble:_statsContainer delegate:self andStaggered:YES];
        [self startTransitionToChildBubble:_statsContainer andBubbleViewController:b];
    } else {
        [self noAssessmentsAlert];
    }
}

- (void)optionsContainerPressed {
    [self bubbleWasPressed:_optionsContainer];
    
    OptionsViewController *opt = [[OptionsViewController alloc] initWithMainBubble:_optionsContainer delegate:self andStaggered:YES];
    [self startTransitionToChildBubble:_optionsContainer andBubbleViewController:opt];
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
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
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
