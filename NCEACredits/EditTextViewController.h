//
//  EditTextViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"
#import "EditTextBubbleContainer.h"
#import "FlickScroller.h"

#define EditTextScrollingNumberOfBubbles 7

@interface EditTextViewController : SimpleSelectionViewController <EditTextBubbleContainerDelegate, EditTextEditScreenDelegate, UIAlertViewDelegate, FlickScrollerDelegate, ScrollArrowViewDelegate>

+ (NSArray *)getEditBubblesWithEditTextScreenItemDataArray:(NSArray *)itemData delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide flickScroller:(FlickScroller *)flickScroller corner:(Corner)cornerOfMainBubble andMainBubble:(BubbleContainer *)mainB;
+ (CGRect)getPositionOfObjectAtIndex:(NSInteger)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andFlickScroller:(FlickScroller *)flickScroller towardsRightSide:(BOOL)towardsRight;
- (void)editTheTextView:(EditTextBubbleContainer *)sender;

@property EditTextEditScreen *editScreen;
@property (nonatomic) double lastCurrentScrollValue, scrollValueOffSet;
@property FlickScroller *flickScroller;
- (FlickScroller *)getFlickScroller;

+ (BOOL)mainBubbleCoversUpEditBubbles;

@end