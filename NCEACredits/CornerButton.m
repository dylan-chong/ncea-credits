//
//  CornerButton.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "CornerButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CornerButton

+ (CornerButton *)cornerButtonWithTitle:(NSString *)title width:(CGFloat)width corner:(Corner)corner colour:(UIColor *)colour target:(id)target selector:(SEL)selector {
    CGRect f = CGRectZero;
    f.size = CGSizeMake(width * [Styles sizeModifier], 40 * [Styles sizeModifier]);
    f.origin = [Styles getExactOriginForCorner:corner andSize:f.size];
    f.origin.y += [ApplicationDelegate getStatusBarHeight];
    
    CornerButton *cornerB = [[CornerButton alloc] initWithFrame:f andColour:colour];
    cornerB.buttonCorner = corner;
    //Highlight colour and other events
    [cornerB setBackgroundColor:[UIColor whiteColor]];
    [cornerB addTarget:cornerB action:@selector(highlight) forControlEvents:UIControlEventTouchDown];
    [cornerB addTarget:cornerB action:@selector(highlight) forControlEvents:UIControlEventTouchDragInside];
    [cornerB addTarget:cornerB action:@selector(unhighlight) forControlEvents:UIControlEventTouchUpInside];
    [cornerB addTarget:cornerB action:@selector(unhighlight) forControlEvents:UIControlEventTouchCancel];
    [cornerB addTarget:cornerB action:@selector(unhighlight) forControlEvents:UIControlEventTouchDragOutside];
    [cornerB addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [cornerB setTitle:title forState:UIControlStateNormal];
    [cornerB setTitleColor:colour forState:UIControlStateNormal];
    [cornerB setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cornerB.titleLabel setFont:[UIFont systemFontOfSize:20 * [Styles sizeModifier]]];
    cornerB.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [[cornerB layer] setBorderWidth:1.0 * [Styles sizeModifier]];
    [[cornerB layer] setBorderColor:[colour CGColor]];
    [[cornerB layer] setCornerRadius:10.0 * [Styles sizeModifier]];
    
    return cornerB;
}

- (id)initWithFrame:(CGRect)frame andColour:(UIColor *)colour {
    self = [super initWithFrame:frame];
    
    if (self) {
        _colour = colour;
    }
    
    return self;
}

- (void)highlight {
    [UIView animateWithDuration:0.1 animations:^{
        [self setBackgroundColor:_colour];
    }];
}

- (void)unhighlight {
    [UIView animateWithDuration:0.1 animations:^{
        [self setBackgroundColor:[UIColor whiteColor]];
    }];
}

- (void)reposition {
    CGRect f = self.frame;
    f.origin = [Styles getExactOriginForCorner:_buttonCorner andSize:f.size];
    f.origin.y += [ApplicationDelegate getStatusBarHeight];
    self.frame = f;
}

@end
