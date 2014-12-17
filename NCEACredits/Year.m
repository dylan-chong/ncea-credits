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
    blank.assessmentCollection = [[AssessmentCollection alloc] initWithJSONOrNil:nil];
    return blank;
}

- (Year *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Year *year = [[Year alloc] init];
    year.yearDate = [[properties objectForKey:@"yearDate"] integerValue];
    year.primaryLevelNumber = [[properties objectForKey:@"primaryLevelNumber"] integerValue];
    year.assessmentCollection = [[AssessmentCollection alloc] initWithJSONOrNil:NSStringToNSData([properties objectForKey:@"assessmentCollection"])];
    year.identifier = [[properties objectForKey:@"identifier"] integerValue];
    
    return year;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[NSNumber numberWithInteger:_yearDate] forKey:@"yearDate"];
    [properties setObject:[NSNumber numberWithInteger:_primaryLevelNumber] forKey:@"primaryLevelNumber"];
    [properties setObject:NSDataToNSString([_assessmentCollection convertToJSON]) forKey:@"assessmentCollection"];
    [properties setObject:[NSNumber numberWithInteger:_identifier] forKey:@"identifier"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", error);
    return data;
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
