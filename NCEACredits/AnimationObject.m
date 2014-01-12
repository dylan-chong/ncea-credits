//
//  AnimationObject.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AnimationObject.h"
#import "Styles.h"

@implementation AnimationObject

- (id)initWithStartingPoint:(double)s endingPoint:(double)e tag:(AnimationObjectTag)tag andDelegate:(id)d {
    self = [super init];
    
    if (self) {
        _baseNumber = s;
        
        _finalDistance = e - s;
        _tag = tag;
        
        _delegate = d;
    }
    
    return self;
}

- (void)setDistanceWithPercentage:(float)percent {
    [self.delegate useDistanceFromBase:_baseNumber + ((percent / 100) * _finalDistance) tag:(AnimationObjectTag)_tag];
}

@end