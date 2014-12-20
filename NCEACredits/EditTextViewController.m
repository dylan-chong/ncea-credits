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
#import "EditTextScreenItemData.h"

@interface EditTextViewController ()

@end

@implementation EditTextViewController

+ (NSArray *)getEditBubblesWithEditTextScreenItemDataArray:(NSArray *)itemData delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide flickScroller:(FlickScroller *)flickScroller andMainBubble:(BubbleContainer *)mainB {
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = itemData.count;
    CGSize size = [Styles editTextBubbleSize];
    __block FlickScroller *flickS = flickScroller;
    
    for (int a = 0; a < count; a++) {
        PositionCalculationBlock x = ^{
            return [EditTextViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner andFlickScroller:flickS];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < count; a++) {
        [m addObject:[[EditTextBubbleContainer alloc] initWithPositionCalculatorBlock:blocks[a] frameForStartingPosition:mainB.frame itemData:itemData[a] towardsRightSide:towardsRightSide andDelegate:delegate]];
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
    while (indexOnPage > perPage - 1) {
        indexOnPage -= perPage;
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
    
    if (bubbles > perPage) {
        x *= indexOnPage / (perPage - 1.0);
        y *= indexOnPage / (perPage - 1.0);
    } else {
        x *= indexOnPage / (bubbles - 1.0);
        y *= indexOnPage / (bubbles - 1.0);
    }
    
    NSInteger whichPage = [FlickScroller getPageForIndex:index andNumberOfItems:bubbles];
    
    NSInteger thisItemsPage = [flickScroller getCurrentPageIndex];
    CGSize screen = [ApplicationDelegate getScreenSize];
    
    NSInteger xPageMove = (thisItemsPage - whichPage) * xPageMod * screen.width;
    NSInteger yPageMove = (thisItemsPage - whichPage) * yPageMod * screen.height;
//    For debugging pages
//    if (index == 0) NSLog(@"---------------------------");
//    NSLog(@"Index: %i, WhichPage: %i, ThisPage: %i", index, whichPage, thisItemsPage);
    
    return CGRectMake(origin.x + x + xPageMove, origin.y + y + yPageMove, size.width, size.height);
}

+ (CGPoint)getXandYDifsWithBubbles:(NSUInteger)bubbles andSize:(CGSize)size {
    CGPoint startP = [EditTextViewController getCorner:TopLeft withSize:size];
    CGPoint endP = [EditTextViewController getCorner:BottomRight withSize:size];
    
    double xDif = startP.x - endP.x;
    double yDif = endP.y - startP.y;
    
    if (xDif < 0) xDif *= -1;
    if (yDif < 0) yDif *= -1;
    
    yDif -= 15;
    
    return CGPointMake(xDif, yDif);
}

+ (CGPoint)getCorner:(Corner)c withSize:(CGSize)size {
    CGPoint origin;
    CGSize screen = [ApplicationDelegate getScreenSize];
    
    float space = [Styles spaceFromEdgeOfScreen] * 2;
    if (c == TopLeft) {
        origin.x = screen.width - space - (size.width / 2);
        origin.y = space;
    } else if (c == TopRight) {
        origin.x = space;
        origin.y = space;
    } else if (c == BottomLeft) {
        origin.x = screen.width - space - (size.width / 2);
        origin.y = screen.height - space - (size.height / 2);
    } else {
        origin.x = space;
        origin.y = screen.height - space - (size.height / 2);
    }
    
    return origin;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    EditTextScreen    ************************************
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
#pragma mark - ***************************    Scroller Stuff    ************************************
//*************************
//****************
//*********
//****
//*

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self makeFlickScroller];
}

- (void)makeFlickScroller {
    if (!_flickScroller) {
        _flickScroller = [[FlickScroller alloc] initWithItems:self.childBubbles.count container:self.view andDelegate:self];
        [_flickScroller show];
    }
}

- (FlickScroller *)getFlickScroller {
    if (!_flickScroller) [self makeFlickScroller];
    return _flickScroller;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSUInteger pages = [FlickScroller getPagesForNumberOfItems:_flickScroller.items];
    if (_flickScroller.currentPageIndex > pages - 1)
        _flickScroller.currentPageIndex = pages - 1;
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_editScreen resetFrameWithAnimation:YES];
    
    [_flickScroller resetArrowPositions];
}

- (void)startReturnSlideAnimation {
    [super startReturnSlideAnimation];
}

- (void)pageFlicked {
    [self repositionBubbles];
}

- (void)repositionBubbles {
    [super repositionBubbles];
    [_flickScroller resetArrowPositions];
}

@end
