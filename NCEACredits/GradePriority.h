//
//  GradePriority.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"

typedef NS_ENUM(NSInteger, GradePriorityType) {
    FinalGrade,
    PreliminaryGrade,
    ExpectedGrade,
};

@interface GradePriority : ToJSONTemplate

@property NSArray *priorityOrder;
//First is high priority

@end
