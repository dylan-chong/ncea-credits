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

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andStaggered:(BOOL)staggered {
    self = [super initWithMainBubble:mainBubble delegate:delegate andStaggered:staggered];
    
    if (self) {
        [self createCornerButtonWithTitle:@"Help me!" colourOrNilForMailBubbleColour:nil target:self selector:@selector(cornerButtonPressed:)];
    }
    
    return self;
}

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
    ApplicationDelegate.lastPressedGradePriority = container.bubble.title.text;
    
    StatsSubjectsViewController *stats = [[StatsSubjectsViewController alloc] initWithMainBubble:container delegate:self andStaggered:YES];
    [self startTransitionToChildBubble:container andBubbleViewController:stats];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Corner Button    ************************************
//*************************
//****************
//*********
//****
//*

- (void)cornerButtonPressed:(CornerButton *)sender {
    [self showHelpPopup];
}

- (void)hasTransitionedFromParentViewController {
    if (!CurrentAppSettings.hasOpenedStatsMenuBefore) {
        [self showHelpPopup];
        
        CurrentAppSettings.hasOpenedStatsMenuBefore = YES;
    }
    
    [super hasTransitionedFromParentViewController];
}

- (void)showHelpPopup {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Use the 'Expected' and 'Preliminary' grades if you have not received all of your 'Final' grades yet. You can use these to predict how many credits you will have after you have received all of your 'Final' grades.\n\nYou can set these grades for each assessment in the 'Add' or 'Edit' screens." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//------------------------------ Flash ------------------------------
//- (void)creationAnimationHasFinished {
//    [super creationAnimationHasFinished];
//    [self flashCornerButtonWithDelay];
//}
//
//- (void)flashCornerButtonWithDelay {
//    CGFloat delay = [Styles getDurationOfAnimationWithFlashTimes:FLASH_BUBBLE_VC_MAIN_BUBBLE_TIMES];
//    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(flashCornerButton) userInfo:nil repeats:NO];
//}
//
//- (void)flashCornerButton {
//    [Styles flashStartWithView:self.cornerButton numberOfTimes:FLASH_DEFAULT_TIMES sizeIncreaseMultiplierOr0ForDefault:2];
//}

@end
