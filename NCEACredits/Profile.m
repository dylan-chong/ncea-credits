//
//  Profile.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

//************************************************************************************

- (NSArray *)getSubjects {
    return [[NSArray alloc] initWithObjects:@"Mathematics", @"Physics", @"Chemistry", @"I.T.", @"English", @"Music", nil];
}

@end
