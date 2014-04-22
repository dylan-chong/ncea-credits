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

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide scrollGetterBlock:(ScrollGetterBlock)scrollGetter andMainBubble:(BubbleContainer *)mainB; {
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = titles.count;
    CGSize size = [Styles editTextBubbleSize];
    __block ScrollGetterBlock scrollGetterBlock = scrollGetter;
    
    for (int a = 0; a < titles.count; a++) {
        PositionCalculationBlock x = ^{
            return [EditTextViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner staggered:NO andScrollDistance:scrollGetterBlock()];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < titles.count; a++) {
        [m addObject:[[EditTextBubbleContainer alloc] initWithPositionCalculatorBlock:blocks[a] frameForStartingPosition:mainB.frame title:titles[a] text:texts[a] placeHolderText:placeholder[a] towardsRightSide:towardsRightSide type:types[a] andDelegate:delegate]];
    }
    
    return m;
}

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner staggered:(BOOL)staggered andScrollDistance:(double)scrollDistance {
    CGPoint difs = [EditTextViewController getXandYDifsWithBubbles:bubbles andSize:size];
    double xDif = difs.x;
    double yDif = difs.y;
    
    double i;
    if (corner == BottomLeft || corner == BottomRight) i = bubbles - index - 1;
    else
        i = index;
    xDif *= i / (bubbles - 1.0);
    yDif *= i / (bubbles - 1.0);
    
    //------------------------------ Which corner stuff ------------------------------
    double x, y;
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
    
    //------------------------------ Scrolling ------------------------------
    double scrollX, scrollY, angle;
    
    angle = atan(yDif/xDif); //Note: radians
    scrollX = sin(scrollDistance * angle);
    scrollY = cos(scrollDistance * angle);
    
    
    CGPoint origin = [EditTextViewController getCorner:corner withSize:size];
    return CGRectMake(origin.x + x + scrollX, origin.y + y + scrollY, size.width, size.height);
}

+ (CGPoint)getXandYDifsWithBubbles:(NSUInteger)bubbles andSize:(CGSize)size {
    CGPoint startP = [EditTextViewController getCorner:TopLeft withSize:size];
    CGPoint endP = [EditTextViewController getCorner:BottomRight withSize:size];
    
    double xDif = startP.x - endP.x;
    //Increase size for scrolling
    double yDif = endP.y - startP.y;
    if (bubbles > EditTextScrollingNumberOfBubbles) {
        double diag = sqrt(pow(xDif, 2) + pow(yDif, 2));
        double ratio = [EditTextViewController getRatioToMultiplyDifsForScrollingWithBubbles:bubbles currentDiagonalDistance:diag];
        xDif *= ratio;
        yDif *= ratio;
    }
    
    if (xDif < 0) xDif *= -1;
    if (yDif < 0) yDif *= -1;
    
    return CGPointMake(xDif, yDif);
}

//+ (CGRect)getFrameWithScrollingAppliedAtIndex:(NSUInteger)index outOfBubbles:(NSUInteger)bubbles frame:(CGRect)frame fromCorner:(Corner)corner andSize:(CGSize)size {
//
//    CGPoint difs = [EditTextViewController getXandYDifsWithBubbles:bubbles andSize:size];
//
//    if (corner == TopLeft) {
//        difs.x *= -1;
//    } else if (corner == TopRight) {
//    } else if (corner == BottomLeft) {
//        difs.x *= -1;
//        difs.y *= -1;
//    } else {
//        difs.y *= -1;
//    }
//
//    double diagLength = sqrt(pow(difs.x, 2) + pow(difs.y, 2));
//
//    double angleFrom90PointingAlongDif =
//}

+ (double)getRatioToMultiplyDifsForScrollingWithBubbles:(NSInteger)bubbles currentDiagonalDistance:(double)curDistance {
    double percentagePerBubble = 1.0 / EditTextScrollingNumberOfBubbles;
    percentagePerBubble += EditTextScrollingExtraDiagonalFractionalSpaceBetweenBubbles;
    
    return bubbles * percentagePerBubble;
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

//*
//****
//*********
//****************
//*************************
//************************************    EditTextScreen    ************************************
//*************************
//****************
//*********
//****
//*

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
        
        Corner c = [Styles getCornerForPoint:self.mainBubble.center];
        if (c == BottomLeft || c == BottomRight) {
            [self scrollToPositionDecimal:1.0];
        }
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
    _lastCurrentScrollValue = value;
}

- (double)getScrollerValue {
    if (!_lastCurrentScrollValue) _lastCurrentScrollValue = 0;
    return _lastCurrentScrollValue;
}

- (void)scrollToPositionDecimal:(double)decimal {
    [_scroller scrollToDecimal:decimal];
}

@end
