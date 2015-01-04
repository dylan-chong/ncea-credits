//
//  SubjectColourPair.h
//  NCEACredits
//
//  Created by Dylan Chong on 1/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectColourPair : NSObject

//For use in SimpleSelectionVC (not SubjectsAndColours in profile)s
+ (SubjectColourPair *)pairWithSubject:(NSString *)subject andColour:(UIColor *)colour;
@property NSString *subject;
@property UIColor *colour;

+ (NSArray *)sortArrayOfSubjectColourPairs:(NSArray *)array;

@end
