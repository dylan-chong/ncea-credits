//
//  Goal.h
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoalGradeReqAndLevel.h"

@interface Goal : NSObject

- (id)initWithGradeText:(NSString *)gpg;
- (BOOL)addGoalGradeReqsForLevel:(GoalGradeReqAndLevel *)gg;
- (NSInteger)getCreditsLeftToCompleteWithAllCredits:(NSDictionary *)allCredits atLevel:(NSUInteger)level;
- (NSUInteger)getRequirementForLevel:(NSUInteger)level;

@property NSArray *availableGoalGradeReqs;
@property NSString *primaryGrade;

@end
