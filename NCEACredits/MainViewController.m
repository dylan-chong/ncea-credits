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

@implementation MainViewController {
    BOOL hasForceShownSetup;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        hasForceShownSetup = NO;
        self.shouldDelayCreationAnimation = YES;
        [self createBubbleContainers];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Show setup window
    if (!hasForceShownSetup) {
        //Hasn't shown setup
        [SetupNavigationController showStoryboardFromViewController:self];
        hasForceShownSetup = YES;
    } else {
        self.shouldDelayCreationAnimation = NO;
        [self startChildBubbleCreationAnimation];
    }
    
#warning TODO: refresh data (e.g. goals)
}

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
    BubbleViewController *b = [[AddViewController alloc] initWithMainBubble:_addContainer andAssessmentOrNil:nil];
    b.delegate = self;
    [self startTransitionToChildBubble:_addContainer andBubbleViewController:b];
}

- (void)gradesContainerPressed {
    #warning TODO: make sure number of subjects is at least 1
    BubbleViewController *b = [[GradesViewController alloc] initWithMainBubble:_gradesContainer andStaggered:YES];
    b.delegate = self;
    [self startTransitionToChildBubble:_gradesContainer andBubbleViewController:b];
}

- (void)statsContainerPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Cool stats coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)optionsContainerPressed {
    [CurrentProfile logJSONText];
}


@end
