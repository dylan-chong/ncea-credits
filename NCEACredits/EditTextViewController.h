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
#import "FlickScroller.h"

#define EditTextScrollingNumberOfBubbles 7
#define EditTextScrollingExtraDiagonalFractionalSpaceBetweenBubbles 0.03

@interface EditTextViewController : SimpleSelectionViewController <EditTextBubbleContainerDelegate, EditTextEditScreenDelegate, UIAlertViewDelegate, FlickScrollerDelegate>

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide flickScroller:(FlickScroller *)flickScroller andMainBubble:(BubbleContainer *)mainB;
+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andFlickScroller:(FlickScroller *)flickScroller;
- (void)editTheTextView:(EditTextBubbleContainer *)sender;

@property EditTextEditScreen *editScreen;
@property (nonatomic) double lastCurrentScrollValue, scrollValueOffSet;
@property FlickScroller *flickScroller;
- (FlickScroller *)getFlickScroller;

@end