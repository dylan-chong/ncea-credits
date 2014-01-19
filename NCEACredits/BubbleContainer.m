//
//  BubbleContainer.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleContainer.h"
#import "Styles.h"

#if 1
#define bg [UIColor clearColor]
#else
#define bg [UIColor lightGrayColor]
#endif

@implementation BubbleContainer

- (id)initMainBubbleWithFrameCalculator:(PositionCalculationBlock)b {
    CGRect frame = b();
    self = [super initWithFrame:frame];
    if (self) {
        _isMainBubbleContainer = YES;
        _calulatePosition = b;
        
        //create bubble in centre
        _bubble = [[BubbleMain alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:frame]];
        _bubble.usesDelegateToCallRedrawAnchors = YES;
        _bubble.delegate = self;
        [self addSubview:_bubble];
        [_bubble startWiggle];
        
        self.backgroundColor = bg;
        
    }
    return self;
}

- (id)initTitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate {
    CGRect f = frame();
    self = [super initWithFrame:[BubbleContainer getCentreOfMainBubbleWithSize:f.size]];
    
    if (self) {
        _rectToMoveTo = f;
        _calulatePosition = frame;
        
        _isMainBubbleContainer = NO;
        _bubble = [[Bubble alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:f] colour:colour iconName:iconName title:title andDelegate:hasDelegate];
        [self addSubview:_bubble];
        [_bubble startWiggle];
        self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
        
        self.backgroundColor = bg;
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

//******************************************** Starting Animation ***********************************************

- (AnimationManager *)getAnimationManagerForMainBubbleGrowth {
    return [[AnimationManager alloc] initWithAnimationObjects:[[NSArray alloc] initWithObjects:
                                                               [[AnimationObject alloc] initWithStartingPoint:[Styles mainBubbleStartingScaleFactor] endingPoint:1.0 tag:ScaleWidth andDelegate:self], nil]
                                                       length:[Styles animationSpeed] tag:0 andDelegate:nil];
}

- (void)startGrowingMainBubbleAnimation {
    [_animationManager startAnimation];
}

- (NSArray *)getAnimationObjectsForSlidingAnimation {
    _rectToMoveTo = _calulatePosition();
    return [[NSArray alloc] initWithObjects:
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.x endingPoint:_rectToMoveTo.origin.x tag:X andDelegate:self],
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.y endingPoint:_rectToMoveTo.origin.y tag:Y andDelegate:self],
            nil];
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    if (tag == X || tag == Y) {
        CGRect f = self.frame;
        if (tag == X) {
            f.origin.x = value;
        } else { // == Y
            f.origin.y = value;
        }
        self.frame = f;
    } else if (tag == ScaleWidth || tag == ScaleHeight) {
        _bubble.transform = CGAffineTransformMakeScale(value, value);
    }
}

//******************************************** Anchors ***********************************************

+ (CGRect)getCentreOfMainBubbleWithSize:(CGSize)size {
    //For starting sliding animation
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    CGRect m = [Styles mainContainerRect];
    r.origin.x = m.origin.x + ((m.size.width - r.size.width) / 2);
    r.origin.y = m.origin.y + ((m.size.height - r.size.height) / 2);
    return r;
}

- (void)redrawAnchors {
    [self.delegate redrawAnchors];
}

//****************************************** Transition ********************************************

- (NSArray *)getAnimationObjectsForXDif:(float)xDif andYDif:(float)yDif {
    return [[NSArray alloc] initWithObjects:
            
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.x endingPoint:self.frame.origin.x + xDif tag:X andDelegate:self],
            [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.y endingPoint:self.frame.origin.y + yDif tag:Y andDelegate:self],
            
            nil];
}

@end
