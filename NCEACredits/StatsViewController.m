//
//  StatsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 29/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "StatsViewController.h"
#import "StatsSubjectsViewController.h"

@implementation StatsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSArray *titles = @[STATS_BUBBLE_LEVEL_PRELIMINARY, STATS_BUBBLE_LEVEL_EXPECTED, STATS_BUBBLE_LEVEL_FINAL_ONLY];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for (NSString *t in titles) {
        [pairs addObject:[SubjectColourPair pairWithSubject:t andColour:nil]]; //nil colour - defaults to main bubble colour
    }
    
    Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectColourPairs:pairs target:self staggered:self.staggered corner:c andMainBubble:self.mainBubble];
    
    for (BubbleContainer *container in self.childBubbles) {
        [self.view addSubview:container];
    }
}


- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    
    StatsSubjectsViewController *stats = [[StatsSubjectsViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
    [self startTransitionToChildBubble:container andBubbleViewController:stats];
}

- (void)hasTransitionedFromParentViewController {
    if (!CurrentAppSettings.hasOpenedStatsMenuBefore) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"This section allows you predict the amount of credits you will have. \n- The 'Expected' section is similar, only it uses your expected grades instead.\n- The 'Preliminary' section calculates how many credits you would have according to the preliminary grades you set for each assessment. \n- For both of these, the final grades take precedence over the other two types. The 'Final Only' section does not account for preliminary or expected grades." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        CurrentAppSettings.hasOpenedStatsMenuBefore = YES;
    }
    
    [super hasTransitionedFromParentViewController];
}

@end
