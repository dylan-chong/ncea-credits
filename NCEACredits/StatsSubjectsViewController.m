//
//  StatsSubjectsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 29/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "StatsSubjectsViewController.h"
#import "StatsViewController.h"
#import "StatsCreditsViewController.h"

@implementation StatsSubjectsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSDictionary *subCol = [CurrentProfile getSubjectsAndColoursOrNilForCurrentYear];
    NSArray *titles = [subCol allKeys];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for (NSString *t in titles) {
        [pairs addObject:[SubjectColourPair pairWithSubject:t andColour:[subCol objectForKey:t]]]; //nil colour - defaults to main bubble colour
    }
    
    pairs = [[SubjectColourPair sortArrayOfSubjectColourPairs:pairs] mutableCopy];
    [pairs insertObject:[SubjectColourPair pairWithSubject:STATS_SUBJECTS_TOTAL andColour:nil] atIndex:0];
    
    Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectColourPairs:pairs target:self staggered:self.staggered corner:c andMainBubble:self.mainBubble];
    
    for (BubbleContainer *container in self.childBubbles) {
        [self.view addSubview:container];
    }
}

- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];

    CurrentAppDelegate.lastPressedSubjectOrTotal = container.bubble.title.text;
    
    StatsCreditsViewController *stats = [[StatsCreditsViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
    [self startTransitionToChildBubble:container andBubbleViewController:stats];
}

@end
