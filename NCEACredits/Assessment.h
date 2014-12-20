//
//  Assessment.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"
#import "Grade.h"

@interface Assessment : ToJSONTemplate

//Changing these fields means updating the EditAssessmentVC
@property NSUInteger assessmentNumber, creditsWhenAchieved, level, identifier;
@property NSString *quickName, *subject, *typeOfCredits;
@property BOOL isAnInternal, isUnitStandard;
@property Grade *gradeSet;

@end
