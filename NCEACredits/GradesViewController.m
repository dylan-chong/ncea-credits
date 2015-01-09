//
//  GradesViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradesViewController.h"
#import "AssessmentsForSubjectViewController.h"

#define SET_COLOUR_TITLE @"Change Colours"
#define SET_COLOUR_COLOUR [Styles pinkColour]

@implementation GradesViewController

- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    
    //Can't continue - no assessments
    if ([CurrentProfile getAssessmentTitlesForSubject:container.bubble.title.text].count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"There don't appear to be any assessments for this subject. Try returning back to the main screen, then trying again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        AssessmentsForSubjectViewController *childVC = [[AssessmentsForSubjectViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
        [childVC createBubbleContainersAndAddAsSubviews];
        [self startTransitionToChildBubble:container andBubbleViewController:childVC];
    }
}

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andStaggered:(BOOL)staggered {
    self = [super initWithMainBubble:mainBubble delegate:delegate andStaggered:staggered];
    
    if (self) {
        //Create set colour button
        Corner c = [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:self.mainBubble.center]];
        _setColourButton = [CornerButton cornerButtonWithTitle:SET_COLOUR_TITLE width:170 corner:c colour:SET_COLOUR_COLOUR target:self selector:@selector(setColourBubblePressed)];
        [self.view addSubview:_setColourButton];
    }
    
    return self;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Set Colour    ************************************
//*************************
//****************
//*********
//****
//*

- (void)setColourBubblePressed {
    //Show popup
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChangeColourStoryboard" bundle:nil];
    ChangeColourNavViewController *viewController = [storyboard instantiateInitialViewController];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    viewController.delegateForWillCloseMethod = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)changeColourNavVCWillClose {
    NSDictionary *subAndCol = [CurrentProfile getCurrentYear].subjectsAndColours.subjectsAndColours;
    
    for (BubbleContainer *b in self.childBubbles) {
        UIColor *c = [subAndCol objectForKey:b.bubble.title.text];
        b.bubble.colour = c;
        b.colour = c;
        [b.bubble setNeedsDisplay];
    }
}

@end