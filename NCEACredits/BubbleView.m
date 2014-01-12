//
//  BubbleView.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleView.h"
#import "Styles.h"

@implementation BubbleView

- (id)init {
    self = [super initWithFrame:[Styles getFullScreenFrame]];
    if (self) {
        float w = [Styles screenWidth];
        float h = [Styles screenHeight];
        self.contentSize = CGSizeMake(w * 3, h * 3);
        //self.scrollEnabled = NO;
        [self scrollRectToVisible:CGRectMake(w, h, w, h) animated:NO];
    }
    return self;
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    _mainBubble = m;
    _childBubbles = a;
    ((BubbleContainer *)_childBubbles[0]).delegate = self;
    
    _anchors = [[AnchorView alloc] initWithStartingPoint:[self convertPoint:_mainBubble.bubble.center fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
    [self addSubview:_anchors];
    [self sendSubviewToBack:_anchors];
    [self bringSubviewToFront:_mainBubble];
}

- (void)redrawAnchors {
    [_anchors setStartingPoint:[self convertPoint:_mainBubble.bubble.center fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
    [_anchors setNeedsDisplay];
}

- (NSArray *)getAnchorPointsFromChildBubbles {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        [points addObject:[NSValue valueWithCGPoint:[self convertPoint:b.bubble.center fromView:b]]];
    }
    
    return points;
}

- (void)startChildBubbleCreationAnimation {
    for (BubbleContainer *b in _childBubbles) {
        [b startSlidingAnimation];
    }
}

- (void)slidingAnimationHasCompleted {
    _growingAnimationManager = [BubbleContainer getAnimationManagerForGrowingAnimationWithStartingScaleFactor:[Styles startingScaleFactor] andDelegate:self];
    [_growingAnimationManager startAnimation];
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.transform = CGAffineTransformMakeScale(value, value);
    }
}



@end
