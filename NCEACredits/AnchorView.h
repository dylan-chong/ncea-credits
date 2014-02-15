//
//  AnchorView.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationObject.h"

@interface AnchorView : UIView <AnimationObjectDelegate>

@property (nonatomic) CGPoint startingPoint;
@property (nonatomic) NSArray *pointsToDrawTo;
@property CGPoint relativityFromMainBubble;

- (id)initWithStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo;
- (void)setStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo;
- (NSArray *)getAnimationObjectsForXDif:(float)xDif andYDif:(float)yDif;

@end
