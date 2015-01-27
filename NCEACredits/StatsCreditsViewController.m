//
//  StatsCreditsViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 31/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "StatsCreditsViewController.h"
#import "StatsViewController.h"
#import "StatsPopupNavViewController.h"

NSString *(^GradeTextForAbbreviatedGrade) (NSString *) = ^(NSString *abb) {
    if ([abb isEqualToString:@"E"]) return GradeTextExcellence;
    else if ([abb isEqualToString:@"M"]) return GradeTextMerit;
    else if ([abb isEqualToString:@"A"]) return GradeTextAchieved;
    else if ([abb isEqualToString:@"NA"]) return GradeTextNotAchieved;
    else return GradeTextNone;
};

@implementation StatsCreditsViewController

- (void)createBubbleContainersAndAddAsSubviews {
    NSDictionary *creds;
    NSString *exc, *mer, *ach, *not, *non, *ame, *em;
    
    GradePriorityType g = [StatsCreditsViewController getGradePriorityEnumFromString:CurrentAppDelegate.lastPressedGradePriority];
    NSString *subjectOrTotal = CurrentAppDelegate.lastPressedSubjectOrTotal;
    if ([subjectOrTotal isEqualToString:STATS_SUBJECTS_TOTAL]) {
        creds = [CurrentProfile getNumberOfAllCreditsForPriority:g];
    } else {
        //Subject specific
        NSString *sub = subjectOrTotal;
        creds = [CurrentProfile getNumberOfCreditsForPriority:g andSubject:sub];
    }
    
    NSInteger eCred = [[creds objectForKey:GradeTextExcellence] integerValue];
    NSInteger mCred = [[creds objectForKey:GradeTextMerit] integerValue];
    NSInteger aCred = [[creds objectForKey:GradeTextAchieved] integerValue];
    
    exc = [NSString stringWithFormat:@"E: %li", (long)eCred];
    mer = [NSString stringWithFormat:@"M: %li", (long)mCred];
    em = [NSString stringWithFormat:@"M+E: %li", (long)eCred + mCred];
    ach = [NSString stringWithFormat:@"A: %li", (long)aCred];
    ame = [NSString stringWithFormat:@"A+M+E: %li", (long)eCred + mCred + aCred];
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

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Tapped (show popup)    ************************************
//*************************
//****************
//*********
//****
//*

- (void)bubbleWasPressed:(BubbleContainer *)container {
    [super bubbleWasPressed:container];
    
    
    NSString *priorityText = CurrentAppDelegate.lastPressedGradePriority;
    GradePriorityType priority = [StatsCreditsViewController getGradePriorityEnumFromString:priorityText];
    NSString *subjectOrTotal = CurrentAppDelegate.lastPressedSubjectOrTotal;
    
    NSString *gradeAbbr = [container.bubble.title.text componentsSeparatedByString:@":"][0];//Get text before colon
    NSString *gradeText = GradeTextForAbbreviatedGrade(gradeAbbr);
    
    if (![gradeAbbr containsString:@"+"]) {//Ignore A+M+E and M+E
        if ([subjectOrTotal isEqualToString:STATS_SUBJECTS_TOTAL])
            subjectOrTotal = nil;
        
        NSArray *assessments = [CurrentProfile getAssessmentsForSubjectOrNilForAll:subjectOrTotal
                                                                         gradeText:gradeText
                                                              gradePriorityOrFinal:priority];
        
        if (assessments && assessments.count > 0) {
            //Assessments
            NSArray *subjectsArrayWithAssessmentsArrays = [StatsCreditsViewController sortArrayOfAssessmentsInToArrayOfSubjectsWhichAreArraysOfAssessments:assessments];
            [self showPopoupWithSubjectsArrayOfAssessmentsArrays:subjectsArrayWithAssessmentsArrays
                                              subjectOrNilForAll:subjectOrTotal
                                                       gradeText:gradeText
                                            priorityText:priorityText];
            
        } else {
            [self showNoAssessmentsPopup];
        }
    } else {
        [self showButtonsNotAllowedPopup];
    }
}

- (void)showButtonsNotAllowedPopup {
    //A+M+E not allowed
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Sorry, assessments cannot be displayed for the 'A+M+E' and 'M+E' buttons. Please tap the individual 'E', 'M', 'A', 'NA', or None buttons instead." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil]; 
}

- (void)showNoAssessmentsPopup {
    //No assessments
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"It appears you don't have any assessments for this grade." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showPopoupWithSubjectsArrayOfAssessmentsArrays:(NSArray *)subjectsArrayOfAssessmentsArrays subjectOrNilForAll:(NSString *)subjectOrNil gradeText:(NSString *)gradeText priorityText:(NSString *)priorityText {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StatsPopupStoryboard" bundle:nil];
    
    StatsPopupNavViewController *initialVC = [sb instantiateInitialViewController];
    initialVC.subjectsArrayOfAssessmentsArrays = subjectsArrayOfAssessmentsArrays;
    initialVC.subjectOrNilForTotal = subjectOrNil;
    initialVC.gradeText = gradeText;
    initialVC.priorityText = priorityText;
    
    initialVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:initialVC animated:YES completion:nil];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Sorting Assessments    ************************************
//*************************
//****************
//*********
//****
//*

+ (NSArray *)sortArrayOfAssessmentsInToArrayOfSubjectsWhichAreArraysOfAssessments:(NSArray *)assessments {
    //Get subject names
    NSMutableArray *subNames = [[NSMutableArray alloc] init];
    for (Assessment *assess in assessments) {
        if (![subNames containsObject:assess.subject]) {
            [subNames addObject:assess.subject];
        }
    }
    subNames = [[Styles sortArray:subNames] mutableCopy];
    
    //Put assessments into array
    NSArray *sortedAssessments = [Styles sortArray:assessments byPropertyKey:@"quickName" ascending:YES];
    NSMutableArray *subjectsArrayWithAssessmentsArrays = [[NSMutableArray alloc] init];
    for (NSString *subject in subNames) {
        
        //Make array of assessments with given subject
        NSMutableArray *assessmentsForSubject = [[NSMutableArray alloc] init];
        for (Assessment *assess2 in sortedAssessments) {
            if ([assess2.subject isEqualToString:subject]) {
                [assessmentsForSubject addObject:assess2];
            }
        }
        
        //Add assessments array to subject array
        [subjectsArrayWithAssessmentsArrays addObject:assessmentsForSubject];
    }
    return subjectsArrayWithAssessmentsArrays;
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
