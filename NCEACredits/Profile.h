//
//  Profile.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YearCollection.h"
#import "CustomGoals.h"
#import "Grade.h"

@interface Profile : ToJSONTemplate
- (BOOL)hasAllNecessaryInformationFromSetup;
- (NSDictionary *)getSubjectsAndColoursOrNilForCurrentYear;
- (NSUInteger)getNumberOfAssessmentsInCurrentYear;
- (void)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment;
- (NSArray *)getAssessmentTitlesForSubject:(NSString *)subject;
- (BOOL)isAlreadyAssessmentForSubject:(NSString *)subject quickName:(NSString *)quickName andDifferentIdentifier:(NSUInteger)identifier;
- (Assessment *)getAssessmentForQuickName:(NSString *)qn andSubject:(NSString *)sub;
- (BOOL)assessmentExistsByIdentifier:(Assessment *)assess;
- (void)deleteAssessment:(Assessment *)assess;

@property NSString *profileName;
- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority;
- (NSDictionary *)getNumberOfCreditsForPriority:(GradePriorityType)priority andSubject:(NSString *)subject;
- (NSUInteger)getNumberOfCreditsForGradeIncludingBetterGrades:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level;

- (NSArray *)getAssessmentsForSubjectOrNilForAll:(NSString *)subjectOrNil gradeText:(NSString *)gradeText gradePriorityOrFinal:(GradePriorityType)gradePriorityOrFinal;

@property NSUInteger currentYear;
@property YearCollection *yearCollection;
- (Year *)getYearObjectForYearDate:(NSUInteger)date;
- (Year *)getCurrentYear;
- (NSUInteger)getYearDateCurrentlyInUseOtherwiseCurrentDateYear;
- (NSUInteger)getPrimaryNCEALevelForCurrentYear;
- (NSArray *)getYearsAsTableDatasForSetup;

@property NSString *selectedGoalTitle;

@property CustomGoals *customGoals;

- (NSData *)convertToJSONAsRoot;
- (void)logJSONText;

@end