//
//  FlickScroller.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollArrowView.h"

@protocol FlickScrollerDelegate <NSObject>
@required
- (void)pageFlicked;
@end

@interface FlickScroller : NSObject

@property UISwipeGestureRecognizer *upFlick, *downFlick;
@property UIView *containerView;
@property ScrollArrowView *upArrow, *downArrow;

- (NSUInteger)getCurrentPageIndex;
@property NSUInteger currentPageIndex, items;
@property id <FlickScrollerDelegate>delegate;

- (id)initWithItems:(NSUInteger)items container:(UIView *)container andDelegate:(id)delegate;
- (void)resetArrowPositions;
+ (CGSize)getContainerSize:(UIView *)container;

+ (NSUInteger)getNumberOfItemsPerPage;
+ (NSUInteger)getPagesForNumberOfItems:(NSUInteger)items;
+ (NSUInteger)getPageForIndex:(NSUInteger)index andNumberOfItems:(NSUInteger)items;

- (void)flicked:(UISwipeGestureRecognizer *)sender;

- (void)show;
- (void)hide;

@end