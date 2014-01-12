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
        _delegate = d;
        _tag = tag;
    }
    
    return self;
}

- (double)getAnimationDistance {
    if (_animationStage < _animationTime * 15) {
        return (2.0/9)*pow(_animationStage, 2)*pow(1.0/_animationTime, 2);
    } else {
        return (-2.0/9)*pow(_animationStage-(30*_animationTime), 2)*pow(1.0/_animationTime, 2)+100;
    }
}

- (void)startAnimation {
    _animationStage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick {
    _animationStage++;
    if (_animationStage <= _animationTime * 30) {
        double d = [self getAnimationDistance];
        
        for (AnimationObject *a in _animationObjects) {
            [a setDistanceWithPercentage:d];
        }
    } else {
        [_timer invalidate];
        [_delegate animationHasFinished:_tag];
    }
}

@end
