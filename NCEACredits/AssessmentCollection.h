//
//  AssessmentCollection.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"
#import "Assessment.h"
#import "GradePriority.h"

@interface AssessmentCollection : ToJSONTemplate

@property NSMutableArray *assessments;

- (BOOL)addAssessmentOrReplaceACurrentOne:(Assessment *)assessment;
- (NSUInteger)getUnusedAssessmentIdentifier;
- (NSArray *)getSubjectsOrNil;

- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority andLevel:(NSUInteger)level;
- (NSUInteger)getNumberOfCreditsForGrade:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level;
- (NSUInteger)getNumberOfCreditsForGradeIncludingBetterGrades:(NSString *)gradeText priority:(GradePriorityType)priority andLevel:(NSUInteger)level;

- (BOOL)isAlreadyAssessmentForSubject:(NSString *)subject quickName:(NSString *)quickName andDifferentIdentifier:(NSUInteger)identifier;

+ (NSUInteger)getBonusAchievedCreditsForLevel:(NSUInteger)level;

- (NSArray *)getAssessmentTitlesForSubject:(NSString *)subject;
- (Assessment *)getAssessmentForQuickName:(NSString *)qn andSubject:(NSString *)sub;

- (BOOL)assessmentExists:(Assessment *)assess;
- (void)deleteAssessment:(Assessment *)assess;

@end
