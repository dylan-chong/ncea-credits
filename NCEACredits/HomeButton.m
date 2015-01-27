//
//  HomeButton.m
//  NCEACredits
//
//  Created by Dylan Chong on 26/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "HomeButton.h"
#import "SimpleSelectionViewController.h"

#define VERTICAL_SPACE_FROM_MAIN_BUBBLE 10 * [Styles sizeModifier]
#define WIDTH_AND_HEIGHT 50 * [Styles sizeModifier]
#define HOME_BUTTON_PRESSED_SELECTOR @selector(homeButtonPressed)

@implementation HomeButton

- (id)initWithSimpleVC:(SimpleSelectionViewController *)simpleVC {
    self = [super initWithColour:simpleVC.mainBubble.colour text:@"" corner:[Styles getCornerForPoint:simpleVC.mainBubble.center] target:simpleVC selector:HOME_BUTTON_PRESSED_SELECTOR];
    
    if (self) {
        UIImage *image = [UIImage imageNamed:@"House"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setSimpleVC:simpleVC];
        
        [self resizeToFit];
        [self reposition];
    }
    
    return self;
}

- (id)initWithColour:(UIColor *)colour text:(NSString *)title corner:(Corner)corner target:(id)target selector:(SEL)selector {
    NSAssert(NO, @"Use -HomeButton initWithSimple...");
    return nil;
}

- (void)setSimpleVC:(SimpleSelectionViewController *)simpleVC {
    UIColor *c = simpleVC.mainBubble.colour;
    self.colour = c;
    self.tintColor = c;
    self.layer.borderColor = [c CGColor];
    
    if (_simpleVC) {
        if (_simpleVC != simpleVC) {
            //remove old target, add new
            [self removeTarget:_simpleVC action:HOME_BUTTON_PRESSED_SELECTOR forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:simpleVC action:HOME_BUTTON_PRESSED_SELECTOR forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        //already has added target on initialisation
    }
    
    _simpleVC = simpleVC;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

- (void)setTitleLabelWithColour:(UIColor *)colour andText:(NSString *)title {
    //do nothing - override
}

- (void)resizeToFit {
    self.frame = CGRectMake(0, 0, WIDTH_AND_HEIGHT, WIDTH_AND_HEIGHT);
}

- (void)reposition {
    Corner mainBubbleCorner = [Styles getCornerForPoint:self.simpleVC.mainBubble.center];
    CGRect mainBubbleFrame = self.simpleVC.mainBubble.frame;
    mainBubbleFrame.origin = [Styles getExactOriginForCorner:mainBubbleCorner andSize:mainBubbleFrame.size];
    
    CGRect oldFrame = self.frame;
    CGRect newFrame;
    newFrame.size = oldFrame.size;
    
    CGFloat gapBetweenBubbleContainerEdgeAndBubble = (1 - BUBBLE_TO_BUBBLE_CONTAINER_SIZE_RATIO) / 2 * mainBubbleFrame.size.width;
    
    //x
    if ([Styles cornerIsLeft:mainBubbleCorner]) {
        //left
        newFrame.origin.x = mainBubbleFrame.origin.x;
        newFrame.origin.x += gapBetweenBubbleContainerEdgeAndBubble;
    } else {
        //right
        newFrame.origin.x = mainBubbleFrame.origin.x + mainBubbleFrame.size.width - oldFrame.size.width;
        newFrame.origin.x -= gapBetweenBubbleContainerEdgeAndBubble;
    }
    
    //y
    if ([Styles cornerIsTop:mainBubbleCorner]) {
        //top
        newFrame.origin.y = mainBubbleFrame.origin.y + mainBubbleFrame.size.height + VERTICAL_SPACE_FROM_MAIN_BUBBLE;
    } else {
        //bottom
        newFrame.origin.y = mainBubbleFrame.origin.y - VERTICAL_SPACE_FROM_MAIN_BUBBLE - oldFrame.size.height;
    }
    
    self.frame = newFrame;
}

- (void)highlight {
    [super highlight];
    [UIView animateWithDuration:HIGHLIGHT_ANIMATION_TIME animations:^{
        self.tintColor = [UIColor whiteColor];
    }];
}

- (void)unhighlight {
    [super unhighlight];
    [UIView animateWithDuration:HIGHLIGHT_ANIMATION_TIME animations:^{
        self.tintColor = self.colour;
    }];
}

@end
