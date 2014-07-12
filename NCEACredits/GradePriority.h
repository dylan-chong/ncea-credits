//
//  GradePriority.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"

typedef enum {
    FinalGrade = 1,
    PreliminaryGrade = 2,
    ExpectedGrade = 3,
} GradePriorityType;

@interface GradePriority : ToJSONTemplate

@property NSArray *priorityOrder;
//First is high priority

@end
