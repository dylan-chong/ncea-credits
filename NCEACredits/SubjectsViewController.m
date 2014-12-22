//
//  SubjectsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsViewController.h"
#import "AssessmentsForSubjectViewController.h"

@implementation SubjectsViewController

- (void)createBubbleContainers {
    NSDictionary *subjectTitles = [CurrentProfile getSubjectsAndColoursOrNilForCurrentYear];
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectsWithColoursOrNot:subjectTitles target:self staggered:self.staggered andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (void)bubbleWasPressed:(BubbleContainer *)container {
    AssessmentsForSubjectViewController *childVC = [[AssessmentsForSubjectViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
    [childVC createBubbleContainers];
    [self startTransitionToChildBubble:container andBubbleViewController:childVC];
}

@end
