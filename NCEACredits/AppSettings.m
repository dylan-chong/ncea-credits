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
    as.hasOpenedStatsMenuBefore = NO;
    
    as.lastEnteredExpectGrade = @"";
    as.lastEnteredFinalGrade = @"";
    as.lastEnteredPrelimGrade = @"";
    as.lastEnteredSubject = @"";
    as.lastEnteredWasInternal = YES;
    
    as.animationSpeed = AnimationSpeedSelectionNormal;
    
    return as;
}

- (AppSettings *)loadFromJSONWithProperties:(NSDictionary *)properties {
    AppSettings *as = [[AppSettings alloc] init];
    as.lastProfileFileName = [properties objectForKey:@"lastProfileFileName"];
    as.hasOpenedStatsMenuBefore = [[properties objectForKey:@"hasOpenedStatsMenuBefore"] boolValue];
    
    as.lastEnteredExpectGrade = [properties objectForKey:@"lastEnteredExpectGrade"];
    as.lastEnteredFinalGrade = [properties objectForKey:@"lastEnteredFinalGrade"];
    as.lastEnteredPrelimGrade = [properties objectForKey:@"lastEnteredPrelimGrade"];
    as.lastEnteredSubject = [properties objectForKey:@"lastEnteredSubject"];
    as.lastEnteredWasInternal = [[properties objectForKey:@"lastEnteredWasInternal"] boolValue];
    
    //animation speed is new so must account for not existing
    NSNumber *animSpeed = [properties objectForKey:@"animationSpeed"];
    if (animSpeed) as.animationSpeed = [animSpeed integerValue];
    else as.animationSpeed = AnimationSpeedSelectionNormal;

    return as;
}

- (NSData *)convertToJSONAsRoot {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_lastProfileFileName forKey:@"lastProfileFileName"];
    [properties setObject:[NSNumber numberWithBool:_hasOpenedStatsMenuBefore] forKey:@"hasOpenedStatsMenuBefore"];
    
    [properties setObject:_lastEnteredExpectGrade forKey:@"lastEnteredExpectGrade"];
    [properties setObject:_lastEnteredFinalGrade forKey:@"lastEnteredFinalGrade"];
    [properties setObject:_lastEnteredPrelimGrade forKey:@"lastEnteredPrelimGrade"];
    [properties setObject:_lastEnteredSubject forKey:@"lastEnteredSubject"];
    [properties setObject:[NSNumber numberWithBool:_lastEnteredWasInternal] forKey:@"lastEnteredWasInternal"];

    [properties setObject:[NSNumber numberWithInteger:_animationSpeed] forKey:@"animationSpeed"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", [error localizedDescription]);
    return data;
}

- (void)logJSONText {
    //Logs profile JSON
    if (ApplicationDelegate.appSettings) {
        AppSettings *a = CurrentAppSettings;
        NSString *m = [[NSString alloc] initWithData:[a convertToJSONAsRoot]  encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n//*\n//****\n//*********\n//****************\n//*************************\n********************************************    App Settings JSON    \n//*************************\n//****************\n//*********\n//****\n//*\n\n\n");
        NSLog(@"%@", m);
    
    }
}

@end
