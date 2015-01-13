//
//  AnimationManager.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnimationManagerDelegate <NSObject>
- (void)animationHasFinished:(NSInteger)tag;
@end

@interface AnimationManager : NSObject

@property double animationTime;
@property NSInteger animationStage, tag;
@property id<AnimationManagerDelegate> delegate;
@property NSArray *animationObjects;
@property NSTimer *timer;
@property NSArray *distances;
@property BOOL animationHasFinished, animationShouldStopMidway;

- (id)initWithAnimationObjects:(NSArray *)a length:(float)length tag:(NSInteger)tag andDelegate:(id)d;
- (void)startAnimation;
- (void)stopAnimationMidWay;

@end
