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

//typedef NS_ENUM(NSInteger, GradeType) {
//    GradeExcellence,
//    GradeMerit,
//    GradeAchieved,
//    GradeNotAchieved,
//    GradeNone
//};

#define GradeTextExcellence @"Excellence"
#define GradeTextMerit @"Merit"
#define GradeTextAchieved @"Achieved"
#define GradeTextNotAchieved @"NotAchieved"
#define GradeTextNone @""

//NSInteger (^GradeTextToGradeEnum)(NSString *) = ^(NSString *grade) {
//    if ([grade isEqualToString:GradeTextExcellence]) return GradeExcellence;
//    else if ([grade isEqualToString:GradeTextMerit]) return GradeMerit;
//    else if ([grade isEqualToString:GradeTextAchieved]) return GradeAchieved;
//    else if ([grade isEqualToString:GradeTextNotAchieved]) return GradeNotAchieved;
//    else return GradeNone;
//};
//
//NSString *(^GradeEnumToGradeText)(NSInteger) = ^(NSInteger grade) {
//    switch (grade) {
//        case GradeExcellence:
//            return GradeTextExcellence;
//            break;
//            
//        case GradeMerit:
//            return GradeTextMerit;
//            break;
//            
//        case GradeAchieved:
//            return GradeTextAchieved;
//            break;
//            
//        case GradeNotAchieved:
//            return GradeTextNotAchieved;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return @"";
//};

@interface Grade : ToJSONTemplate

//If modifying the number of variables below, you must modify AssessmentCollection's addAssessmentOrReplaceACurrentOne: method
@property NSString *final, *preliminary, *expected;

@end
