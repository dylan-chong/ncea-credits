//
//  Year.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"
#import "AssessmentCollection.h"
#import "SubjectsAndColours.h"

@interface Year : ToJSONTemplate 

@property NSUInteger yearDate, primaryLevelNumber, identifier;
@property AssessmentCollection *assessmentCollection;
@property SubjectsAndColours *subjectsAndColours;

+ (NSUInteger)getCurrentYearDate;

@end
