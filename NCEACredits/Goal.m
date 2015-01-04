//
//  Goal.m
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Goal.h"

@implementation Goal
#warning TODO: custom goals

- (id)initWithGradeText:(NSString *)gpg {
    self = [super init];
    
    if (self) {
        _primaryGrade = gpg;
        _availableGoalGradeReqs = [[NSArray alloc] init];
    }
    
    return self;
}

- (BOOL)addGoalGradeReqsForLevel:(GoalGradeReqAndLevel *)gg {
    if ([self alreadyContainsLevel:gg.level]) {
        NSLog(@"Goal already has requirements for this NCEA Level");
        return NO;
    } else {
        _availableGoalGradeReqs = [_availableGoalGradeReqs arrayByAddingObject:gg];
        return YES;
    }
}

- (BOOL)alreadyContainsLevel:(NSUInteger)level {
    for (GoalGradeReqAndLevel *gg in _availableGoalGradeReqs) {
        if (gg.level == level)
            return YES;
    }
    
    return NO;
}

- (NSInteger)getCreditsLeftToCompleteWithAllCredits:(NSDictionary *)allCredits atLevel:(NSUInteger)level {
    NSInteger required = [self getRequirementForLevel:level];
    NSInteger current = [[allCredits objectForKey:_primaryGrade] integerValue];
    
    return required - current;
}

- (NSUInteger)getRequirementForLevel:(NSUInteger)level {
    for (GoalGradeReqAndLevel *gg in _availableGoalGradeReqs) {
        if (gg.level == level) {
            return gg.creditsRequired;
        }
    }
    
    NSLog(@"No requirement set for NCEA Level %lu", (unsigned long)level);
    return -1;
}

@end
