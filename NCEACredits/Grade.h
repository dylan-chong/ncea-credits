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
    Excellence = 4,
    Merit = 3,
    Achieved = 2,
    NotAchieved = 1,
    None = 0
} GradeType;

@interface Grade : ToJSONTemplate

@property GradeType final, preliminary, expected;

@end
