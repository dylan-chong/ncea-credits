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
    self = [super initWithFrame:frame];
    
    if (self) {
        _isMainBubbleContainer = NO;
        
        _bubble = [[Bubble alloc] initWithFrame:[Styles getBubbleFrameWithContainerFrame:frame] colour:colour iconName:iconName title:title andDelegate:hasDelegate];
        [self addSubview:_bubble];
        [_bubble startWiggle];
        
        self.backgroundColor = bg;
    }
    
    return self;
}

- (CGPoint)getanchorPoint {
    float x = self.center.x + (_bubble.center.x - (self.frame.size.width / 2));
    float y = self.center.y + (_bubble.center.y - (self.frame.size.height / 2));
    return CGPointMake(x, y);
}

- (void)redrawAnchors {
    [self.delegate redrawAnchors];
}

@end
