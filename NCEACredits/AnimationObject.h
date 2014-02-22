//
//  AnimationObject.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    X = 0,
    Y = 1,
    Width = 2,
    Height = 3,
    ScaleWidth = 4,
    ScaleHeight = 5,
    Alpha = 6
} AnimationObjectTag;

@protocol AnimationObjectDelegate <NSObject>
@required
- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag;
@end

@interface AnimationObject : NSObject

@property id<AnimationObjectDelegate> delegate;
@property double baseNumber, finalDistance;
@property AnimationObjectTag tag;

- (id)initWithStartingPoint:(double)s endingPoint:(double)e tag:(AnimationObjectTag)tag andDelegate:(id)d;
- (void)setDistanceWithPercentage:(float)percent;

@end
