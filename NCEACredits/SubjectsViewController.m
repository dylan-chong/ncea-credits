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
    
    Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectsWithColoursOrNot:subjectTitles target:self staggered:self.staggered corner:c andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

//Uncomment to show assessment list on tap
//- (void)bubbleWasPressed:(BubbleContainer *)container {
//    [super bubbleWasPressed:container];
//    AssessmentsForSubjectViewController *childVC = [[AssessmentsForSubjectViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
//    [childVC createBubbleContainers];
//    [self startTransitionToChildBubble:container andBubbleViewController:childVC];
//}

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController {
    if (bubbleViewController.childBubbles) [super startTransitionToChildBubble:b andBubbleViewController:bubbleViewController];
}

@end
