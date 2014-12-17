//
//  Year.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssessmentCollection.h"
#import "Assessment.h"
#import "ToJSONTemplate.h"

@interface Year : ToJSONTemplate 

@property NSUInteger yearDate, primaryLevelNumber, identifier;
@property AssessmentCollection *assessmentCollection;

+ (NSUInteger)getCurrentYearDate;

@end
