//
//  Grade.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"

//Can't find any other place to put this, it otherwise causes duplicate symbols or unknown type errors

#define TypeOfCreditsNormal @"Normal"
#define TypeOfCreditsLiteracy @"Literacy"
#define TypeOfCreditsNumeracy @"Numeracy"

#define GradeTextExcellence @"Excellence"
#define GradeTextMerit @"Merit"
#define GradeTextAchieved @"Achieved"
#define GradeTextNotAchieved @"Not Achieved"
#define GradeTextNone @""
#define GradeTextTitleNone @"None"

@interface Grade : ToJSONTemplate

//If modifying the number of variables below, you must modify AssessmentCollection's addAssessmentOrReplaceACurrentOne: method
@property NSString *final, *preliminary, *expected;
- (NSString *)getHighestPriorityExistingGradeText;
- (NSString *)getGradeTextForGradeType:(GradePriorityType)type;

@end
