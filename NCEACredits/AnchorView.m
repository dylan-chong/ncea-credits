//
//  AnchorView.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AnchorView.h"
#import "Styles.h"
#import "BubbleContainer.h"

@implementation AnchorView

- (id)initWithStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo {
    self = [super initWithFrame:CGRectMake([Styles screenWidth], [Styles screenHeight], [Styles screenWidth], [Styles screenHeight])];
    if (self) {
        _startingPoint = startingPoint;
        _pointsToDrawTo = pointsToDrawTo;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo {
    _startingPoint = startingPoint;
    _pointsToDrawTo = pointsToDrawTo;
}

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to withContext:(CGContextRef)context {
    if (to.x > [Styles screenWidth] && to.y > [Styles screenHeight] && to.x < [Styles screenWidth] * 2 && to.y < [Styles screenHeight] * 2) {
        CGContextMoveToPoint(context, from.x - [Styles screenWidth], from.y - [Styles screenHeight]);
        CGContextAddLineToPoint(context, to.x - [Styles screenWidth], to.y - [Styles screenHeight]);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[Styles greyColour] setStroke];
    CGContextSetLineWidth(context, 1.0);
    
    for (NSValue *v in _pointsToDrawTo) {
        [self drawLineFromPoint:
         _startingPoint
                        toPoint:
         [AnchorView getCGPointFromNSValue:v]
                    withContext:context];
    }
    
    CGContextStrokePath(context);
}

+ (CGPoint)getCGPointFromNSValue:(NSValue *)v {
    return [v CGPointValue];
}

//******************************************** Transition ***********************************************

- (NSArray *)getAnimationObjectsForXDif:(float)xDif andYDif:(float)yDif {
    return [[NSArray alloc] initWithObjects:
            
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.x endingPoint:self.frame.origin.x + xDif tag:X andDelegate:self],
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.y endingPoint:self.frame.origin.y + yDif tag:Y andDelegate:self],
            
            nil];
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    CGRect r = self.frame;
    if (tag == X) {
        r.origin.x = value;
    } else if (tag == Y) {
        r.origin.y = value;
    }
    self.frame = r;
}

@end
