//
//  StatsCreditsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 31/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "StatsCreditsViewController.h"
#import "StatsViewController.h"
#import "StatsSubjectsViewController.h"

NSString *(^GradeTextForAbbreviatedGrade) (NSString *) = ^(NSString *abb) {
    if ([abb isEqualToString:@"E"]) return GradeTextExcellence;
    else if ([abb isEqualToString:@"M"]) return GradeTextMerit;
    else if ([abb isEqualToString:@"A"]) return GradeTextAchieved;
    else if ([abb isEqualToString:@"NA"]) return GradeTextNotAchieved;
    else return GradeTextNone;
};

@interface StatsCreditsViewController ()

@end

@implementation StatsCreditsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSDictionary *creds;
    NSString *exc, *mer, *ach, *not, *non, *ame, *em;
    
    GradePriorityType g = [StatsCreditsViewController getGradePriorityEnumFromString:[self.delegate getTitleOfMainBubble]];
    if ([self.mainBubble.bubble.title.text isEqualToString:STATS_SUBJECTS_TOTAL]) {
        creds = [CurrentProfile getNumberOfAllCreditsForPriority:g];
    } else {
        //Subject specific
        NSString *sub = self.mainBubble.bubble.title.text;
        creds = [CurrentProfile getNumberOfCreditsForPriority:g andSubject:sub];
    }
    
    NSInteger eCred = [[creds objectForKey:GradeTextExcellence] integerValue];
    NSInteger mCred = [[creds objectForKey:GradeTextMerit] integerValue];
    NSInteger aCred = [[creds objectForKey:GradeTextAchieved] integerValue];
    
    exc = [NSString stringWithFormat:@"E: %li", (long)eCred];
    mer = [NSString stringWithFormat:@"M: %li", (long)mCred];
    em = [NSString stringWithFormat:@"M+E: %li", eCred + mCred];
    ach = [NSString stringWithFormat:@"A: %li", (long)aCred];
    ame = [NSString stringWithFormat:@"A+M+E: %li", eCred + mCred + aCred];
    not = [NSString stringWithFormat:@"NA: %li", (long)[[creds objectForKey:GradeTextNotAchieved] integerValue]];
    non = [NSString stringWithFormat:@"None: %li", (long)[[creds objectForKey:GradeTextNone] integerValue]];
    
    NSArray *titles = @[exc, mer, em, ach, ame, not, non];
    
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
    
    #warning TODO: list all assessments that fit criteria
    GradePriorityType priority = [StatsCreditsViewController getGradePriorityEnumFromString:[self.delegate getTitleOfMainBubble]];
    NSString *subjectOrTotal = self.mainBubble.bubble.title.text;
    if ([subjectOrTotal isEqualToString:STATS_SUBJECTS_TOTAL]) subjectOrTotal = nil;
    NSString *grade = [container.bubble.title.text componentsSeparatedByString:@":"][0];//Get text before colon
    
    if (![grade containsString:@"+"]) {//Ignore A+M+E and M+E
        NSArray *assessments = [CurrentProfile getAssessmentsForSubjectOrNilForAll:subjectOrTotal gradeText:GradeTextForAbbreviatedGrade(grade) gradePriorityOrFinal:priority];
        
        
    }
}


//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Priority    ************************************
//*************************
//****************
//*********
//****
//*

+ (GradePriorityType)getGradePriorityEnumFromString:(NSString *)p {
    if ([p isEqualToString:STATS_BUBBLE_LEVEL_EXPECTED]) {
        return GradePriorityExpectedGrade;
    } else if ([p isEqualToString:STATS_BUBBLE_LEVEL_FINAL_ONLY]) {
        return GradePriorityFinalGrade;
    } else if ([p isEqualToString:STATS_BUBBLE_LEVEL_PRELIMINARY]) {
        return GradePriorityPreliminaryGrade;
    }
    
    return 0;
}

@end
