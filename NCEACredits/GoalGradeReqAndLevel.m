//
//  GoalGradeReqAndLevel.m
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GoalGradeReqAndLevel.h"

@implementation GoalGradeReqAndLevel

- (id)initWithCreditsRequired:(NSUInteger)creds NCEALevel:(NSUInteger)level {
    self = [super init];
    
    if (self) {
        _creditsRequired = creds;
        _level = level;
        
        if (level == 1) {
            _literacyCredits = 10;
            _numeracyCredits = 10;
        } else {
            _literacyCredits = -1;
            _numeracyCredits = -1;
        }
        
    }
    
    return self;
}

@end
