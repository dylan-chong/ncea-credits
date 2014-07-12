//
//  ToJSONTemplate.m
//  NCEACredits
//
//  Created by Dylan Chong on 6/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ToJSONTemplate.h"

@implementation ToJSONTemplate

- (id)initWithJSONOrNil:(NSData *)json {
    self = [super init];
    
    if (self) {
        if (!json) {
            //Blank
            [self createBlank];
        } else {
            //Load
            [self loadFromJSON:json];
        }
    }
    
    return self;
}

- (void)createBlank {
    NSAssert(NO, @"You must override the method createBlank from class ToJSONTemplate.");
}

- (void)loadFromJSON:(NSData *)json {
    NSAssert(NO, @"You must override the method loadFromJSON from class ToJSONTemplate.");
}

- (NSData *)convertToJSON {
    NSAssert(NO, @"You must override the method convertToJSON from class ToJSONTemplate.");
    return nil;
}

@end
