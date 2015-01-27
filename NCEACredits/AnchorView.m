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
#import "AnimationObject.h"

@implementation AnchorView

- (id)initWithStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo {
    CGSize screen = [CurrentAppDelegate getScreenSize];
    self = [super initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    if (self) {
        _startingPoint = startingPoint;
        _pointsToDrawTo = pointsToDrawTo;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to withContext:(CGContextRef)context {
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
}

- (void)redrawAnchorsWithStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo {
    _startingPoint = startingPoint;
    _pointsToDrawTo = pointsToDrawTo;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[Styles mediumLightGreyColour] setStroke];
    CGContextSetLineWidth(context, ANCHOR_THICKNESS);
    
    for (NSValue *v in _pointsToDrawTo) {
        [self drawLineFromPoint:
         _startingPoint
                        toPoint:
         [AnchorView getCGPointFromNSValue:v]
                    withContext:context];
    }
    
    if (![Styles point:_relativityFromMainBubble isEqualToPoint:CGPointZero]) {
        CGPoint newPoint = _startingPoint;
        newPoint.x += _relativityFromMainBubble.x;
        newPoint.y += _relativityFromMainBubble.y;
        [self drawLineFromPoint:_startingPoint toPoint:newPoint withContext:context];
    }
    
    CGContextStrokePath(context);
}

+ (CGPoint)getCGPointFromNSValue:(NSValue *)v {
    return [v CGPointValue];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Transition    ************************************
//*************************
//****************
//*********
//****
//*

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
