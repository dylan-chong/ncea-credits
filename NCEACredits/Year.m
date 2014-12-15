//
//  Year.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Year.h"

@implementation Year

- (void)createBlank {
    _assessmentCollection = [[AssessmentCollection alloc] initWithJSONOrNil:nil];
    _yearDate = [Year getCurrentYearDate];
    
//    UIAlertView *a = [[UIAlertView alloc] initWithTitle:AppName
//                                                message:@"Please enter in your NCEA level for this year."
//                                               delegate:self
//                                      cancelButtonTitle:@"4 (only for special cases)"
//                                      otherButtonTitles:@"1", @"2", @"3", nil];
//    [a show];
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

+ (unsigned long)getCurrentYearDate {
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
