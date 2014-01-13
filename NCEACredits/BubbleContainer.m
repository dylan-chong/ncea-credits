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

- (id)initMainBubble {
    CGRect frame = [Styles mainContainerRect];
    self = [super initWithFrame:frame];
    if (self) {
        _isMainBubbleContainer = YES;
        
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

- (id)initTitleBubbleWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate {
    self = [super initWithFrame:[BubbleContainer getCentreOfMainBubbleWithSize:frame.size]];
    
    if (self) {
        _rectToMoveTo = frame;
        
        _isMainBubbleContainer = NO;
        _bubble = [[Bubble alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:frame] colour:colour iconName:iconName title:title andDelegate:hasDelegate];
        [self addSubview:_bubble];
        [_bubble startWiggle];
        self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
        
        self.backgroundColor = bg;
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

//******************************************** Starting Animation ***********************************************

- (void)startSlidingAnimation {
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:
                         [NSArray arrayWithObjects:
                          [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.x endingPoint:_rectToMoveTo.origin.x tag:X andDelegate:self],
                          [[AnimationObject alloc] initWithStartingPoint:self.frame.origin.y endingPoint:_rectToMoveTo.origin.y tag:Y andDelegate:self],
                          nil] length:[Styles animationSpeed] tag:1 andDelegate:self];
    [_animationManager startAnimation];
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

- (void)animationHasFinished:(int)tag {
    [self.delegate slidingAnimationHasCompleted];
}


- (void)startGrowingAnimationWithAnimationManager:(AnimationManager *)a {
    [_animationManager startAnimation];
}

+ (AnimationManager *)getAnimationManagerForGrowingAnimationWithStartingScaleFactor:(float)factor andDelegate:(id)delegate {
    return [[AnimationManager alloc] initWithAnimationObjects:
            [NSArray arrayWithObjects:[[AnimationObject alloc] initWithStartingPoint:factor endingPoint:1.0 tag:ScaleWidth andDelegate:delegate], nil]
                                                       length:[Styles animationSpeed] tag:2 andDelegate:delegate];
}

- (void)startGrowingMainBubbleAnimation {
    [self startGrowingAnimationWithAnimationManager:_animationManager];
}

//******************************************** Anchors ***********************************************

+ (CGRect)getCentreOfMainBubbleWithSize:(CGSize)size {
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    CGRect m = [Styles mainContainerRect];
    r.origin.x = m.origin.x + ((m.size.width - r.size.width) / 2);
    r.origin.y = m.origin.y + ((m.size.height - r.size.height) / 2);
    return r;
}

- (void)redrawAnchors {
    [self.delegate redrawAnchors];
}

@end
