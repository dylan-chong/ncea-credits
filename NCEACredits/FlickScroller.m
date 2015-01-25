//
//  FlickScroller.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "FlickScroller.h"
#import "EditTextViewController.h"

@implementation FlickScroller

- (id)initWithItems:(NSUInteger)items container:(UIView *)container andFlickScrollerAndScrollArrowViewDelegate:(id)delegate {
    self = [super init];
    
    if (self) {
        _items = items;
        _currentPageIndex = 0;
        
        _containerView = container;
        
        _upFlick = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flicked:)];
        _upFlick.direction = UISwipeGestureRecognizerDirectionUp;
        [_containerView addGestureRecognizer:_upFlick];
        _downFlick = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flicked:)];
        _downFlick.direction = UISwipeGestureRecognizerDirectionDown;
        [_containerView addGestureRecognizer:_downFlick];
        
        _downArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:NO delegate:delegate andSizeOrZero:CGSizeZero];
        _upArrow = [[ScrollArrowView alloc] initWithContainer:_containerView upDirectionInsteadOfDown:YES delegate:delegate andSizeOrZero:CGSizeZero];
        [container addSubview:_downArrow];
        [container addSubview:_upArrow];
        
        _delegate = delegate;
    }
    
    return self;
}

- (void)flicked:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        if (_currentPageIndex > 0) {
            _currentPageIndex --;
            [self.delegate pageFlicked];
        }
    } else {
        if (_currentPageIndex < [FlickScroller getPagesForNumberOfItems:_items] - 1) {
            _currentPageIndex ++;
            [self.delegate pageFlicked];
        }
    }
    
    [self showAppropriateArrows];
}

- (void)showAppropriateArrows {
    if (_currentPageIndex == 0) {
        [_upArrow hide];
        
        if ([FlickScroller getPagesForNumberOfItems:_items] == 1)
            [_downArrow hide];
        else
            [_downArrow show];
        
    } else if (_currentPageIndex == [FlickScroller getPagesForNumberOfItems:_items] - 1) {
        [_upArrow show];
        [_downArrow hide];
    } else {
        [_upArrow show];
        [_downArrow show];
    }
}

- (void)resetArrowPositions {
    [_downArrow resetPositionAnimated:YES];
    [_upArrow resetPositionAnimated:YES];
}

+ (CGSize)getContainerSize:(UIView *)container {
    CGSize containerSize = container.frame.size;
    CGSize screen = [CurrentAppDelegate getScreenSize];
    
    if ((containerSize.width == screen.height || containerSize.width == screen.width) &&
        (containerSize.width == screen.height || containerSize.width == screen.width)) {
        
        containerSize.width = screen.width;
        containerSize.height = screen.height;
    }
    
    return containerSize;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Paging    ************************************
//*************************
//****************
//*********
//****
//*

+ (NSUInteger)getNumberOfItemsPerPage {
    CGSize screen = [CurrentAppDelegate getScreenSize];
    
    CGFloat count = [Styles numberOfItemsInSelectionViewPer100px] * screen.height / 100;
    if ([EditTextViewController mainBubbleCoversUpEditBubble]) {
        CGFloat toRemove = [Styles numberOfItemsInSelectionViewPer100px] * [Styles subtitleContainerSize].height / 100;
        count -= toRemove;
    }
    
    return floor(count);
}

+ (NSUInteger)getPagesForNumberOfItems:(NSUInteger)items {
    return ceil((items * 1.0) / [FlickScroller getNumberOfItemsPerPage]);
}

+ (NSUInteger)getPageForIndex:(NSUInteger)index andNumberOfItems:(NSUInteger)items {
    NSUInteger numberOfPages = [FlickScroller getPagesForNumberOfItems:items];
    NSUInteger perPage = [FlickScroller getNumberOfItemsPerPage];
    for (int a = 0; a < numberOfPages; a++) {
        if (index < (a + 1) * perPage)
            return a;
    }
    
    return 0;
}

- (NSUInteger)getCurrentPageIndex {
    return _currentPageIndex;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Show/Hide    ************************************
//*************************
//****************
//*********
//****
//*

- (void)show {
    _downArrow.enabled = YES;
    _upArrow.enabled = YES;
    [self showAppropriateArrows];
}

- (void)hide {
    _downArrow.enabled = NO;
    _upArrow.enabled = NO;
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        _downArrow.alpha = 0;
        _upArrow.alpha = 0;
    }];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Flash    ************************************
//*************************
//****************
//*********
//****
//*

- (void)flashYESForUpNOForDownArrow:(BOOL)isUpArrow afterTimes:(NSUInteger)afterTimes {
    CGFloat delay = [Styles getDurationOfAnimationWithFlashTimes:afterTimes];
    SEL arrowSelector = (isUpArrow) ? @selector(flashUp) : @selector(flashDown);
    
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:arrowSelector userInfo:nil repeats:NO];
}

- (void)flashUp {
    [self flashArrow:_upArrow];
}

- (void)flashDown {
    [self flashArrow:_downArrow];
}

- (void)flashArrow:(ScrollArrowView *)arrow {
    [Styles flashStartWithView:arrow numberOfTimes:FLASH_DEFAULT_TIMES sizeIncreaseMultiplierOr0ForDefault:3.0];
}

@end
