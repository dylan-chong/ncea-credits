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

- (void)createBlank {
    
}

- (void)loadFromJSON:(NSData *)json {
    
}

- (NSData *)convertToJSON {
    
    return nil;
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
    return [[NSArray alloc] initWithObjects:@"Maths", @"Physics", @"Chemistry", @"I.T.", @"English", @"Music", @"Biology", @"Spanish", nil];
}

- (Year *)getYearObjectForYearDate:(NSUInteger)date {
    for (Year *year in _yearCollection.years) {
        if (year.yearDate == date)
            return year;
    }
    
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
