//
//  AssessmentCollection.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AssessmentCollection.h"

@implementation AssessmentCollection

- (AssessmentCollection *)createBlank {
    AssessmentCollection *a = [[AssessmentCollection alloc] init];
    a.assessments = [[NSMutableArray alloc] init];
    return a;
}

- (AssessmentCollection *)loadFromJSONWithProperties:(NSDictionary *)properties {
    AssessmentCollection *a = [[AssessmentCollection alloc] init];
    a.assessments = [ToJSONTemplate convertBackArrayOfJSONObjects:[properties objectForKey:@"assessments"] toTemplateSubclass:NSStringFromClass([Assessment class])];
    return a;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[ToJSONTemplate convertArrayOfTemplateSubclassesToJSON:_assessments] forKey:@"assessments"];
    
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
