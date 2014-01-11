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

    _anchors = [[AnchorView alloc] initWithStartingPoint:[_mainBubble getanchorPoint] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
    [self addSubview:_anchors];
    [self sendSubviewToBack:_anchors];
    [self bringSubviewToFront:_mainBubble];
}

- (void)redrawAnchors {
    [_anchors setStartingPoint:[_mainBubble getanchorPoint] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
    [_anchors setNeedsDisplay];
}

- (NSArray *)getAnchorPointsFromChildBubbles {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        [points addObject:[NSValue valueWithCGPoint:[b getanchorPoint]]];
    }
    
    return points;
}


@end
