//
//  AnimationObject.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnimationObjectTag) {
    X = 1,
    Y,
    Width,
    Height,
    ScaleWidth,
    ScaleHeight,
    Alpha
} ;

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
