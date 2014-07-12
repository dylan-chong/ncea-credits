//
//  GradePriority.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GradePriority.h"

@implementation GradePriority

- (void)createBlank {
    _priorityOrder = [GradePriority defaultPriorityOrder];
}

- (void)loadFromJSON:(NSData *)json {
    
}

- (NSData *)convertToJSON {
    
    return nil;
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
