//
//  GradesViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradesViewController.h"
#import "AssessmentsForSubjectViewController.h"

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
        [childVC createBubbleContainers];
        [self startTransitionToChildBubble:container andBubbleViewController:childVC];
    }
}

@end