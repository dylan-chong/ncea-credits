//
//  Assessment.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grade.h"
#import "ToJSONTemplate.h"
#import "Credits.h"

@interface Assessment : ToJSONTemplate


@property NSUInteger assessmentNumber, creditsWhenAchieved, level;
@property NSString *assessmentKeyword, *subject, *typeOfCredits;
@property BOOL isInternal, isUnitStandard;
@property Grade *gradeSet;

@end
