//
//  SubjectsAndColours.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"

@interface SubjectsAndColours : ToJSONTemplate

@property NSMutableDictionary *subjectsAndColours;

- (UIColor *)getColourForSubject:(NSString *)subject;
- (NSArray *)getSortedDefaultColours;

@end
