//
//  AnimationManager.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnimationManagerDelegate <NSObject>
- (void)animationHasFinished:(int)tag;
@end

@interface AnimationManager : NSObject

@property double animationTime;
@property int animationStage, tag;
@property id<AnimationManagerDelegate> delegate;
@property NSArray *animationObjects;
@property NSTimer *timer;

- (id)initWithAnimationObjects:(NSArray *)a length:(float)length tag:(int)tag andDelegate:(id)d;
- (void)startAnimation;

@end
