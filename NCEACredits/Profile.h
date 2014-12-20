//
//  Profile.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradePriority.h"
#import "YearCollection.h"

@interface Profile : ToJSONTemplate
- (BOOL)hasAllNecessaryInformationFromSetup;
- (NSDictionary *)getSubjectsAndColoursOrNilForCurrentYear;
- (NSUInteger)getNumberOfAssessmentsInCurrentYear;
- (void)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment;

@property NSString *profileName;
@property GradePriority *gradePriority;
- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority;

@property NSUInteger currentYear;
@property YearCollection *yearCollection;
- (Year *)getYearObjectForYearDate:(NSUInteger)date;
- (Year *)getCurrentYear;
- (NSUInteger)getYearDateCurrentlyInUseOtherwiseCurrentDateYear;
- (NSUInteger)getPrimaryNCEALevelForCurrentYear;
- (NSArray *)getYearsAsTableDatasForSetup;

@property NSString *selectedGoalTitle;

- (NSData *)convertToJSONAsRoot;

- (void)logJSONText;

@end