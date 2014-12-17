//
//  Grade.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"

typedef enum {
    GradeExcellence = 4,
    GradeMerit = 3,
    GradeAchieved = 2,
    GradeNotAchieved = 1,
    GradeNone = 0
} GradeType;

@interface Grade : ToJSONTemplate

@property GradeType final, preliminary, expected;

@end
