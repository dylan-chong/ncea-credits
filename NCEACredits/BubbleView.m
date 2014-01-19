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

- (void)repositionBubbles {
    _anchors.frame = CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight]);
    [self redrawAnchors];
    
    if (_isDoingAnimation) {
        NSMutableArray *m = [[NSMutableArray alloc] init];
        CGRect r = _mainBubble.calulatePosition();
        [m addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.x endingPoint:r.origin.x tag:X andDelegate:_mainBubble]];
        [m addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.y endingPoint:r.origin.y tag:Y andDelegate:_mainBubble]];
        
    } else {
        [self animateRepositionObjects];
    }
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
        [self reverseTransitionToPreviousBubbleContainerPosition];
    } else if (tag == 4) {
        //transition reverse
        [self enableChildButtons];
        _isDoingAnimation = NO;
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
    [self disableChildButtons];
    _isDoingAnimation = YES;
    
    NSArray *a = [_mainBubble getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif];
    
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:3 andDelegate:self];
    [_animationManager startAnimation];
}

- (void)reverseTransitionToPreviousBubbleContainerPosition {
    [self animateRepositionObjects];
}

- (void)animateRepositionObjects {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    CGRect pos = _mainBubble.calulatePosition();
    [objects addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.x endingPoint:pos.origin.x tag:X andDelegate:_mainBubble]];
    [objects addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.y endingPoint:pos.origin.y tag:Y andDelegate:_mainBubble]];
    
    for (BubbleContainer *b in _childBubbles) {
        pos = b.calulatePosition();
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.x endingPoint:pos.origin.x tag:X andDelegate:b]];
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.y endingPoint:pos.origin.y tag:Y andDelegate:b]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:objects length:[Styles animationSpeed] tag:4 andDelegate:self];
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

- (void)enableWiggleAfterTransition {
    _mainBubble.bubble.disableWiggleForTransition = NO;
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.disableWiggleForTransition = NO;
    }
}

- (void)fromTransitionWillStartWithButton:(BubbleContainer *)container {
    
}

@end
