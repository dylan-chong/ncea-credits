//
//  Profile.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YearCollection.h"
#import "GradePriority.h"
#import "Year.h"
#import "ToJSONTemplate.h"

@interface Profile : ToJSONTemplate

- (NSArray *)getSubjects;

@property NSString *profileName;
@property GradePriority *gradePriority;
@property NSUInteger *currentYear;
- (Year *)getYearObjectForYearDate:(NSUInteger)date;
@property YearCollection *yearCollection;

@property NSString *currentGoalTitle;

@end