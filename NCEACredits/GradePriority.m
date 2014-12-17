//
//  GradePriority.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradePriority.h"

@implementation GradePriority

- (GradePriority *)createBlank {
    GradePriority *gp = [[GradePriority alloc] init];
    gp.priorityOrder = [GradePriority defaultPriorityOrder];
    return gp;
}

- (GradePriority *)loadFromJSONWithProperties:(NSDictionary *)properties {
    GradePriority *gp = [[GradePriority alloc] init];
    gp.priorityOrder = [properties objectForKey:@"priorityOrder"];
    return gp;
}

- (NSData *)convertToJSON {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_priorityOrder forKey:@"priorityOrder"];
    
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

+ (NSArray *)defaultPriorityOrder {
    return @[tNSN(FinalGrade), tNSN(PreliminaryGrade), tNSN(ExpectedGrade)];
}

@end
