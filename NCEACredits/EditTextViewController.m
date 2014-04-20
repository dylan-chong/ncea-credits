//
//  EditTextViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextViewController.h"
#import "AddViewController.h"
#import "EditTextBubble.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide andMainBubble:(BubbleContainer *)mainB {
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = titles.count;
    CGSize size = [Styles editTextBubbleSize];
    for (int a = 0; a < titles.count; a++) {
        PositionCalculationBlock x = ^{
            return [EditTextViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner andStaggered:NO];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < titles.count; a++) {
        [m addObject:[[EditTextBubbleContainer alloc] initWithPositionCalculatorBlock:blocks[a] frameForStartingPosition:mainB.frame title:titles[a] text:texts[a] placeHolderText:placeholder[a] towardsRightSide:towardsRightSide type:types[a] andDelegate:delegate]];
    }
    
    return m;
}

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered {
    
    CGPoint startP = [EditTextViewController getCorner:corner withSize:size];
    CGPoint endP = [EditTextViewController getCorner:[Styles getOppositeCornerToCorner:corner] withSize:size];
    double xDif = startP.x - endP.x;
    //Scrolling
    double yDif = endP.y - startP.y;
    if (bubbles < EditTextScrollingNumberOfBubbles) {
        double yDif = EditTextScrollingNumberOfBubbles *
        ([Styles editTextBubbleSize].height +  EditTextScrollingSpaceBetweenBubbles);
    }
    
    if (xDif < 0) xDif *= -1;
    if (yDif < 0) yDif *= -1;
    
    double i;
    if (corner == BottomLeft || corner == BottomRight) i = bubbles - index - 1;
    else i = index;
    xDif *= i / (bubbles - 1.0);
    yDif *= i / (bubbles - 1.0);
    
    double x, y;
    CGPoint origin = [EditTextViewController getCorner:corner withSize:size];
    if (corner == TopLeft) {
        x = -xDif;
        y = yDif;
    } else if (corner == TopRight) {
        x = xDif;
        y = yDif;
    } else if (corner == BottomLeft) {
        x = -xDif;
        y = -yDif;
    } else {
        x = xDif;
        y = -yDif;
    }
    
    return CGRectMake(origin.x + x, origin.y + y, size.width, size.height);
}

+ (CGPoint)getCorner:(Corner)c withSize:(CGSize)size {
    CGPoint origin;
    
    float space = [Styles spaceFromEdgeOfScreen] * 2;
    if (c == TopLeft) {
        origin.x = [Styles screenWidth] - space - (size.width / 2);
        origin.y = space;
    } else if (c == TopRight) {
        origin.x = space;
        origin.y = space;
    } else if (c == BottomLeft) {
        origin.x = [Styles screenWidth] - space - (size.width / 2);
        origin.y = [Styles screenHeight] - space - (size.height / 2);
    } else {
        origin.x = space;
        origin.y = [Styles screenHeight] - space - (size.height / 2);
    }
    
    return origin;
}

- (void)editTheTextView:(EditTextBubbleContainer *)editTextView {
    _editScreen = [[EditTextEditScreen alloc] initWithEditTextBubbleContainerToEdit:editTextView];
    
    [self.view addSubview:_editScreen];
    [self.view bringSubviewToFront:_editScreen];
    [_editScreen show];
}

- (void)finishedEditing {
    [_editScreen removeFromSuperview];
}

//*
//****
//*********
//****************
//*************************
//************************************    Scroller Stuff    ************************************
//*************************
//****************
//*********
//****
//*

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_scroller) {
        _scroller = [[PanScroller alloc] initWithMax:[Styles screenHeight] * 2 currentValue:0 container:self.view andDelegate:self];
        [_scroller show];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_editScreen resetFrameWithAnimation:YES];
    [_scroller resetArrowPositionsAndSetNewMax:[Styles screenHeight]];
}

- (void)startReturnSlideAnimation {
    [_scroller hide];
    [super startReturnSlideAnimation];
}

- (void)currentValueChanged:(double)value {
    NSLog(@"%f", value);
}

@end
