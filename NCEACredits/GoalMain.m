//
//  GoalMain.m
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GoalMain.h"

// any property = -1 --> not required

@implementation GoalMain

+ (Goal *)getAnyTypeOfGoalForTitle:(NSString *)title {
    Goal *goal = [self getDefaultGoalForTitle:title];
    if (goal) return goal;
    
    goal = [self getCustomGoalForTitle:title];
    if (goal) return goal;
    
    return nil;
}

+ (NSArray *)getAllGoals {
    NSArray *defaults = [DefaultGoals getAllDefaultGoals];
    NSArray *customGoals = [CustomGoals getAllCustomGoals];
    
    if (customGoals) return [defaults arrayByAddingObjectsFromArray:customGoals];
    else return defaults;
}

+ (Goal *)getDefaultGoalForTitle:(NSString *)title {
    return [DefaultGoals getGoalForTitle:title];
}

+ (Goal *)getCustomGoalForTitle:(NSString *)title {
    return [CurrentProfile.customGoals getGoalForTitle:title];
}

@end
