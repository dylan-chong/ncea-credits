//
//  DefaultGoals.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "DefaultGoals.h"

#define GoalGradeReq(numberOfCredits, nceaLevel) [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:numberOfCredits NCEALevel:nceaLevel]];

@implementation DefaultGoals

+ (Goal *)getGoalForTitle:(NSString *)goalTitle {
    NSArray *defaultGoals = [self getAllDefaultGoals];
    
    for (Goal *goal in defaultGoals) {
        if ([goal.title isEqualToString:goalTitle]) {
            return goal;
        }
    }
    
    return nil;
}

+ (NSArray *)getAllDefaultGoals {
    static NSArray *goals;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        goals = @[
                  ^{
                      //level 1 always aims to get lit/num credits (set by default in init method)
                      Goal *newGoal = [[Goal alloc] initWithGradeText:GradeTextAchieved andTitle:GoalAchievement];
                      NSInteger achReq = 80;
                      GoalGradeReq(achReq, 1);
                      GoalGradeReq(60, 2);
                      GoalGradeReq(60, 3);
                      return newGoal;
                  }(),^{
                      Goal *newGoal = [[Goal alloc] initWithGradeText:GradeTextMerit andTitle:GoalMeritEndorsement];
                      NSInteger merReq = 50;
                      GoalGradeReq(merReq, 1);
                      GoalGradeReq(merReq, 2);
                      GoalGradeReq(merReq, 3);
                      return newGoal;
                  }(),^{
                      Goal *newGoal = [[Goal alloc] initWithGradeText:GradeTextExcellence andTitle:GoalExcellenceEndorsement];
                      NSInteger exReq = 50;
                      GoalGradeReq(exReq, 1);
                      GoalGradeReq(exReq, 2);
                      GoalGradeReq(exReq, 3);
                      return newGoal;
                  }()];
    });
    
    return goals;
}

@end
