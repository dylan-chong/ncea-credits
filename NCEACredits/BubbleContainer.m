//
//  BubbleContainer.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleContainer.h"
#import "Styles.h"
#import "BubbleMain.h"
#import "AnimationManager.h"


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
        _bubbleType = MainBubble;
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

- (id)initTitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title frameBubbleForStartingPosition:(CGRect)startingFrame andDelegate:(BOOL)hasDelegate {
    CGRect f = frame();
    if (![Styles rect:startingFrame isEqualToRect:CGRectZero]) {
        self = [super initWithFrame:[Styles getRectCentreOfFrame:startingFrame withSize:f.size]];
    } else {
        self = [super initWithFrame:f];
    }
    
    if (self) {
        _rectToMoveTo = f;
        _calulatePosition = frame;
        _imageName = iconName;
        _bubbleType = TitleBubble;
        _colour = colour;
        
        _bubble = [[Bubble alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:f] colour:colour iconName:iconName title:title andDelegate:hasDelegate];
        if (hasDelegate) _bubble.delegate = self;
        [self addSubview:_bubble];
        [_bubble startWiggle];
        if (![Styles rect:startingFrame isEqualToRect:CGRectZero]) {
            self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
            self.userInteractionEnabled = NO;
        } else {
            self.userInteractionEnabled = YES;
        }
        
        self.backgroundColor = bg;
    }
    
    return self;
}

- (id)initSubtitleBubbleWithFrameCalculator:(PositionCalculationBlock)frame colour:(UIColor *)colour title:(NSString *)title frameBubbleForStartingPosition:(CGRect)startingFrame andDelegate:(BOOL)hasDelegate {
    CGRect f = frame();
    if (![Styles rect:startingFrame isEqualToRect:CGRectZero]) {
        self = [super initWithFrame:[Styles getRectCentreOfFrame:startingFrame withSize:f.size]];
    } else {
        self = [super initWithFrame:f];
    }
    
    if (self) {
        _rectToMoveTo = f;
        _calulatePosition = frame;
        _bubbleType = SubtitleBubble;
        _colour = colour;
        
        _bubble = [[Bubble alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:self.frame] colour:colour title:title andDelegate:hasDelegate];
        if (hasDelegate) _bubble.delegate = self;
        [self addSubview:_bubble];
        [_bubble startWiggle];
        
        self.backgroundColor = bg;
        
        if (![Styles rect:startingFrame isEqualToRect:CGRectZero]) {
            self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
            self.userInteractionEnabled = NO;
        } else {
            self.userInteractionEnabled = YES;
        }
    }
    
    return self;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Starting Animation    ************************************
//*************************
//****************
//*********
//****
//*

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

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Anchors    ************************************
//*************************
//****************
//*********
//****
//*

- (void)redrawAnchors {
    [self.delegate redrawAnchors];
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

@end
