//
//  Year.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Year.h"

@implementation Year

+ (Year *)createBlank {
    Year *blank = [[Year alloc] init];
    blank.assessmentCollection = [[AssessmentCollection alloc] initWithJSONOrNil:nil];
    return blank;
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
