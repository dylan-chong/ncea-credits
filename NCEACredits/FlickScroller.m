//
//  FlickScroller.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "FlickScroller.h"

@implementation FlickScroller

- (id)initWithItems:(NSUInteger)items container:(UIView *)container andDelegate:(id)delegate {
    self = [super init];
    
    if (self) {
        _items = items;
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
#warning TODO: ^^^ page calc with item
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
        _currentPageIndex = 0;
        
        _containerView = container;
        
        _upFlick = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flicked:)];
        _upFlick.direction = UISwipeGestureRecognizerDirectionUp;
        [_containerView addGestureRecognizer:_upFlick];
        _downFlick = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flicked:)];
        _downFlick.direction = UISwipeGestureRecognizerDirectionDown;
        [_containerView addGestureRecognizer:_downFlick];
        
        _downArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:NO andSizeOrZero:CGSizeZero];
        _upArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:YES andSizeOrZero:CGSizeZero];
        
        _delegate = delegate;
    }
    
    return self;
}

- (void)flicked:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (_currentPageIndex > 0) {
            _currentPageIndex --;
            [self.delegate pageFlicked:_currentPageIndex];
        }
    } else {
        if (_currentPageIndex < [FlickScroller getPagesForNumberOfItems:_items] - 1) {
            _currentPageIndex ++;
            [self.delegate pageFlicked:_currentPageIndex];
        }
    }
}

- (void)resetArrowPositions {
    [_downArrow resetPositionAnimated:YES];
    [_upArrow resetPositionAnimated:YES];
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

//*
//****
//*********
//****************
//*************************
//************************************    Paging    ************************************
//*************************
//****************
//*********
//****
//*

+ (NSUInteger)getNumberOfItemsPerPage {
    return round([Styles numberOfItemsInSelectionViewPer100px] * [Styles screenHeight] / 100);
}

+ (NSUInteger)getPagesForNumberOfItems:(NSUInteger)items {
    return ceil((items * 1.0) / [FlickScroller getNumberOfItemsPerPage]);
}

//+ (NSUInteger)getItemsOnLastPageWithItemsPerPage:(NSUInteger)perPage andNumberOfItems:(NSUInteger)number {
//    //Essentially modulus
//    while (perPage < number) {
//        number -= perPage;
//    }
//    
//    return number;
//}

+ (NSUInteger)getPageForIndex:(NSUInteger)index andNumberOfItems:(NSUInteger)items {
    for (int a = 0; a < [FlickScroller getPagesForNumberOfItems:items]; a++) {
        if (index < (a + 1) * [FlickScroller getNumberOfItemsPerPage])
            return a;
    }
    
    return 0;
}

//*
//****
//*********
//****************
//*************************
//************************************    Show/Hide    ************************************
//*************************
//****************
//*********
//****
//*

- (void)show {
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        _downArrow.alpha = StandardScrollArrowShowAlpha;
        _upArrow.alpha = StandardScrollArrowShowAlpha;
    } completion:^(BOOL finished) {
        if (finished) {
            _downArrow.enabled = YES;
            _upArrow.enabled = YES;
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
