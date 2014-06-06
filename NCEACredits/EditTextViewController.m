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
#import "FlickScroller.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide flickScroller:(FlickScroller *)flickScroller andMainBubble:(BubbleContainer *)mainB {
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = titles.count;
    CGSize size = [Styles editTextBubbleSize];
    __block FlickScroller *flickS = flickScroller;
    
    for (int a = 0; a < titles.count; a++) {
        PositionCalculationBlock x = ^{
            return [EditTextViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner andFlickScroller:flickS];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < titles.count; a++) {
        [m addObject:[[EditTextBubbleContainer alloc] initWithPositionCalculatorBlock:blocks[a] frameForStartingPosition:mainB.frame title:titles[a] text:texts[a] placeHolderText:placeholder[a] towardsRightSide:towardsRightSide type:types[a] andDelegate:delegate]];
    }
    
    return m;
}

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andFlickScroller:(FlickScroller *)flickScroller  {
    
    CGPoint difs = [EditTextViewController getXandYDifsWithBubbles:bubbles andSize:size];
    double xDif = difs.x;
    double yDif = difs.y;
    
    //Calculate position on position in page
    NSUInteger perPage = [FlickScroller getNumberOfItemsPerPage];
    NSUInteger indexOnPage = index;
    while (index > perPage) {
        index -= perPage;
    }
    
    //Shift for page
    int xPageMod, yPageMod;
    yPageMod = -1; //Negative because shift, same with negative
    
    double x, y;
    CGPoint origin;
    if (corner == BottomLeft || corner == BottomRight)
        origin = [EditTextViewController getCorner:[Styles getOppositeCornerToCorner:corner] withSize:size];
    else
        origin = [EditTextViewController getCorner:corner withSize:size];
    
    if (corner == TopLeft || corner == BottomRight) {
        x = -xDif;
        y = yDif;
        
        xPageMod = 1;
    } else {//(corner == TopRight || corner == BottomLeft) {
        x = xDif;
        y = yDif;
        
        xPageMod = -1;
    }
    
    x *= indexOnPage / (perPage - 1.0);
    y *= indexOnPage / (perPage - 1.0);
    
    int whichPage = [FlickScroller getPageForIndex:index andNumberOfItems:bubbles];
    
    int currentPage = flickScroller.currentPageIndex;
    int xPageMove = (currentPage - whichPage) * xPageMod * [Styles screenWidth];
    int yPageMove = (currentPage - whichPage) * yPageMod * [Styles screenHeight];
    
    return CGRectMake(origin.x + x + xPageMove, origin.y + y + yPageMove, size.width, size.height);
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
    
    if (!_flickScroller) {
        _flickScroller = [self getFlickScroller];
    }
}

- (FlickScroller *)getFlickScroller {
    return [[FlickScroller alloc] initWithItems:self.childBubbles.count container:self.view andDelegate:self];
    //*
    //****
    //*********
    //****************
    //*************************
    //************************************************************************
    //*************************
    //****************
    //*********
    //****
    //*
#warning TODO: pages = 0???, paging not working
    //*
    //****
    //*********
    //****************
    //*************************
    //************************************************************************
    //*************************
    //****************
    //*********
    //****
    //*
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_editScreen resetFrameWithAnimation:YES];
}

- (void)startReturnSlideAnimation {
    [super startReturnSlideAnimation];
}

- (void)pageFlicked:(NSUInteger)newCurrentPage {
    [self repositionBubbles];
}

@end
