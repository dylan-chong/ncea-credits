//
//  AnimationManager.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AnimationManager.h"
#import "AnimationObject.h"

@implementation AnimationManager

- (id)initWithAnimationObjects:(NSArray *)a length:(float)length tag:(int)tag andDelegate:(id)d {
    self = [super init];
    
    if (self) {
        _animationObjects = a;
        _animationTime = length;
        if (d) _delegate = d;
        _tag = tag;
        
        [self setUpDistanceArray];
    }
    
    return self;
}

- (void)setUpDistanceArray {
    NSMutableArray *m = [[NSMutableArray alloc] init];
    for (int a = 1; a <= _animationTime * 30 + 1; a++) {
        [m addObject:
         [NSNumber numberWithDouble:
          [self getAnimationDistanceForStage:a]]];
    }
    
    _distances = m;
}

- (double)getAnimationDistanceForStage:(int)stage {
    if (stage < _animationTime * 15) {
        return (2.0/9)*pow(stage, 2)*pow(1.0/_animationTime, 2);
    } else {
        return (-2.0/9)*pow(stage-(30*_animationTime), 2)*pow(1.0/_animationTime, 2)+100;
    }
}

- (double)getAnimationDistanceFromArray {
    return [(NSNumber *) _distances[_animationStage] doubleValue];
}

- (void)startAnimation {
    _animationStage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick {
    _animationStage++;
    if (_animationStage <= _animationTime * 30) {
        double d = [self getAnimationDistanceFromArray];
        
        for (AnimationObject *a in _animationObjects) {
            [a setDistanceWithPercentage:d];
        }
    } else {
        [_timer invalidate];
        [_delegate animationHasFinished:_tag];
    }
}

@end
