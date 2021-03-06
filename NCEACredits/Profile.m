//
//  Profile.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Profile.h"
#import "TableViewCellData.h"
#import "GoalMain.h"

@implementation Profile

- (Profile *)createBlank {
    Profile *p = [[Profile alloc] init];
    p.yearCollection = [[YearCollection alloc] initWithPropertiesOrNil:nil];
    p.customGoals = [[CustomGoals alloc] initWithPropertiesOrNil:nil];
    p.appOpenTimes = 0;
    p.hasCompletedGoal = NO;
    return p;
}

- (Profile *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Profile *p = [[Profile alloc] init];
    p.profileName = [properties objectForKey:@"profileName"];
    p.currentYear = [[properties objectForKey:@"currentYear"] integerValue];
    [p setSelectedGoalTitleWithoutUsingNormalSetterMethod:[properties objectForKey:@"selectedGoalTitle"]];
    p.yearCollection = [[YearCollection alloc] initWithPropertiesOrNil:[properties objectForKey:@"yearCollection"]];
    p.customGoals = [[CustomGoals alloc] initWithPropertiesOrNil:[properties objectForKey:@"customGoals"]];
    
    NSNumber *appOpens = [properties objectForKey:@"appOpenTimes"];
    if (appOpens) p.appOpenTimes = [appOpens integerValue];
    else p.appOpenTimes = 0;
    
    NSNumber *hasCompletedGoal = properties[@"hasCompletedGoal"];
    if (hasCompletedGoal) p.hasCompletedGoal = [hasCompletedGoal boolValue];
    else p.hasCompletedGoal = NO;
    
    return p;
}

