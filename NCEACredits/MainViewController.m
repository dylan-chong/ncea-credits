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
        [self showSetupWindow];
    }
    
#warning TODO: refresh data (e.g. goals)
}

- (void)setupWillBeDismissed {
    //Setup VC delegate method
    if (SHOULD_MAKE_FAKE_ASSESSMENTS) [self makeFakeAssessments];
    
    [self updateMainBubbleStats];
    
    self.shouldDelayCreationAnimation = NO;
    [self startChildBubbleCreationAnimation];
}

- (void)showSetupWindow {
    [SetupNavigationController showStoryboardFromViewController:self];
}

- (void)makeFakeAssessments {
    if (DEBUG_MODE_ON) {
        NSArray *faketitles = @[@"aaa", @"mmmm", @"tttt", @"hhhh", @"zzzz", @"pppp", @"dddd"];
        for (NSString *title in faketitles) {
            Assessment *a = [[Assessment alloc] initWithPropertiesOrNil:nil];
            a.subject = title;
            a.quickName = @"name";
            a.gradeSet.final = GradeTextMerit;
            
            [CurrentProfile addAssessmentOrReplaceACurrentOne:a];
        }
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //Reposition main bubble
    CGRect newPos = self.mainBubble.calulatePosition();
    self.mainBubble.frame = newPos;
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
                         [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:subjectsBlock colour:[Styles pinkColour] iconName:@"Subjects.png" title:@"Grades" frameBubbleForStartingPosition:self.mainBubble.frame andDelegate:NO],
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

- (void)addContainerPressed {
    AddViewController *b = [[AddViewController alloc] initWithMainBubble:_addContainer andAssessmentOrNil:nil];
    b.delegate = self;
    [self startTransitionToChildBubble:_addContainer andBubbleViewController:b];
}

- (void)gradesContainerPressed {
    if ([CurrentProfile getNumberOfAssessmentsInCurrentYear] > 0) {
        GradesViewController *b = [[GradesViewController alloc] initWithMainBubble:_gradesContainer andStaggered:YES];
        b.delegate = self;
        [self startTransitionToChildBubble:_gradesContainer andBubbleViewController:b];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Looks like you don't have any assessments yet. Click the Add button on the left to create some. You can then edit them from the Subjects menu." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)statsContainerPressed {
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Cool stats coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    //    [self presentViewController:alert animated:YES completion:nil];
    
    [CurrentProfile logJSONText];
}

- (void)optionsContainerPressed {
    
    [self showSetupWindow];
}


@end
