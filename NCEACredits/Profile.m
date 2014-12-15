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
    
    for (Year *year in _yearCollection.years) {
        [dataArray addObject:[[TableViewCellData alloc] initWithDetail:[NSString stringWithFormat:@"NCEA Level %i", year.primaryLevelNumber]
                                                                  text:[NSString stringWithFormat:@"%i", year.yearDate]
                                                               reuseId:@"year"
                                                             accessory:UITableViewCellAccessoryNone
                                                                 style:UITableViewCellStyleValue1
                                                              selected:NO]];
    }
    
    return dataArray;
}

- (NSInteger)getYearCurrentlyInUseOtherwiseCurrentDateYear {
    if (_currentYear) return _currentYear;
    else return [Year getCurrentYearDate];
}

@end
