//
//  Grade.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Grade.h"

@implementation Grade

- (Grade *)createBlank {
    Grade *g = [[Grade alloc] init];
    g.final = GradeTextNone;
    g.expected = GradeTextNone;
    g.preliminary = GradeTextNone;
    return g;
}

- (Grade *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Grade *g = [[Grade alloc] init];
    g.final = [properties objectForKey:@"final"];
    g.expected = [properties objectForKey:@"expected"];
    g.preliminary = [properties objectForKey:@"preliminary"];
    return g;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_final forKey:@"final"];
    [properties setObject:_expected forKey:@"expected"];
    [properties setObject:_preliminary forKey:@"preliminary"];
    
    return properties;
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


@end
