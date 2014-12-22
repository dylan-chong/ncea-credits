//
//  AssessmentsForSubjectViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AssessmentsForSubjectViewController.h"

@implementation AssessmentsForSubjectViewController

- (void)createBubbleContainers {
    NSString *subject = [self getTitleOfMainBubble];
    
    NSArray *assessmentTitles = [CurrentProfile getAssessmentTitlesForSubject:subject];
    NSMutableArray *nulls = [[NSMutableArray alloc] init];
    
    //Don't need individual colours for each bubble
    NSNull *n = [[NSNull alloc] init];
    for (int a = 0; a < assessmentTitles.count; a++) {
        [nulls addObject:n];
    }
    
    NSDictionary *assessmentTitlesDict = [NSDictionary dictionaryWithObjects:nulls forKeys:assessmentTitles];
    
    self.childBubbles = [SimpleSelectionViewController getArrayOfBubblesWithSubjectsWithColoursOrNot:assessmentTitlesDict target:self staggered:self.staggered andMainBubble:self.mainBubble];
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (NSString *)getTitleOfMainBubble {
    return self.mainBubble.bubble.title.text;
}

@end
