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
- (NSDictionary *)getNumberOfAllCreditsForPriority:(GradePriorityType)priority;
- (NSUInteger)getNumberOfCreditsForGrade:(NSString *)gradeText andPriority:(GradePriorityType)priority;

@end
