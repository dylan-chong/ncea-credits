//
//  GoalMain.h
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultGoals.h"

@interface GoalMain : NSObject

+ (NSArray *)getAllGoals;
+ (Goal *)getAnyTypeOfGoalForTitle:(NSString *)title;
+ (Goal *)getCustomGoalForTitle:(NSString *)title;

@end
