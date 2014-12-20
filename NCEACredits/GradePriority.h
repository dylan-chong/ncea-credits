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
    GradePriorityFinalGrade = 1,
    GradePriorityPreliminaryGrade,
    GradePriorityExpectedGrade,
};

@interface GradePriority : ToJSONTemplate

@property NSArray *priorityOrder;
//First is high priority

@end
