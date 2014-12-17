//
//  YearCollection.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "YearCollection.h"

@implementation YearCollection

- (YearCollection *)createBlank {
    YearCollection *yc = [[YearCollection alloc] init];
    yc.years = [[NSMutableArray alloc] init];
    return yc;
}

- (YearCollection *)loadFromJSONWithProperties:(NSDictionary *)properties {
    YearCollection *yc = [[YearCollection alloc] init];
    yc.years = [ToJSONTemplate convertBackArrayOfJSONObjects:[properties objectForKey:@"years"]
                                          toTemplateSubclass:NSStringFromClass([Year class])];
    return yc;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[ToJSONTemplate convertArrayOfTemplateSubclassesToJSON:_years] forKey:@"years"];
    
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