- (NSData *)convertToJSONAsRoot {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_profileName forKey:@"profileName"];
    [properties setObject:[NSNumber numberWithInteger:_currentYear] forKey:@"currentYear"];
    [properties setObject:_selectedGoalTitle forKey:@"selectedGoalTitle"];
    [properties setObject:[_yearCollection convertToDictionaryOfProperties] forKey:@"yearCollection"];
    [properties setObject:[_customGoals convertToDictionaryOfProperties] forKey:@"customGoals"];
    [properties setObject:[NSNumber numberWithInteger:_appOpenTimes] forKey:@"appOpenTimes"];
    properties[@"hasCompletedGoal"] = [NSNumber numberWithBool:_hasCompletedGoal];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", [error localizedDescription]);
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
    if (CurrentAppDelegate.currentProfile) {
        Profile *p = CurrentProfile;
        NSString *m = [[NSString alloc] initWithData:[p convertToJSONAsRoot]  encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n//*\n//****\n//*********\n//****************\n//*************************\n********************************************    Profile JSON    \n//*************************\n//****************\n//*********\n//****\n//*\n\n\n");
        NSLog(@"%@", m);
        
        //Log files
        NSArray *fileNames = [CurrentAppDelegate getUsedProfileNames];
        NSMutableString *files = [[NSMutableString alloc] initWithString:@"\n\n\n//Existing Profiles:"];
        
        for (NSString *name in fileNames) {
            [files appendString:@"\n - "];
            [files appendString:name];
        }
        
        NSLog(@"%@", files);
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

- (BOOL)isAlreadyAssessmentForSubject:(NSString *)subject quickName:(NSString *)quickName andDifferentIdentifier:(NSUInteger)identifier {
    return [[self getCurrentYear].assessmentCollection isAlreadyAssessmentForSubject:subject quickName:quickName andDifferentIdentifier:identifier];
}

- (Assessment *)getAssessmentForQuickName:(NSString *)qn andSubject:(NSString *)sub {
    return [[self getCurrentYear].assessmentCollection getAssessmentForQuickName:qn andSubject:sub];
}

- (BOOL)assessmentExistsByIdentifier:(Assessment *)assess {
    return [[self getCurrentYear].assessmentCollection assessmentExistsByIdentifier:assess];
}

- (void)deleteAssessment:(Assessment *)assess {
    [[self getCurrentYear].assessmentCollection deleteAssessment:assess];
    [CurrentAppDelegate saveCurrentProfileAndAppSettings];
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
    
    dataArray = [[Styles sortArray:dataArray byPropertyKey:@"text" ascending:NO] mutableCopy];
    
    return dataArray;
}

- (NSUInteger)getPrimaryNCEALevelForCurrentYear {
    Year *year = [self getYearObjectForYearDate:_currentYear];
    return year.primaryLevelNumber;
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

- (void)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment {
    [[self getCurrentYear].assessmentCollection addAssessmentOrReplaceACurrentOne:assessment];
    [CurrentAppDelegate saveCurrentProfileAndAppSettings];
}

- (NSArray *)getAssessmentTitlesForSubject:(NSString *)subject {
    return [[self getCurrentYear].assessmentCollection getAssessmentTitlesForSubject:subject];
}

- (NSArray *)getAssessmentsForSubjectOrNilForAll:(NSString *)subjectOrNil gradeText:(NSString *)gradeText gradePriorityOrFinal:(GradePriorityType)gradePriorityOrFinal {
    return [[self getCurrentYear].assessmentCollection getAssessmentsForSubjectOrNilForAll:subjectOrNil gradeText:gradeText gradePriorityOrFinal:gradePriorityOrFinal];
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

- (NSUInteger)getNumberOfCreditsForGradeIncludingBetterGrades:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level {
    return [[self getCurrentYear].assessmentCollection getNumberOfCreditsForGradeIncludingBetterGrades:gradeText priority:priority andLevel:level];
}

- (NSDictionary *)getNumberOfCreditsForPriority:(GradePriorityType)priority andSubject:(NSString *)subject {
    return [[self getCurrentYear].assessmentCollection getNumberCreditsForPriority:priority subject:subject andLevel:[self getPrimaryNCEALevelForCurrentYear]];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Goal    ************************************
//*************************
//****************
//*********
//****
//*

- (void)setSelectedGoalTitle:(NSString *)selectedGoalTitle {
    if (![_selectedGoalTitle isEqualToString:selectedGoalTitle] && _selectedGoalTitle) {
        //goal has changed
        _selectedGoalTitle = selectedGoalTitle;
        
        if ([self goalIsComplete]) {
            //new goal already complete
            self.hasCompletedGoal = YES;
        } else {
            self.hasCompletedGoal = NO;
        }
    } else {
        _selectedGoalTitle = selectedGoalTitle;
    }
}

- (void)setSelectedGoalTitleWithoutUsingNormalSetterMethod:(NSString *)selectedGoalTitle {
    _selectedGoalTitle = selectedGoalTitle;
}

- (BOOL)goalIsComplete {
    if (!(DEBUG_MODE_ON && ALLOW_LARGE_CREDIT_CHEATING))
        if ([self collectionContainsLargeCreditAssessments]) return NO; //no cheating allowed!
    
    NSString *grade = [GoalMain getAnyTypeOfGoalForTitle:self.selectedGoalTitle].primaryGrade;
    NSInteger creds = [self getNumberOfCreditsForGradeIncludingBetterGrades:grade priority:GradePriorityFinalGrade andLevel:[self getCurrentYear].primaryLevelNumber];
    Goal *goal = [GoalMain getAnyTypeOfGoalForTitle:self.selectedGoalTitle];
    NSInteger creditsToGo = [goal getCreditsLeftToCompleteWithCreditsForPrimaryGrade:creds atLevel:[self getCurrentYear].primaryLevelNumber];
    if (creditsToGo > 0) return NO;
    else return YES;
}

- (BOOL)collectionContainsLargeCreditAssessments {
    return [[self getCurrentYear].assessmentCollection collectionContainsLargeCreditAssessments];
}

@end
