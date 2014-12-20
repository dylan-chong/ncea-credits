//
//  DefaultGoals.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "DefaultGoals.h"

@implementation DefaultGoals

+ (NSArray *)getAllGoalTitles {
    return @[GoalAchievement,
             GoalMeritEndorsement,
             GoalExcellenceEndorsement];
}

//Define all default goals here
+ (Goal *)getGoalForTitle:(NSString *)goalTitle {
    Goal *newGoal;
    
    //level 1 always aims to get lit/num credits
    GoalGradeReqAndLevel *level1Ach = [[GoalGradeReqAndLevel alloc] initWithCreditsRequired:0 NCEALevel:1];
    level1Ach.literacyCredits = 10;
    level1Ach.numeracyCredits = 10;
    
    if ([goalTitle isEqualToString:GoalAchievement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextAchieved];
        
        int achReq = 80;
        level1Ach.creditsRequired = achReq;
        [newGoal addGoalGradeReqsForLevel:level1Ach];
        
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:achReq NCEALevel:2]];
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:achReq NCEALevel:3]];
        
    } else if ([goalTitle isEqualToString:GoalMeritEndorsement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextMerit];
        
        int merReq = 50;
        level1Ach.creditsRequired = merReq;
        [newGoal addGoalGradeReqsForLevel:level1Ach];
        
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:merReq NCEALevel:2]];
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:merReq NCEALevel:3]];
        
    } else if ([goalTitle isEqualToString:GoalExcellenceEndorsement]) {
        newGoal = [[Goal alloc] initWithGradeText:GradeTextExcellence];
        
        int exReq = 50;
        level1Ach.creditsRequired = exReq;
        [newGoal addGoalGradeReqsForLevel:level1Ach];
        
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:exReq NCEALevel:2]];
        [newGoal addGoalGradeReqsForLevel:[[GoalGradeReqAndLevel alloc] initWithCreditsRequired:exReq NCEALevel:3]];
        
    } else {
        NSLog(@"No Goal found for title");
        return nil;
    }
    
    return newGoal;
}

@end
