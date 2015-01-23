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

- (NSString *)GET_CHILD_MAIN_BUBBLE_OVERRIDE_TITLE {
    return @"Tap to Save";
}

- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container {
    [super setMainBubbleSimilarToBubble:container];
}

+ (NSArray *)getEditBubblesWithEditTextScreenItemDataArray:(NSArray *)itemData delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide flickScroller:(FlickScroller *)flickScroller corner:(Corner)cornerOfMainBubble andMainBubble:(BubbleContainer *)mainB {
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = itemData.count;
    CGSize size = [Styles editTextBubbleSize];
    __block FlickScroller *flickS = flickScroller;
    
    for (int a = 0; a < count; a++) {
        PositionCalculationBlock x = ^{
            return [EditTextViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:cornerOfMainBubble andFlickScroller:flickS towardsRightSide:towardsRightSide];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < count; a++) {
        [m addObject:[[EditTextBubbleContainer alloc] initWithPositionCalculatorBlock:blocks[a] frameForStartingPosition:mainB.frame itemData:itemData[a] towardsRightSide:towardsRightSide andDelegate:delegate]];
    }
    
    return m;
}

+ (CGRect)getPositionOfObjectAtIndex:(NSInteger)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andFlickScroller:(FlickScroller *)flickScroller towardsRightSide:(BOOL)towardsRight {
    CGSize screen = [ApplicationDelegate getScreenSize];
    
    //Calculate position on position in page
    NSUInteger perPage = [FlickScroller getNumberOfItemsPerPage];
    NSUInteger indexOnPage = index;
    while (indexOnPage > perPage - 1) {
        indexOnPage -= perPage;
    }
    
    //Shift for page
    NSInteger xPageMod, yPageMod;
    yPageMod = -1; //Negative because shift, same with negative
    
    double x, y;
    CGPoint origin;
    
    origin = [EditTextViewController getCorner:[EditAssessmentViewController getCornerOriginForCorner:corner] withSize:size towardsRightSide:towardsRight];
    
    CGPoint difs = [EditTextViewController getXandYDifsWithBubbles:bubbles andSize:size withStartingCorner:[EditAssessmentViewController getCornerOriginForCorner:corner] towardsRightSide:towardsRight];
    double xDif = difs.x;
    double yDif = difs.y;
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
    
    //Position adjustment due to paging
    NSInteger whichPage = [FlickScroller getPageForIndex:index andNumberOfItems:bubbles];
    
    NSInteger thisItemsPage = [flickScroller getCurrentPageIndex];
    
    NSInteger xPageMove = (thisItemsPage - whichPage) * xPageMod * screen.width;
    NSInteger yPageMove = (thisItemsPage - whichPage) * yPageMod * screen.height;
    //    For debugging pages
    //        if (index == 0) NSLog(@"---------------------------");
    //        NSLog(@"Index: %i, WhichPage: %i, ThisPage: %i", index, whichPage, thisItemsPage);
    
    return CGRectMake(origin.x + x + xPageMove, origin.y + y + yPageMove, size.width, size.height);
}

+ (BOOL)mainBubbleCoversUpEditBubble {
    CGSize screen = [ApplicationDelegate getScreenSize];
    
    CGFloat space = screen.width - ([Styles spaceFromEdgeOfScreen] * 2) - ([Styles subtitleContainerSize].width / 2);
    if (([Styles editTextBubbleSize].width / 2) > space) {
        return YES;
    }
    
    return NO;
}

+ (CGFloat)getSpaceRemovalDueToPossibleMainBubbleBlockingEditBubbles {
    CGFloat spaceRemoval = 0;
    if ([EditTextViewController mainBubbleCoversUpEditBubble]) {
        spaceRemoval = [Styles spaceFromEdgeOfScreen] * 2 + ([Styles subtitleContainerSize].height / 2);
    }
    
    return spaceRemoval;
}

+ (CGPoint)getXandYDifsWithBubbles:(NSUInteger)bubbles andSize:(CGSize)size withStartingCorner:(Corner)startingCorner towardsRightSide:(BOOL)towardsRight {
    CGPoint startP = [EditTextViewController getCorner:startingCorner withSize:size towardsRightSide:towardsRight];
    CGPoint endP = [EditTextViewController getCorner:[Styles getOppositeCornerToCorner:startingCorner] withSize:size towardsRightSide:towardsRight];
    
    CGFloat xDif = startP.x - endP.x;
    CGFloat yDif = startP.y - endP.y;
    
    
    if (xDif < 0) xDif *= -1;
    if (yDif < 0) yDif *= -1;
    
    //Main bubble may cover up edit bubbles, make space
    yDif -= [EditTextViewController getSpaceRemovalDueToPossibleMainBubbleBlockingEditBubbles];
    
    return CGPointMake(xDif, yDif);
}

+ (CGPoint)getCorner:(Corner)c withSize:(CGSize)size towardsRightSide:(BOOL)towardsRight {
    CGPoint origin;
    CGSize screen = [ApplicationDelegate getScreenSize];
    float space = [Styles spaceFromEdgeOfScreen];
    
    float left = space  ;
    float right = screen.width - space ;
    float top = space + [ApplicationDelegate getStatusBarHeight];
    float bottom = screen.height - space - size.height;
    
    if (towardsRight) {
        left -= (size.width / 2);
        right -= size.width;
    } else {
        right -= (size.width / 2);
    }
    
    if (c == TopLeft) {
        origin.x = left;
        origin.y = top;
    } else if (c == TopRight) {
        origin.x = right;
        origin.y = top;
    } else if (c == BottomLeft) {
        origin.x = left;
        origin.y = bottom;
    } else { //Bottom right
        origin.x = right;
        origin.y = bottom;
    }
    
    //backup
    //    if (c == TopLeft) {
    //        origin.x = screen.width - space - (size.width / 2);
    //        origin.y = space;
    //    } else if (c == TopRight) {
    //        origin.x = space;
    //        origin.y = space;
    //    } else if (c == BottomLeft) {
    //        origin.x = screen.width - space - (size.width / 2);
    //        origin.y = screen.height - space - (size.height / 2);
    //    } else {
    //        origin.x = space;
    //        origin.y = screen.height - space - (size.height / 2);
    //    }
    
    return origin;
}

+ (Corner)getCornerOriginForCorner:(Corner)c {
    if (c == TopLeft) return TopRight;
    else if (c == TopRight) return TopLeft;
    else if (c == BottomLeft) return TopLeft;
    else return TopRight; //c == bottom right
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
    _editScreen.delegate = self;
    [self.view addSubview:_editScreen];
    [self.view bringSubviewToFront:_editScreen];
    [_editScreen show];
}

- (void)finishedEditing {
    [_editScreen removeFromSuperview];
}

- (void)showAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [_editScreen hide];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
        _flickScroller = [[FlickScroller alloc] initWithItems:self.childBubbles.count container:self.view andFlickScrollerAndScrollArrowViewDelegate:self];
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

- (void)creationAnimationHasFinished {
    [super creationAnimationHasFinished];
    
    [_flickScroller flashYESForUpNOForDownArrow:NO afterTimes:FLASH_BUBBLE_VC_MAIN_BUBBLE_TIMES];
    
    [self.view bringSubviewToFront:_flickScroller.downArrow];
    [self.view bringSubviewToFront:_flickScroller.upArrow];
}

- (void)showAlertControllerAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Other    ************************************
//*************************
//****************
//*********
//****
//*

- (void)pageFlicked {
    [self repositionBubbles];
}

- (void)repositionBubbles {
    [super repositionBubbles];
    [_flickScroller resetArrowPositions];
}

@end
