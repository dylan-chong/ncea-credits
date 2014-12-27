//
//  AppSettings.m
//  NCEACredits
//
//  Created by Dylan Chong on 23/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

- (AppSettings *)createBlank {
    AppSettings *as = [[AppSettings alloc] init];
    as.lastProfileFileName = @"";
    return as;
}

- (AppSettings *)loadFromJSONWithProperties:(NSDictionary *)properties {
    AppSettings *as = [[AppSettings alloc] init];
    as.lastProfileFileName = [properties objectForKey:@"lastProfileFileName"];
    return as;
}

- (NSData *)convertToJSONAsRoot {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_lastProfileFileName forKey:@"lastProfileFileName"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", [error localizedDescription]);
    return data;
}

@end
