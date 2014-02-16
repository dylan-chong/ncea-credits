//
//  MainViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "MainViewController.h"
#import "GradesViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self createBubbleContainers];
    }
    return self;
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
    [NSTimer scheduledTimerWithTimeInterval:[Styles animationSpeed] / 2
                                     target:self.mainBubble
                                   selector:@selector(startGrowingMainBubbleAnimation)
                                   userInfo:nil
                                    repeats:NO];
    
    [self startChildBubbleCreationAnimation];
}

- (void)addControlEventsToBubbleContainers {
    [_addContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addContainerPressed)]];
    [_gradesContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gradesContainerPressed)]];
    [_statsContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statsContainerPressed)]];
    [_optionsContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionsContainerPressed)]];
}

//******************************************************* Container Press Events **************************************************************

- (void)addContainerPressed {
    BubbleViewController *b;
    [self startTransitionToChildBubble:_addContainer andBubbleViewController:b];
}

- (void)gradesContainerPressed {
    BubbleViewController *b = [[GradesViewController alloc] initWithMainBubble:_gradesContainer];
    b.delegate = self;
    [self startTransitionToChildBubble:_gradesContainer andBubbleViewController:b];
}

- (void)statsContainerPressed {
    
}

- (void)optionsContainerPressed {
    
}


@end
