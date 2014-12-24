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

- (void)createBubbleContainers {
    NSString *subject = [self getTitleOfMainBubble];
    
    NSArray *assessmentTitles = [CurrentProfile getAssessmentTitlesForSubject:subject];
    if (assessmentTitles.count == 0) {
        //Can't continue - no assessments
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"There are no assessments for this subject." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        NSMutableArray *nulls = [[NSMutableArray alloc] init];
        
        //Don't need individual colours for each bubble
        NSNull *n = [[NSNull alloc] init];
        for (int a = 0; a < assessmentTitles.count; a++) {
            [nulls addObject:n];
        }
        
        NSDictionary *assessmentTitlesDict = [NSDictionary dictionaryWithObjects:nulls forKeys:assessmentTitles];
        
        Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
        
        self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectsWithColoursOrNot:assessmentTitlesDict target:self staggered:self.staggered corner:c andMainBubble:self.mainBubble];
        
        for (BubbleContainer *b in self.childBubbles) {
            [self.view addSubview:b];
        }
    }
}

- (NSString *)getTitleOfMainBubble {
    return self.mainBubble.bubble.title.text;
}

- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    Assessment *assessment;
    EditAssessmentViewController *childVC = [[EditAssessmentViewController alloc] initWithMainBubble:container delegate:self  andAssessmentOrNil:assessment];
    [self startTransitionToChildBubble:container andBubbleViewController:childVC];
}

@end
