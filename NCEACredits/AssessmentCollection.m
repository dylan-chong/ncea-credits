//
//  AssessmentCollection.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AssessmentCollection.h"
#import "Grade.h"

@implementation AssessmentCollection

- (AssessmentCollection *)createBlank {
    AssessmentCollection *a = [[AssessmentCollection alloc] init];
    a.assessments = [[NSMutableArray alloc] init];
    return a;
}

- (AssessmentCollection *)loadFromJSONWithProperties:(NSDictionary *)properties {
    AssessmentCollection *a = [[AssessmentCollection alloc] init];
    a.assessments = [ToJSONTemplate convertBackArrayOfJSONObjects:[properties objectForKey:@"assessments"] toTemplateSubclass:NSStringFromClass([Assessment class])];
    return a;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[ToJSONTemplate convertArrayOfTemplateSubclassesToJSON:_assessments] forKey:@"assessments"];
    
    return properties;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Assessments    ************************************
//*************************
//****************
//*********
//****
//*

- (BOOL)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment {
    //If unit standard, grade can only be achieved
    if (assessment.isUnitStandard) {
        if (![assessment.gradeSet.final isEqualToString: GradeTextNotAchieved]) {
            assessment.gradeSet.final = GradeTextAchieved;
        }
        if (![assessment.gradeSet.preliminary isEqualToString: GradeTextNotAchieved]) {
            assessment.gradeSet.preliminary = GradeTextAchieved;
        }
        if (![assessment.gradeSet.expected isEqualToString: GradeTextNotAchieved]) {
            assessment.gradeSet.expected = GradeTextAchieved;
        }
    }
    
    //Check for duplicate name and subject
    if ([self isAlreadyAssessmentForSubject:assessment.subject quickName:assessment.quickName andDifferentIdentifier:assessment.identifier]) {
        NSLog(@"There is already an assessment with subject '%@' and quick name '%@'.", assessment.subject, assessment.quickName);
        return NO;
    }
    
    //Replace existing?
    for (int a = 0; a < _assessments.count; a++) {
        Assessment *existingAssessment = _assessments[a];
        if (existingAssessment.identifier == assessment.identifier) {
            _assessments[a] = assessment;
            return YES;
        }
    }
    
    [_assessments addObject:assessment];
    return YES;
}

