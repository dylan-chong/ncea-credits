//
//  CornerButton.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "CornerButton.h"
#import <QuartzCore/QuartzCore.h>

#define EDGE_INSET_HORIZONTAL 14 * [Styles sizeModifier]
#define EDGE_INSET_TOP 10 * [Styles sizeModifier]
#define EDGE_INSET_BOTTOM 5 * [Styles sizeModifier]

@implementation CornerButton

- (id)initWithColour:(UIColor *)colour text:(NSString *)title corner:(Corner)corner target:(id)target selector:(SEL)selector {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _colour = colour;
        self.buttonCorner = corner;
        
        //Highlight colour and other events
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addTarget:self action:@selector(highlight) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(highlight) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(unhighlight) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(unhighlight) forControlEvents:UIControlEventTouchCancel];
        [self addTarget:self action:@selector(unhighlight) forControlEvents:UIControlEventTouchDragOutside];
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        //Text
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setTitleLabelWithColour:colour andText:title];
        
        //Resize
        [self resizeToFit];
        
        //Border
        [[self layer] setBorderWidth:1.0 * [Styles sizeModifier]];
        [[self layer] setBorderColor:[colour CGColor]];
        [[self layer] setCornerRadius:10.0 * [Styles sizeModifier]];
        
        self.alpha = 0;
    }
    
    return self;
}

- (void)setTitleLabelWithColour:(UIColor *)colour andText:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:colour forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.titleLabel setFont:[Styles captionFont]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    UIEdgeInsets insets = self.contentEdgeInsets;
//    insets.top = EDGE_INSET_TOP;
//    self.contentEdgeInsets = insets;
    self.contentEdgeInsets = UIEdgeInsetsMake(EDGE_INSET_TOP, EDGE_INSET_HORIZONTAL, EDGE_INSET_BOTTOM, EDGE_INSET_HORIZONTAL);
}

- (void)resizeToFit {
    [self sizeToFit];

    [self reposition];
}

- (void)highlight {
    [UIView animateWithDuration:HIGHLIGHT_ANIMATION_TIME animations:^{
        [self setBackgroundColor:_colour];
    }];
}

- (void)unhighlight {
    [UIView animateWithDuration:HIGHLIGHT_ANIMATION_TIME animations:^{
        [self setBackgroundColor:[UIColor whiteColor]];
    }];
}

- (void)reposition {
    CGRect f = self.frame;
    f.origin = [Styles getExactOriginForCorner:_buttonCorner andSize:f.size];
    self.frame = f;
}

- (void)show {
    [self reposition];
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        self.alpha = 0;
    }];
}

@end
