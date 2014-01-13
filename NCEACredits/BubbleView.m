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
        self.scrollEnabled = NO;
        [self scrollRectToVisible:CGRectMake(w, h, w, h) animated:NO];
    }
    return self;
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    _mainBubble = m;
    _childBubbles = a;
    ((BubbleContainer *)_childBubbles[0]).delegate = self;
    _growingAnimationManager = [BubbleContainer getAnimationManagerForGrowingAnimationWithStartingScaleFactor:[Styles startingScaleFactor] andDelegate:self];
    
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
    if (_hasStartedGrowingAnimation != YES) {
        _hasStartedGrowingAnimation = YES;
        [_growingAnimationManager startAnimation];
    }
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    if (tag == X) {//Transition
        self.contentOffset = CGPointMake(value, self.contentOffset.y);
    } else if (tag == Y) {//Transition
        self.contentOffset = CGPointMake(self.contentOffset.x, value);
    } else if (tag == ScaleWidth || tag == ScaleHeight) { //Growing
        for (BubbleContainer *b in _childBubbles) {
            b.bubble.transform = CGAffineTransformMakeScale(value, value);
        }
    }
}

- (void)animationHasFinished:(int)tag {
    if (tag == 3) {
        //transition
        [self reverseTransitionToPreviousBubbleContainerPosition];
    } else if (tag == 4) {
        //transition reverse
        [self enableChildButtons];
    } else {
        //Growing finished
        [self enableChildButtons];
    }
}

- (void)disableChildButtons {
    for (BubbleContainer *b in _childBubbles) {
        b.userInteractionEnabled = NO;
    }
}

- (void)enableChildButtons {
    for (BubbleContainer *b in _childBubbles) {
        b.userInteractionEnabled = YES;
    }
}

//************************************** Transition **************************************

- (void)startTransitionToChildBubble:(BubbleContainer *)b {
    [self disableChildButtons];
    [self setTransitionDifsWithBubbleContainerFrame:b.frame];
    [self setUpAnimationManagerForTransition];
}

- (void)reverseTransitionToPreviousBubbleContainerPosition {
    _transitionXDif = 0 - _transitionXDif;
    _transitionYDif = 0 - _transitionYDif;
    [self setUpAnimationManagerForTransition];
}

- (void)setUpAnimationManagerForTransition {
    NSArray *a = [_mainBubble getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif];
    
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
    }
    
    _transitionAnimationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:4 andDelegate:self];
    [_transitionAnimationManager startAnimation];
}

- (void)setTransitionDifsWithBubbleContainerFrame:(CGRect)b {
    Corner opposite = [Styles getOppositeCornerToCorner:[Styles getCornerWithTitleContainerFrame:b]];
    
    CGPoint newPoint = [Styles getExactCornerPointForCorner:opposite];
    CGPoint oldPoint = b.origin;
    
    _transitionXDif = newPoint.x - oldPoint.x;
    _transitionYDif = newPoint.y - oldPoint.y;
}

@end
