//
//  Profile.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (void)createBlank {
    
}

- (void)loadFromJSON:(NSData *)json {
    
}

- (NSData *)convertToJSON {
    
    return nil;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

- (NSArray *)getSubjects {
    return [[NSArray alloc] initWithObjects:@"Maths", @"Physics", @"Chemistry", @"I.T.", @"English", @"Music", @"Biology", @"Spanish", nil];
}

- (id)getYearObjectForYearDate:(NSUInteger)date {
    return nil;
    #warning TODO: do year thing
}

@end
