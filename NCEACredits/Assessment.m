//
//  Assessment.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Assessment.h"
#import "Grade.h"

@implementation Assessment

- (Assessment *)createBlank {
    //These are also the defaults and placeholders used in the Add/edit assessment screens
    Assessment *a = [[Assessment alloc] init];
    a.gradeSet = [[Grade alloc] initWithPropertiesOrNil:nil];
    a.creditsWhenAchieved = 4;
    a.typeOfCredits = TypeOfCreditsNormal;
    a.level = [CurrentProfile getPrimaryNCEALevelForCurrentYear];
    a.identifier = [[CurrentProfile getCurrentYear].assessmentCollection getUnusedAssessmentIdentifier];
    a.isAnInternal = YES;
    a.isUnitStandard = NO;
    return a;
}

- (Assessment *)loadFromJSONWithProperties:(NSDictionary *)properties {
    Assessment *a = [[Assessment alloc] init];
    a.assessmentNumber = [[properties objectForKey:@"assessmentNumber"] integerValue];
    a.quickName = [properties objectForKey:@"quickName"];
    a.creditsWhenAchieved = [[properties objectForKey:@"creditsWhenAchieved"] integerValue];
    a.typeOfCredits = [properties objectForKey:@"typeOfCredits"];
    a.level = [[properties objectForKey:@"level"] integerValue];
    a.identifier = [[properties objectForKey:@"identifier"] integerValue];
    a.isAnInternal = [[properties objectForKey:@"isAnInternal"] boolValue];
    a.isUnitStandard = [[properties objectForKey:@"isUnitStandard"] boolValue];
    a.gradeSet = [[Grade alloc] initWithPropertiesOrNil:[properties objectForKey:@"gradeSet"]];
    return a;
    
    return nil;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[NSNumber numberWithInteger:_assessmentNumber] forKey:@"assessmentNumber"];
    [properties setObject:_quickName forKey:@"quickName"];
    [properties setObject:[NSNumber numberWithInteger:_creditsWhenAchieved] forKey:@"creditsWhenAchieved"];
    [properties setObject:_typeOfCredits forKey:@"typeOfCredits"];
    [properties setObject:[NSNumber numberWithInteger:_level] forKey:@"level"];
    [properties setObject:[NSNumber numberWithInteger:_identifier] forKey:@"identifier"];
    [properties setObject:[NSNumber numberWithBool:_isAnInternal] forKey:@"isAnInternal"];
    [properties setObject:[NSNumber numberWithBool:_isUnitStandard] forKey:@"isUnitStandard"];
    [properties setObject:[_gradeSet convertToDictionaryOfProperties] forKey:@"gradeSet"];
    
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
