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
    self = [super initWithFrame:CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight])];
    if (self) {
        self.clipsToBounds = YES;
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
    if (_disableAnchorReDraw != YES) {
        [_anchors setStartingPoint:[self convertPoint:_mainBubble.bubble.center fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
        [_anchors setNeedsDisplay];
    }
}

- (NSArray *)getAnchorPointsFromChildBubbles {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        [points addObject:[NSValue valueWithCGPoint:[self convertPoint:b.bubble.center fromView:b]]];
    }
    
    return points;
}

//************************************** Starting Animation **************************************

- (void)startChildBubbleCreationAnimation {
    NSArray *a = [[NSArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForSlidingAnimation]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:1 andDelegate:self];
    [_animationManager startAnimation];
}

- (void)startSlidingAnimation {
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:[[NSArray alloc] initWithObjects:
                                                                            [[AnimationObject alloc] initWithStartingPoint:[Styles startingScaleFactor] endingPoint:1.0 tag:ScaleWidth andDelegate:self],
                                                                            nil]
                                                                    length:[Styles animationSpeed]
                                                                       tag:2 andDelegate:self];
    [_animationManager startAnimation];
    
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    if (tag == ScaleWidth || tag == ScaleHeight) { //Growing
        for (BubbleContainer *b in _childBubbles) {
            b.bubble.transform = CGAffineTransformMakeScale(value, value);
        }
    }
}

- (void)animationHasFinished:(int)tag {
    if (tag == 1) {
        [self startSlidingAnimation];
    } else if (tag == 2) {
        //Growing finished
        [self enableChildButtons];
    } else if (tag == 3) {
        //transition
        _disableAnchorReDraw = NO;
        [self enableWiggleForTransition];
        [self enableChildButtons];
        [self reverseTransitionToPreviousBubbleContainerPosition];
    } else if (tag == 4) {
        //transition reverse
        [self enableChildButtons];
        [self enableWiggleForTransition];
        _disableAnchorReDraw = NO;
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

//************************************** Transition ****************************************

- (void)startTransitionToChildBubble:(BubbleContainer *)b {
    [self setTransitionDifsWithBubbleContainerFrame:b.frame];
    [self setUpAnimationManagerForTransitionWithTag:3];
}

- (void)reverseTransitionToPreviousBubbleContainerPosition {
    _transitionXDif = 0 - _transitionXDif;
    _transitionYDif = 0 - _transitionYDif;
    [self setUpAnimationManagerForTransitionWithTag:4];
}

- (void)setUpAnimationManagerForTransitionWithTag:(int)tag {
    _disableAnchorReDraw = YES;
    [self disableChildButtons];
    [self disableWiggleForTransition];
    
    NSArray *a = [_mainBubble getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif];
    a = [a arrayByAddingObjectsFromArray:[_anchors getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
    
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:tag andDelegate:self];
    [_animationManager startAnimation];
}

- (void)setTransitionDifsWithBubbleContainerFrame:(CGRect)b {
    Corner opposite = [Styles getOppositeCornerToCorner:[Styles getCornerWithTitleContainerFrame:b]];
    
    CGPoint newPoint = [Styles getExactCornerPointForCorner:opposite];
    CGPoint oldPoint = b.origin;
    
    _transitionXDif = newPoint.x - oldPoint.x;
    _transitionYDif = newPoint.y - oldPoint.y;
}

- (void)disableWiggleForTransition {
    _mainBubble.bubble.disableWiggleForTransition = YES;
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.disableWiggleForTransition = YES;
    }
}

- (void)enableWiggleForTransition {
    _mainBubble.bubble.disableWiggleForTransition = NO;
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.disableWiggleForTransition = NO;
    }
}

@end
