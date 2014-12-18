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
- (NSArray *)getSubjects;
- (void)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment;

@property NSString *profileName;
@property GradePriority *gradePriority;

@property NSUInteger currentYear;
- (Year *)getYearObjectForYearDate:(NSUInteger)date;
- (Year *)getCurrentYear;
- (NSUInteger)getYearDateCurrentlyInUseOtherwiseCurrentDateYear;
- (NSUInteger)getPrimaryNCEALevelForCurrentYear;

@property YearCollection *yearCollection;
- (NSArray *)getYearsAsTableDatasForSetup;

@property NSString *selectedGoalTitle;

- (NSData *)convertToJSONAsRoot;

- (void)logJSONText;

@end