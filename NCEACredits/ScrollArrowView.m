//
//  ScrollArrowView.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ScrollArrowView.h"
#import "PanScroller.h"

@implementation ScrollArrowView

- (id)initWithContainer:(UIView *)container upDirectionInsteadOfDown:(BOOL)isUp andSizeOrZero:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (self) {
        _isUp = isUp;
        _container = container;
        [_container addSubview:self];
        
        _enabled = NO;
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        [self resetPositionAnimated:NO];
    }
    
    return self;
}

- (void)resetPositionAnimated:(BOOL)animated {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if ([Styles size:self.frame.size isEqualToSize:CGSizeZero])
        frame.size = CGSizeMake(StandardScrollArrowWidth * [Styles sizeModifier], StandardScrollArrowHeight * [Styles sizeModifier]);
    
    frame.origin = [ScrollArrowView getArrowPositionInContainer:_container size:frame.size andIsUp:_isUp];
    
    if (animated) {
        [UIView animateWithDuration:[Styles animationSpeed] animations:^{
            self.frame = frame;
        }];
    } else self.frame = frame;
}

+ (CGPoint)getArrowPositionInContainer:(UIView *)container size:(CGSize)size andIsUp:(BOOL)isUp {
    CGPoint p = CGPointZero;
    
    //if container is self.view of controller, use Styles screen height and widths
    CGSize containerSize = [PanScroller getContainerSize:container];
    p.x = (containerSize.width - size.width) / 2;
    
    if (isUp) p.y = StandardScrollArrowSpaceFromEdge;
    else p.y = containerSize.height - size.height - StandardScrollArrowSpaceFromEdge;
    
    return p;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    if (_isUp) {
        CGContextMoveToPoint(c, 0, self.bounds.size.height);
        CGContextAddLineToPoint(c, self.bounds.size.width / 2, 0);
        CGContextAddLineToPoint(c, self.bounds.size.width, self.bounds.size.height);
    } else {
        CGContextMoveToPoint(c, 0, 0);
        CGContextAddLineToPoint(c, self.bounds.size.width / 2,  self.bounds.size.height);
        CGContextAddLineToPoint(c, self.bounds.size.width, 0);
    }
    
    CGContextClosePath(c);
    [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
    CGContextFillPath(c);
}

- (void)show {
    if (self.alpha != StandardScrollArrowShowAlpha && _enabled) {
        [UIView animateWithDuration:[Styles animationSpeed] animations:^{
            self.alpha = StandardScrollArrowShowAlpha;
        }];
    }
}

- (void)hide {
    if (self.alpha != 0 && _enabled) {
        [UIView animateWithDuration:[Styles animationSpeed] animations:^{
            self.alpha = 0;
        }];
    }
}

@end
