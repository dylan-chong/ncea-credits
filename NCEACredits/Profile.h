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
- (BOOL)hasAllNecessaryInformationFromSetup;
- (NSArray *)getSubjects;

@property NSString *profileName;
@property GradePriority *gradePriority;

@property NSUInteger currentYear;
- (Year *)getYearObjectForYearDate:(NSUInteger)date;
- (NSUInteger)getYearCurrentlyInUseOtherwiseCurrentDateYear;
- (NSUInteger)getPrimaryNCEALevelForCurrentYear;

@property YearCollection *yearCollection;
- (NSArray *)getYearsAsTableDatasForSetup;

@property NSString *selectedGoalTitle;

@end