//
//  DefaultGoals.h
//  NCEACredits
//
//  Created by Dylan Chong on 13/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal.h"

#define GoalAchievement @"Achievement"
#define GoalMeritEndorsement @"Merit Endors."
#define GoalExcellenceEndorsement @"Excel. Endors."

@interface DefaultGoals : NSObject

+ (NSArray *)getAllGoalTitles;
+ (Goal *)getGoalForTitle:(NSString *)goalTitle;

@end
