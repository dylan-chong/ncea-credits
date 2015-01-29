//
//  Goal.h
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoalGradeReqAndLevel.h"

#define GOAL_ALERT_SHOWS_WITH_LARGE_CREDIT_ASSESSMENTS NO

@interface Goal : NSObject

- (id)initWithGradeText:(NSString *)gpg andTitle:(NSString *)title;
- (BOOL)addGoalGradeReqsForLevel:(GoalGradeReqAndLevel *)gg;
- (NSInteger)getCreditsLeftToCompleteWithCreditsForPrimaryGrade:(NSInteger)credits atLevel:(NSUInteger)level;
- (NSUInteger)getRequirementForLevel:(NSUInteger)level;

@property NSArray *availableGoalGradeReqs;
@property NSString *primaryGrade;
@property NSString *title;

@end
