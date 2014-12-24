//
//  AnimationManager.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AnimationManager.h"
#import "AnimationObject.h"

#define EXTRA_FRAMES -1

@implementation AnimationManager

- (id)initWithAnimationObjects:(NSArray *)a length:(float)length tag:(int)tag andDelegate:(id)d {
    self = [super init];
    
    if (self) {
        _animationObjects = a;
        _animationTime = length;
        if (d) _delegate = d;
        _tag = tag;
        _animationHasFinished = NO;
        _animationShouldStopMidway = NO;
        
        [self setUpDistanceArray];
    }
    
    return self;
}

- (void)setUpDistanceArray {
    NSMutableArray *m = [[NSMutableArray alloc] init];
    for (int a = 0; a <= _animationTime * [Styles frameRate] + EXTRA_FRAMES; a++) {
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
        return (-2.0/9)*pow(stage-([Styles frameRate]*_animationTime), 2)*pow(1.0/_animationTime, 2)+100;
    }
}

- (double)getAnimationDistanceFromArray {
    return [(NSNumber *) _distances[_animationStage] doubleValue];
}

- (void)startAnimation {
    _animationStage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/[Styles frameRate] target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)stopAnimationMidWay {
    _animationShouldStopMidway = YES;
    [_timer invalidate];
    [self putEverythingInTheirFinalPlaces];
}

- (void)tick {
    _animationStage++;
    if (!_animationShouldStopMidway) {
        if (_animationStage < _distances.count) {
            double d = [self getAnimationDistanceFromArray];
            
            for (AnimationObject *a in _animationObjects) {
                [a setDistanceWithPercentage:d];
            }
        } else {
            [self finishAnimation];
        }
    }
}

- (void)finishAnimation {
    [_timer invalidate];
    [self putEverythingInTheirFinalPlaces];
    _animationHasFinished = YES;
    [_delegate animationHasFinished:_tag];
}

- (void)putEverythingInTheirFinalPlaces {
    for (AnimationObject *a in _animationObjects) {
        [a setDistanceWithPercentage:100];
    }
}

@end
