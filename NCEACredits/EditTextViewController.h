//
//  EditTextViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"
#import "EditTextEditScreen.h"
#import "EditTextBubbleContainer.h"
#import "PanScroller.h"

#define EditTextScrollingNumberOfBubbles 7
#define EditTextScrollingExtraDiagonalFractionalSpaceBetweenBubbles 0.03

typedef double (^ScrollGetterBlock) (void);

@interface EditTextViewController : SimpleSelectionViewController <EditTextBubbleContainerDelegate, EditTextEditScreenDelegate, UIAlertViewDelegate, PanScrollerDelegate>

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide scrollGetterBlock:(ScrollGetterBlock)scrollGetter andMainBubble:(BubbleContainer *)mainB;
- (void)editTheTextView:(EditTextBubbleContainer *)sender;

@property EditTextEditScreen *editScreen;
@property PanScroller *scroller;
@property (nonatomic) double lastCurrentScrollValue;

- (double)getScrollerValue;
- (void)scrollToPositionDecimal:(double)decimal;
//+ (CGRect)getFrameWithScrollingAppliedAtIndex:(NSUInteger)index outOfBubbles:(NSUInteger)bubbles frame:(CGRect)frame fromCorner:(Corner)corner andSize:(CGSize)size;

@end