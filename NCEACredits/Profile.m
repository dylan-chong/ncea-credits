//
//  Profile.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Profile.h"
#import "TableViewCellData.h"

@implementation Profile

- (Profile *)createBlank {
    Profile *p = [[Profile alloc] init];
    p.gradePriority = [[GradePriority alloc] initWithPropertiesOrNil:nil];
    p.yearCollection = [[YearCollection alloc] initWithPropertiesOrNil:nil];
    return p;
}

- (Profile *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Profile *p = [[Profile alloc] init];
    p.profileName = [properties objectForKey:@"profileName"];
    p.currentYear = [[properties objectForKey:@"currentYear"] integerValue];
    p.selectedGoalTitle = [properties objectForKey:@"selectedGoalTitle"];
    p.gradePriority = [[GradePriority alloc] initWithPropertiesOrNil:[properties objectForKey:@"gradePriority"]];
    p.yearCollection = [[YearCollection alloc] initWithPropertiesOrNil:[properties objectForKey:@"yearCollection"]];
    return p;
}

- (NSData *)convertToJSONAsRoot {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_profileName forKey:@"profileName"];
    [properties setObject:[NSNumber numberWithInteger:_currentYear] forKey:@"currentYear"];
    [properties setObject:_selectedGoalTitle forKey:@"selectedGoalTitle"];
    [properties setObject:[_gradePriority convertToDictionaryOfProperties] forKey:@"gradePriority"];
    [properties setObject:[_yearCollection convertToDictionaryOfProperties] forKey:@"yearCollection"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", error);
    return data;
}

- (BOOL)hasAllNecessaryInformationFromSetup {
    if (_yearCollection) {
        if (_yearCollection.years.count < 1) return NO;
    } else return NO;
    
    return YES;
}

- (void)logJSONText {
    //Logs profile JSON
    if (DEBUG_MODE_ON && ApplicationDelegate.currentProfile) {
        Profile *p = CurrentProfile;
        NSString *m = [[NSString alloc] initWithData:[p convertToJSONAsRoot]  encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n//*\n//****\n//*********\n//****************\n//*************************\n********************************************    Profile JSON    \n//*************************\n//****************\n//*********\n//****\n//*\n\n\n");
        NSLog(@"%@", m);
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Subjects and Assessments    ************************************
//*************************
//****************
//*********
//****
//*

- (NSDictionary *)getSubjectsAndColoursOrNilForCurrentYear {
    if ([self getNumberOfAssessmentsInCurrentYear] > 0) {
        Year *currentYear = [self getCurrentYear];
        NSArray *subjects = [currentYear.assessmentCollection getSubjectsOrNil];
        return [currentYear.subjectsAndColours getAllSubjectsAndColoursForSubjects:subjects];
    } else {
        return nil;
    }
}

- (NSArray *)getSubjectsForCurrentYear {
    return [[self getCurrentYear].assessmentCollection getSubjectsOrNil];
}

- (NSUInteger)getNumberOfAssessmentsInCurrentYear {
    return [self getCurrentYear].assessmentCollection.assessments.count;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Year Stuff    ************************************
//*************************
//****************
//*********
//****
//


- (Year *)getCurrentYear {
    return [self getYearObjectForYearDate:_currentYear];
}

- (Year *)getYearObjectForYearDate:(NSUInteger)date {
    for (Year *year in _yearCollection.years) {
        if (year.yearDate == date)
            return year;
    }
    
    //Only if requested date does not exist
    NSException *e = [NSException exceptionWithName:@"InvalidYear" reason:@"Requested year date does not exist" userInfo:nil];
    [e raise];
    return nil;
}

- (NSArray *)getYearsAsTableDatasForSetup {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    Year *year;
    for (int a = 0; a < _yearCollection.years.count; a++) {
        year = _yearCollection.years[a];
        [dataArray addObject:[[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"NCEA Level %lu", (unsigned long)year.primaryLevelNumber]
                                                                  text:[NSString stringWithFormat:@"%lu", (unsigned long)year.yearDate]
                                                               reuseId:@"year"
                                                             accessory:UITableViewCellAccessoryNone
                                                                 style:UITableViewCellStyleValue1
                                                              selected:NO
                                                             optionalData:year.identifier
                              ]];
    }
    
    return dataArray;
}

- (NSUInteger)getYearDateCurrentlyInUseOtherwiseCurrentDateYear {
    if (_currentYear) return _currentYear;
    else return [Year getCurrentYearDate];
}

- (NSUInteger)getPrimaryNCEALevelForCurrentYear {
    Year *year = [self getYearObjectForYearDate:_currentYear];
    return year.primaryLevelNumber;
}

- (void)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment {
    [[self getCurrentYear].assessmentCollection addAssessmentOrReplaceACurrentOne:assessment];
    [ApplicationDelegate saveCurrentProfile];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Grade    ************************************
//*************************
//****************
//*********
//****
//*

- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority {
    return [[self getCurrentYear].assessmentCollection getNumberOfAllCreditsForPriority:priority andLevel:[self getPrimaryNCEALevelForCurrentYear]];
}

@end
