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
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

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
    
    if (_assessments.count > 1) {
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

@end