- (BOOL)isAlreadyAssessmentForSubject:(NSString *)subject quickName:(NSString *)quickName andDifferentIdentifier:(NSUInteger)identifier {
    for (Assessment *a in _assessments) {
        if ([a.subject isEqualToString:subject] && [a.quickName isEqualToString:quickName] && identifier != a.identifier) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)getAssessmentTitlesForSubject:(NSString *)subject {
    NSMutableArray *assessmentsForSubject = [[NSMutableArray alloc] init];
    
    for (Assessment *assess in _assessments) {
        if ([assess.subject isEqualToString:subject])
            [assessmentsForSubject addObject:assess.quickName];
    }
    
    return assessmentsForSubject;
}

- (Assessment *)getAssessmentForQuickName:(NSString *)qn andSubject:(NSString *)sub {
    for (Assessment *possibleAssessment in _assessments) {
        if ([possibleAssessment.subject isEqualToString:sub] && [possibleAssessment.quickName isEqualToString:qn]) {
            //Match
            return possibleAssessment;
        }
    }
    
    //No match
    NSLog(@"There is no assessment for quick name '%@' and subject '%@'.", qn, sub);
    return nil;
}

- (BOOL)assessmentExistsByIdentifier:(Assessment *)assess {
    for (Assessment *a in _assessments) {
        if (a.identifier == assess.identifier) {
            return YES;
        }
    }
    
    return NO;
}

- (void)deleteAssessment:(Assessment *)assess {
    for (Assessment *a in _assessments) {
        if (a.identifier == assess.identifier) {
            [_assessments removeObject:a];
            NSLog(@"Assessment with quick name '%@', subject '%@', and identifier '%lu' was deleted.", assess.quickName, assess.subject, (unsigned long)assess.identifier);
            break;
        }
    }
}

//------------------------------ ID ------------------------------
- (NSUInteger)getUnusedAssessmentIdentifier {
    NSArray *usedIDs = [self getAllUsedAssessmentIdentifiers];
    NSUInteger largestID = 0;
    
    //Find an identifier larger than the largest being used
    for (NSNumber *n in usedIDs) {
        if ([n integerValue] > largestID)
            largestID = [n integerValue];
    }
    
    return largestID + 1;
}

- (NSArray *)getAllUsedAssessmentIdentifiers {
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    if (_assessments.count > 0) {
        for (int a = 0; a < _assessments.count; a++) {
            [used addObject:[NSNumber numberWithInteger:((Assessment *)_assessments[a]).identifier]];
        }
    }
    
    return used;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

- (NSArray *)getSubjectsOrNil {
    if (_assessments.count == 0)
        return nil;
    
    NSMutableArray *subjectTitles = [[NSMutableArray alloc] init];
    
    //Define quick search
    BOOL (^SubjectTitlesContainsSubject)(NSString *) = ^(NSString *subject) {
        for (NSString *inSubjectTitles in subjectTitles) {
            if ([inSubjectTitles isEqualToString:subject]) return YES;
        }
        return NO;
    };
    
    for (Assessment *a in _assessments) {
        if (!SubjectTitlesContainsSubject(a.subject))
            [subjectTitles addObject:a.subject];
    }
    
    return subjectTitles;
}

- (NSArray *)getAssessmentsForSubjectOrNilForAll:(NSString *)subjectOrNil gradeText:(NSString *)gradeText gradePriorityOrFinal:(GradePriorityType)gradePriorityOrFinal {
    NSMutableArray *assessments = [[NSMutableArray alloc] init];
    
    for (Assessment *a in _assessments) {
        NSString *grade = [a.gradeSet getGradeTextForFinalOrPriority:gradePriorityOrFinal];
        if ([grade isEqualToString:gradeText]) { //Grade must be same as assessment's final or chosen priority grade
            if (!subjectOrNil || [subjectOrNil isEqualToString:a.subject]) {
                [assessments addObject:a];
            }
        }
    }
    
    return assessments;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Credits    ************************************
//*************************
//****************
//*********
//****
//*

- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority andLevel:(NSUInteger)level {
    NSUInteger exc = [self getNumberOfCreditsForGrade:GradeTextExcellence priority:priority andLevel:level];
    NSUInteger mer = [self getNumberOfCreditsForGrade:GradeTextMerit priority:priority andLevel:level];
    NSUInteger ach = [self getNumberOfCreditsForGrade:GradeTextAchieved priority:priority andLevel:level];
    NSUInteger notach = [self getNumberOfCreditsForGrade:GradeTextNotAchieved priority:priority andLevel:level];
    NSUInteger non = [self getNumberOfCreditsForGrade:GradeTextNone priority:priority andLevel:level];
    
    NSMutableDictionary *creds = [[NSMutableDictionary alloc] initWithObjects:@[[NSNumber numberWithInteger:exc],
                                                                                [NSNumber numberWithInteger:mer],
                                                                                [NSNumber numberWithInteger:ach],
                                                                                [NSNumber numberWithInteger:notach],
                                                                                [NSNumber numberWithInteger:non]]
                                                                      forKeys:@[GradeTextExcellence,
                                                                                GradeTextMerit,
                                                                                GradeTextAchieved,
                                                                                GradeTextNotAchieved,
                                                                                GradeTextNone]];
    if (level == 1) {
        //Literacy and numeracy credits only apply to NCEA level 1
        NSUInteger lit = [self getNumberOfTypeOfCredits:TypeOfCreditsLiteracy priority:priority andLevel:level];
        NSUInteger num = [self getNumberOfTypeOfCredits:TypeOfCreditsNumeracy priority:priority andLevel:level];
        [creds setObject:[NSNumber numberWithInteger:lit] forKey:TypeOfCreditsLiteracy];
        [creds setObject:[NSNumber numberWithInteger:num] forKey:TypeOfCreditsNumeracy];
    }
    
    return creds;
}

- (NSUInteger)getNumberOfCreditsForGrade:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level {
    NSUInteger total = 0;
    
    //Bonus achieved credits in lvl 2/3
    if ([gradeText isEqualToString:GradeTextAchieved]) {
        total += [AssessmentCollection getBonusAchievedCreditsForLevel:level];
    }
    
    for (Assessment *assessment in _assessments) {
        NSString *finalGrade = [assessment.gradeSet getGradeTextForFinalOrPriority:priority];
        if ([finalGrade isEqualToString:gradeText])
            total += assessment.creditsWhenAchieved;
    }
    
    return total;
}

- (NSUInteger)getNumberOfTypeOfCredits:(NSString *)typeOfCredits priority:(GradePriorityType)priority andLevel:(NSUInteger)level {
    NSUInteger total = 0;
    
    if (level != 1) {
        //numeracy/literacy credits for only level 1
        NSLog(@"Numeracy and Literacy credits are only for Level 1.");
        return 0;
    }
    
    for (Assessment *assessment in _assessments) {
        if ([assessment.typeOfCredits isEqualToString: typeOfCredits]) {
            NSString *finalGrade = [assessment.gradeSet getGradeTextForFinalOrPriority:priority];
            if (![finalGrade isEqualToString:GradeTextNotAchieved] && ![finalGrade isEqualToString:GradeTextNone])
                total += assessment.creditsWhenAchieved;
        }
    }
    
    return total;
}

+ (NSUInteger)getBonusAchievedCreditsForLevel:(NSUInteger)level {
    switch (level) {
        case 1:
            return 0;
        case 2:
            return 0;
//            return 20;
        case 3:
            return 0;
//            return 20;
            
    }
    
    NSLog(@"NCEA Credits has no present bonus credits for Level %lu.", (unsigned long)level);
    return 0;
}

- (NSUInteger)getNumberOfCreditsForGradeIncludingBetterGrades:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level {
    NSUInteger total = 0;
    
    if ([gradeText isEqualToString:GradeTextNotAchieved] || [gradeText isEqualToString:GradeTextNone]) {
        NSLog(@"You can't get credits including better grades for Not Achieved or None");
        return 0;
    }
    
    total += [self getNumberOfCreditsForGrade:GradeTextExcellence priority:priority andLevel:level];
    if (![gradeText isEqualToString:GradeTextExcellence]) {
        total += [self getNumberOfCreditsForGrade:GradeTextMerit priority:priority andLevel:level];
        
        if (![gradeText isEqualToString:GradeTextMerit]) {
            total += [self getNumberOfCreditsForGrade:GradeTextAchieved priority:priority andLevel:level];
        }
    }
    
    return total;
}

//------------------------------ Credits per subject ------------------------------

- (NSDictionary *)getNumberCreditsForPriority:(GradePriorityType)priority subject:(NSString *)subject andLevel:(NSUInteger)level {
    NSUInteger exc = [self getNumberOfCreditsForGrade:GradeTextExcellence priority:priority subject:subject andLevel:level];
    NSUInteger mer = [self getNumberOfCreditsForGrade:GradeTextMerit priority:priority subject:subject andLevel:level];
    NSUInteger ach = [self getNumberOfCreditsForGrade:GradeTextAchieved priority:priority subject:subject andLevel:level];
    NSUInteger notach = [self getNumberOfCreditsForGrade:GradeTextNotAchieved priority:priority subject:subject andLevel:level];
    NSUInteger non = [self getNumberOfCreditsForGrade:GradeTextNone priority:priority subject:subject andLevel:level];
    
    NSMutableDictionary *creds = [[NSMutableDictionary alloc] initWithObjects:@[[NSNumber numberWithInteger:exc],
                                                                                [NSNumber numberWithInteger:mer],
                                                                                [NSNumber numberWithInteger:ach],
                                                                                [NSNumber numberWithInteger:notach],
                                                                                [NSNumber numberWithInteger:non]]
                                                                      forKeys:@[GradeTextExcellence,
                                                                                GradeTextMerit,
                                                                                GradeTextAchieved,
                                                                                GradeTextNotAchieved,
                                                                                GradeTextNone]];
    if (level == 1) {
        //Literacy and numeracy credits only apply to NCEA level 1
        NSUInteger lit = [self getNumberOfTypeOfCredits:TypeOfCreditsLiteracy priority:priority subject:subject andLevel:level];
        NSUInteger num = [self getNumberOfTypeOfCredits:TypeOfCreditsNumeracy priority:priority subject:subject andLevel:level];
        [creds setObject:[NSNumber numberWithInteger:lit] forKey:TypeOfCreditsLiteracy];
        [creds setObject:[NSNumber numberWithInteger:num] forKey:TypeOfCreditsNumeracy];
    }
    
    return creds;
}

- (NSUInteger)getNumberOfCreditsForGrade:(NSString *)gradeText priority:(GradePriorityType)priority subject:(NSString *)subject andLevel:(NSUInteger)level {
    NSUInteger total = 0;

    for (Assessment *assessment in _assessments) {
        NSString *finalGrade = [assessment.gradeSet getGradeTextForFinalOrPriority:priority];
        if ([finalGrade isEqualToString:gradeText] && [assessment.subject isEqualToString:subject])
            total += assessment.creditsWhenAchieved;
    }
    
    return total;
}

- (NSUInteger)getNumberOfTypeOfCredits:(NSString *)typeOfCredits priority:(GradePriorityType)priority subject:(NSString *)subject andLevel:(NSUInteger)level {
    NSUInteger total = 0;
    
    if (level != 1) {
        //numeracy/literacy credits for only level 1
        NSLog(@"Numeracy and Literacy credits are only for Level 1.");
        return 0;
    }
    
    for (Assessment *assessment in _assessments) {
        if ([assessment.typeOfCredits isEqualToString: typeOfCredits]) {
            NSString *finalGrade = [assessment.gradeSet getGradeTextForFinalOrPriority:priority];
            if (![finalGrade isEqualToString:GradeTextNotAchieved] && ![finalGrade isEqualToString:GradeTextNone])
                total += assessment.creditsWhenAchieved;
        }
    }
    
    return total;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Other    ************************************
//*************************
//****************
//*********
//****
//*

- (BOOL)collectionContainsLargeCreditAssessments {
    for (Assessment *a in _assessments) {
        if (a.creditsWhenAchieved > TOO_MANY_CREDITS_FOR_ASSESSMENT) {
            return YES;
        }
    }
    
    return NO;
}

@end
