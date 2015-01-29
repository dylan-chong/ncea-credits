//
//  CustomGoals.h
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ToJSONTemplate.h"
#import "Goal.h"

@interface CustomGoals : ToJSONTemplate

@property NSMutableArray *goals;
+ (NSArray *)getAllCustomGoals;
- (Goal *)getGoalForTitle:(NSString *)title;

@end
