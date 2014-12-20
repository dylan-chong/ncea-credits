//
//  Grade.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Grade.h"
#import "GradePriority.h"

@implementation Grade

- (Grade *)createBlank {
    Grade *g = [[Grade alloc] init];
    g.final = GradeTextNone;
    g.expected = GradeTextNone;
    g.preliminary = GradeTextNone;
    return g;
}

- (Grade *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Grade *g = [[Grade alloc] init];
    g.final = [properties objectForKey:@"final"];
    g.expected = [properties objectForKey:@"expected"];
    g.preliminary = [properties objectForKey:@"preliminary"];
    return g;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_final forKey:@"final"];
    [properties setObject:_expected forKey:@"expected"];
    [properties setObject:_preliminary forKey:@"preliminary"];
    
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

- (NSString *)getHighestPriorityExistingGradeText {
    NSArray *priorities = CurrentProfile.gradePriority.priorityOrder;
    
    for (NSNumber *p in priorities) {
        GradePriorityType priority = [p integerValue];
        NSString *grade = [self getGradeTextForGradeType:priority];
        
        if (![grade isEqualToString:GradeTextNone]) {
            return grade;
        }
    }
    //All grades are GradeTextNone
    return GradeTextNone;
}

- (NSString *)getGradeTextForGradeType:(GradePriorityType)type {
    switch (type) {
        case GradePriorityExpectedGrade:
            return _expected;
            break;
            
        case GradePriorityFinalGrade:
            return _final;
            break;
            
        case GradePriorityPreliminaryGrade:
            return _preliminary;
            break;
            
        default:
            return GradeTextNone;
    }
}

@end
