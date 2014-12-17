//
//  Assessment.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Assessment.h"

@implementation Assessment

- (Assessment *)createBlank {
    Assessment *a = [[Assessment alloc] init];
    a.gradeSet = [[Grade alloc] initWithJSONOrNil:nil];
    a.creditsWhenAchieved = 4;
    a.typeOfCredits = TypeOfCreditsNormal;
    a.level = [CurrentProfile getPrimaryNCEALevelForCurrentYear];
    a.isInternal = YES;
    a.isUnitStandard = NO;
    return a;
}

- (Assessment *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Assessment *a = [[Assessment alloc] init];
    a.assessmentNumber = [[properties objectForKey:@"assessmentNumber"] integerValue];
    a.assessmentKeyword = [properties objectForKey:@"assessmentKeyword"];
    a.creditsWhenAchieved = [[properties objectForKey:@"creditsWhenAchieved"] integerValue];
    a.typeOfCredits = [properties objectForKey:@"typeOfCredits"];
    a.level = [[properties objectForKey:@"level"] integerValue];
    a.isInternal = [[properties objectForKey:@"isInternal"] boolValue];
    a.isUnitStandard = [[properties objectForKey:@"isUnitStandard"] boolValue];
    a.gradeSet = [[Grade alloc] initWithJSONOrNil:NSStringToNSData([properties objectForKey:@"gradeSet"])];
    return a;
    
    return nil;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[NSNumber numberWithInteger:_assessmentNumber] forKey:@"assessmentNumber"];
    [properties setObject:_assessmentKeyword forKey:@"assessmentKeyword"];
    [properties setObject:[NSNumber numberWithInteger:_creditsWhenAchieved] forKey:@"creditsWhenAchieved"];
    [properties setObject:_typeOfCredits forKey:@"typeOfCredits"];
    [properties setObject:[NSNumber numberWithInteger:_level] forKey:@"level"];
    [properties setObject:[NSNumber numberWithBool:_isInternal] forKey:@"isInternal"];
    [properties setObject:[NSNumber numberWithBool:_isUnitStandard] forKey:@"isUnitStandard"];
    [properties setObject:NSDataToNSString([_gradeSet convertToJSON]) forKey:@"gradeSet"];
    
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
