//
//  Year.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Year.h"

@implementation Year

- (Year *)createBlank {
    Year *blank = [[Year alloc] init];
    blank.assessmentCollection = [[AssessmentCollection alloc] initWithPropertiesOrNil:nil];
    return blank;
}

- (Year *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Year *year = [[Year alloc] init];
    year.yearDate = [[properties objectForKey:@"yearDate"] integerValue];
    year.primaryLevelNumber = [[properties objectForKey:@"primaryLevelNumber"] integerValue];
    year.assessmentCollection = [[AssessmentCollection alloc] initWithPropertiesOrNil:[properties objectForKey:@"assessmentCollection"]];
    year.identifier = [[properties objectForKey:@"identifier"] integerValue];
    
    return year;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[NSNumber numberWithInteger:_yearDate] forKey:@"yearDate"];
    [properties setObject:[NSNumber numberWithInteger:_primaryLevelNumber] forKey:@"primaryLevelNumber"];
    [properties setObject:[_assessmentCollection convertToDictionaryOfProperties] forKey:@"assessmentCollection"];
    [properties setObject:[NSNumber numberWithInteger:_identifier] forKey:@"identifier"];
    
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

+ (NSUInteger)getCurrentYearDate {
    NSDateComponents *comp = [[NSCalendar currentCalendar]
                              components: NSCalendarUnitYear
                              fromDate:[NSDate date]];
    return [comp year];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 4) {
        _primaryLevelNumber = 4;
    } else {
        _primaryLevelNumber = buttonIndex;
    }
}

@end
