//
//  SubjectColourPair.m
//  NCEACredits
//
//  Created by Dylan Chong on 1/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "SubjectColourPair.h"

@implementation SubjectColourPair

+ (SubjectColourPair *)pairWithSubject:(NSString *)subject andColour:(UIColor *)colour; {
    SubjectColourPair *p = [[SubjectColourPair alloc] init];
    p.colour = colour;
    p.subject = subject;
    return p;
}

+ (NSArray *)sortArrayOfSubjectColourPairs:(NSArray *)array{
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"subject" ascending:YES];
    return [array sortedArrayUsingDescriptors:@[desc]];
}

@end
