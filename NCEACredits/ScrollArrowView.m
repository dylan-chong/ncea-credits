//
//  ScrollArrowView.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ScrollArrowView.h"
#import "FlickScroller.h"

@implementation ScrollArrowView

- (id)initWithContainer:(UIView *)container upDirectionInsteadOfDown:(BOOL)isUp delegate:(id<ScrollArrowViewDelegate>)delegate andSizeOrZero:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (self) {
        _isUp = isUp;
        _container = container;
        
        _enabled = NO;
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        [self resetPositionAnimated:NO];
        
        _delegate = delegate;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)tapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Swipe up or down to scroll." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
    [self.delegate showAlertControllerAlert:alert];
}

- (void)resetPositionAnimated:(BOOL)animated {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if ([Styles size:self.frame.size isEqualToSize:CGSizeZero])
        frame.size = CGSizeMake(StandardScrollArrowWidth + (StandardScrollArrowExtraTappingBoxSpace * 2),
                                StandardScrollArrowHeight + (StandardScrollArrowExtraTappingBoxSpace * 2));
    
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
    CGSize containerSize = [FlickScroller getContainerSize:container];
    p.x = (containerSize.width - size.width) / 2;
    
    if (isUp) p.y = StandardScrollArrowSpaceFromEdge + [CurrentAppDelegate statusBarHeight] - StandardScrollArrowExtraTappingBoxSpace;
    else p.y = containerSize.height - size.height - StandardScrollArrowSpaceFromEdge + StandardScrollArrowExtraTappingBoxSpace;
    
    return p;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat sp = StandardScrollArrowExtraTappingBoxSpace;
    
    if (_isUp) {
        CGContextMoveToPoint(c, sp, sp + StandardScrollArrowHeight);
        CGContextAddLineToPoint(c, StandardScrollArrowWidth / 2 + sp, sp);
        CGContextAddLineToPoint(c, StandardScrollArrowWidth + sp, StandardScrollArrowHeight + sp);
    } else {
        CGContextMoveToPoint(c, sp, sp);
        CGContextAddLineToPoint(c, StandardScrollArrowWidth / 2 + sp, StandardScrollArrowHeight + sp);
        CGContextAddLineToPoint(c, StandardScrollArrowWidth + sp, sp);
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
