//
//  DefaultGoals.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "DefaultGoals.h"

@implementation DefaultGoals

+ (NSArray *)getDefaultGoalTitles {
    return @[GoalAchievement,
             GoalMeritEndorsement,
             GoalExcellenceEndorsement];
}

//Define all default goals here
+ (Goal *)getGoalForTitle:(NSString *)goalTitle {
    Goal *newGoal;
#define GoalGradeReq(creds, level) [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:creds NCEALevel:level]]
    
    //level 1 always aims to get lit/num credits (set by default in init method)
    
    if ([goalTitle isEqualToString:GoalAchievement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextAchieved];
        
        NSInteger achReq = 80;
        GoalGradeReq(achReq, 1);
        GoalGradeReq(achReq, 2);
        GoalGradeReq(achReq, 3);
        
    } else if ([goalTitle isEqualToString:GoalMeritEndorsement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextMerit];
        
        NSInteger merReq = 50;
        GoalGradeReq(merReq, 1);
        GoalGradeReq(merReq, 2);
        GoalGradeReq(merReq, 3);
        
    } else if ([goalTitle isEqualToString:GoalExcellenceEndorsement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextExcellence];
        
        NSInteger exReq = 50;
        GoalGradeReq(exReq, 1);
        GoalGradeReq(exReq, 2);
        GoalGradeReq(exReq, 3);
        
    } else {
        NSLog(@"No Goal found for title");
        return nil;
    }
    
    return newGoal;
}

@end
