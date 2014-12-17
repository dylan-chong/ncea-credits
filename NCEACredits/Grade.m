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
    g.final = GradeNone;
    g.expected = GradeNone;
    g.preliminary = GradeNone;
    return g;
}

- (Grade *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Grade *g = [[Grade alloc] init];
    g.final = [[properties objectForKey:@"final"] intValue];
    g.expected = [[properties objectForKey:@"expected"] intValue];
    g.preliminary = [[properties objectForKey:@"preliminary"] intValue];
    return g;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[NSNumber numberWithInt:_final] forKey:@"final"];
    [properties setObject:[NSNumber numberWithInt:_expected] forKey:@"expected"];
    [properties setObject:[NSNumber numberWithInt:_preliminary] forKey:@"preliminary"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", error);
    return data;
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
