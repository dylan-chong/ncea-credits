//
//  YearCollection.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "YearCollection.h"

@implementation YearCollection

- (YearCollection *)createBlank {
    YearCollection *yc = [[YearCollection alloc] init];
    yc.years = [[NSMutableArray alloc] init];
    return yc;
}

- (YearCollection *)loadFromJSONWithProperties:(NSDictionary *)properties {
    YearCollection *yc = [[YearCollection alloc] init];
    yc.years = [ToJSONTemplate convertBackArrayOfJSONObjects:[properties objectForKey:@"years"]
                                          toTemplateSubclass:NSStringFromClass([Year class])];
    return yc;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[ToJSONTemplate convertArrayOfTemplateSubclassesToJSON:_years] forKey:@"years"];
    
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

- (Year *)getMostUpToDateYear {
    Year *recent = CurrentProfile.yearCollection.years[0];
    for (Year *yearToCheck in CurrentProfile.yearCollection.years) {
        if (yearToCheck.yearDate > recent.yearDate)
            recent = yearToCheck;
    }
    
    return recent;
}

@end
