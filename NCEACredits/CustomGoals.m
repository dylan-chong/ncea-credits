//
//  CustomGoals.m
//  NCEACredits
//
//  Created by Dylan Chong on 21/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "CustomGoals.h"
#import "Goal.h"

@implementation CustomGoals

- (CustomGoals *)createBlank {
    CustomGoals *gp = [[CustomGoals alloc] init];
    gp.goals = [[NSMutableArray alloc] init];
    return gp;
}

- (CustomGoals *)loadFromJSONWithProperties:(NSDictionary *)properties {
    CustomGoals *gp = [[CustomGoals alloc] init];
    gp.goals = [[NSMutableArray alloc] initWithArray:[ToJSONTemplate convertBackArrayOfJSONObjects:[properties objectForKey:@"goals"] toTemplateSubclass:NSStringFromClass([Goal class])]];
    return gp;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[ToJSONTemplate convertArrayOfTemplateSubclassesToJSON:_goals] forKey:@"goals"];
    
    return properties;
}

+ (NSArray *)getAllCustomGoals {
    return CurrentProfile.customGoals.goals;
}

- (Goal *)getGoalForTitle:(NSString *)title {
    for (Goal *goal in self.goals) {
        if ([goal.title isEqualToString:title]) return goal;
    }
    return nil;
}

@end
