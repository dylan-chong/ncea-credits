//
//  AssessmentsForSubjectViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AssessmentsForSubjectViewController.h"
#import "EditAssessmentViewController.h"

@implementation AssessmentsForSubjectViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSString *subject = [self getTitleOfMainBubble];
    
    NSArray *assessmentTitles = [CurrentProfile getAssessmentTitlesForSubject:subject];
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for (NSString *t in assessmentTitles) {
        [pairs addObject:[SubjectColourPair pairWithSubject:t andColour:nil]]; //nil colour - defaults to main bubble colour
    }
    
    pairs = [[SubjectColourPair sortArrayOfSubjectColourPairs:pairs] mutableCopy];
    
    Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectColourPairs:pairs target:self staggered:self.staggered corner:c andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (NSString *)getTitleOfMainBubble {
    return self.mainBubble.bubble.title.text;
}

- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    Assessment *assessment = [CurrentProfile getAssessmentForQuickName:container.bubble.title.text andSubject:self.mainBubble.bubble.title.text];
    
    if (!assessment) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"This assessment doesn't seem to exist. Try returning back to the main screen, then trying again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        EditAssessmentViewController *childVC = [[EditAssessmentViewController alloc] initWithMainBubble:container delegate:self andAssessmentOrNil:assessment];
        [self startTransitionToChildBubble:container andBubbleViewController:childVC];
    }
}

@end
