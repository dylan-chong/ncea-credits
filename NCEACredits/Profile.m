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

+ (Profile *)createBlank {
    
}

- (void)loadFromJSON:(NSData *)json {
    
}

- (NSData *)convertToJSON {
    
    return nil;
}

-(BOOL)hasAllNecessaryInformation {
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
    if (_currentYear) return *(_currentYear);
    else return [Year getCurrentYearDate];
}

@end
