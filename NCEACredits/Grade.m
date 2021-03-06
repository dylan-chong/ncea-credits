//
//  Grade.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Grade.h"

@implementation Grade

- (Grade *)createBlank {
    Grade *g = [[Grade alloc] init];
    g.final = GradeTextNone;
    g.expected = GradeTextNone;
    g.preliminary = GradeTextNone;
    
    if (CurrentAppSettings.lastEnteredFinalGrade.length > 0) g.final = CurrentAppSettings.lastEnteredFinalGrade;
    if (CurrentAppSettings.lastEnteredExpectGrade.length > 0) g.expected = CurrentAppSettings.lastEnteredExpectGrade;
    if (CurrentAppSettings.lastEnteredPrelimGrade.length > 0) g.preliminary = CurrentAppSettings.lastEnteredPrelimGrade;
    
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

- (NSString *)getGradeTextForFinalOrPriority:(GradePriorityType)type {
    NSString *possibleGrade = [self getGradeForPriority:GradePriorityFinalGrade];
    if (![possibleGrade isEqualToString:GradeTextNone]) {
        return possibleGrade;
    }
    
    possibleGrade = [self getGradeForPriority:type];
    if (![possibleGrade isEqualToString:GradeTextNone]) {
        return possibleGrade;
    }
    
    return GradeTextNone;
}

- (NSString *)getGradeForPriority:(GradePriorityType)p {
    switch (p) {
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
