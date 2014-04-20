//
//  PanScroller.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "PanScroller.h"

@implementation PanScroller

- (id)initWithMax:(double)max currentValue:(double)cv container:(UIView *)container andDelegate:(id)delegate {
    self = [super init];
    
    if (self) {
        _currentValue = cv;
        _max = max;
        
        _containerView = container;
        _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [container addGestureRecognizer:_gesture];
        
        _downArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:NO andSizeOrZero:CGSizeZero];
        _upArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:YES andSizeOrZero:CGSizeZero];
        
        _delegate = delegate;
        [self useNewCurrentValue];
    }
    
    return self;
}

- (void)panned:(UIPanGestureRecognizer *)sender {
    CGPoint t = [sender translationInView:_containerView];
    
    _currentValue = _currentValue - t.y;
    
    [self useNewCurrentValue];
    [sender setTranslation:CGPointZero inView:_containerView];
}
#warning TODO: inertia stuff
- (void)useNewCurrentValue {
    if ([PanScroller getContainerSize:_containerView].height >= _max) {
        _currentValue = 0;
        [_downArrow hide];
        [_upArrow hide];
        
    } else if (_currentValue + [PanScroller getContainerSize:_containerView].height >= _max) {
        _currentValue = _max - [PanScroller getContainerSize:_containerView].height;
        [_downArrow hide];
        [_upArrow show];
        
    } else if (_currentValue <= 0) {
        _currentValue = 0;
        [_downArrow show];
        [_upArrow hide];
        
    } else {
        [_downArrow show];
        [_upArrow show];
    }
    
    [_delegate currentValueChanged:_currentValue];
}

- (void)resetArrowPositionsAndSetNewMax:(double)m {
    [_downArrow resetPositionAnimated:YES];
    [_upArrow resetPositionAnimated:YES];
    
    double p = _currentValue / _max;
    _max = m;
    _currentValue = _max * p;
    
    [self useNewCurrentValue];
}

+ (CGSize)getContainerSize:(UIView *)container {
    CGSize containerSize = container.frame.size;
    
    if ((containerSize.width == [Styles screenHeight] || containerSize.width == [Styles screenWidth]) &&
        (containerSize.width == [Styles screenHeight] || containerSize.width == [Styles screenWidth])) {
        
        containerSize.width = [Styles screenWidth];
        containerSize.height = [Styles screenHeight];
    }
    
    return containerSize;
}

- (void)show {
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        _downArrow.alpha = StandardScrollArrowShowAlpha;
        _upArrow.alpha = StandardScrollArrowShowAlpha;
    } completion:^(BOOL finished) {
        if (finished) {
            _downArrow.enabled = YES;
            _upArrow.enabled = YES;
            [self useNewCurrentValue];
        }
    }];
}

- (void)hide {
    _downArrow.enabled = NO;
    _upArrow.enabled = NO;
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        _downArrow.alpha = 0;
        _upArrow.alpha = 0;
    }];
}

@end
