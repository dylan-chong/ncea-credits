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
    p.gradePriority = [[GradePriority alloc] initWithJSONOrNil:nil];
    p.yearCollection = [[YearCollection alloc] initWithJSONOrNil:nil];
    return p;
}

- (Profile *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Profile *p = [[Profile alloc] init];
    p.profileName = [properties objectForKey:@"profileName"];
    p.currentYear = [[properties objectForKey:@"currentYear"] integerValue];
    p.selectedGoalTitle = [properties objectForKey:@"selectedGoalTitle"];
    p.gradePriority = [[GradePriority alloc] initWithJSONOrNil:NSStringToNSData([properties objectForKey:@"gradePriority"])];
    p.yearCollection = [[YearCollection alloc] initWithJSONOrNil:NSStringToNSData([properties objectForKey:@"yearCollection"])];
    return p;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_profileName forKey:@"profileName"];
    [properties setObject:[NSNumber numberWithInteger:_currentYear] forKey:@"currentYear"];
    [properties setObject:_selectedGoalTitle forKey:@"selectedGoalTitle"];
    [properties setObject:NSDataToNSString([_gradePriority convertToJSON]) forKey:@"gradePriority"];
    [properties setObject:NSDataToNSString([_yearCollection convertToJSON]) forKey:@"yearCollection"];
    
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

- (NSArray *)getSubjects {
    #warning TODO: actually get subjets for year
    return [[NSArray alloc] initWithObjects:@"Maths", @"Physics", @"Chemistry", @"I.T.", @"English", @"Music", @"Biology", @"Spanish", nil];
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
//*

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

- (NSUInteger)getYearCurrentlyInUseOtherwiseCurrentDateYear {
    if (_currentYear) return _currentYear;
    else return [Year getCurrentYearDate];
}

- (NSUInteger)getPrimaryNCEALevelForCurrentYear {
    Year *year = [self getYearObjectForYearDate:_currentYear];
    return year.primaryLevelNumber;
}

@end
