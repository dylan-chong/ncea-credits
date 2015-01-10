//
//  ChangeColourSetColourViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "ChangeColourSetColourViewController.h"

#define CORNER_RADIUS 8.0 * [Styles sizeModifier]

//Must be 2 out of 3 - n per row, gap size, width
//#define COLOURS_PER_ROW 4
#define COLOUR_WIDTH 60 //* [Styles sizeModifier]
#define GAP_SIZE 30 * [Styles sizeModifier]


@interface ChangeColourSetColourViewController ()

@end

@implementation ChangeColourSetColourViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *colours = [Styles getSortedDefaultColours];
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (UIColor *colour in colours) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.layer setCornerRadius:CORNER_RADIUS];
        button.backgroundColor = colour;
        [button addTarget:self action:@selector(colourWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 0;
        
        [_colourView addSubview:button];
        [buttons addObject:button];
    }

    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        for (UIButton *b in buttons) {
            b.alpha = 1.0;
        }
    }];
    
    _colourButtons = buttons;
    
    [ChangeColourSetColourViewController resetButtonPositions:buttons inViewFrame:self.view.frame];
}

- (void)colourWasPressed:(UIButton *)sender {
    UIColor *c = sender.backgroundColor;
    [self.delegate setColourVCWillCloseWithSelectedColour:c andSubject:self.navigationItem.title];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        [ChangeColourSetColourViewController resetButtonPositions:_colourButtons inViewFrame:CGRectMake(0, 0, size.width, size.height)];
    }];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Positioning    ************************************
//*************************
//****************
//*********
//****
//*

+ (CGFloat)getWidthInFrame:(CGRect)viewFrame {
    return COLOUR_WIDTH;
//    return (viewFrame.size.width - (GAP_SIZE * (COLOURS_PER_ROW + 1))) / COLOURS_PER_ROW;
}

+ (NSInteger)getNumberPerRowInFrame:(CGRect)viewFrame {
    CGFloat width = [ChangeColourSetColourViewController getWidthInFrame:viewFrame];
    return floor((viewFrame.size.width - GAP_SIZE) / (width + GAP_SIZE));
}

+ (void)resetButtonPositions:(NSArray *)buttons inViewFrame:(CGRect)viewFrame {
    CGFloat widthHeight = [ChangeColourSetColourViewController getWidthInFrame:viewFrame];
    NSInteger numberPerRow = [ChangeColourSetColourViewController getNumberPerRowInFrame:viewFrame];
    
    for (int a = 0; a < buttons.count; a++) {
        ((UIButton *)buttons[a]).frame = [ChangeColourSetColourViewController getFrameOfButtonNumber:a inViewFrame:viewFrame withButtonWidthHeight:widthHeight numberPerRow:numberPerRow];
    }
}

+ (CGRect)getFrameOfButtonNumber:(NSInteger)indexInArray inViewFrame:(CGRect)viewFrame withButtonWidthHeight:(CGFloat)widthHeight numberPerRow:(NSInteger)numberPerRow {
    CGRect frame;
    frame.size = CGSizeMake(widthHeight, widthHeight);
    
    //If width and gap are predefined, adjust gap to fit exactly into the width
    CGFloat gap;
    if (GAP_SIZE * (numberPerRow + 1) == round(viewFrame.size.width))
        gap = GAP_SIZE;
    else
        gap = (viewFrame.size.width - (numberPerRow * widthHeight)) / (numberPerRow + 1);
    
    NSInteger row = floor(indexInArray / numberPerRow); //starts at 0
    NSInteger col = indexInArray % numberPerRow; //starts at 0 also
    
    frame.origin.x = gap * (col + 1.0) + (widthHeight * col);
    frame.origin.y = gap * (row + 1.0) + (widthHeight * row);
    
    return frame;
}

@end
