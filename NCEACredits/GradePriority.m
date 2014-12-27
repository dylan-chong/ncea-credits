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

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_priorityOrder forKey:@"priorityOrder"];
    
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

+ (NSArray *)defaultPriorityOrder {
    return @[tNSN(GradePriorityFinalGrade),
             tNSN(GradePriorityExpectedGrade),
             tNSN(GradePriorityPreliminaryGrade),];
}

@end
