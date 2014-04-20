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

#define EditTextScrollingNumberOfBubbles 10*[Styles sizeModifier]
#define EditTextScrollingSpaceBetweenBubbles 70*[Styles sizeModifier]

@interface EditTextViewController : SimpleSelectionViewController <EditTextBubbleContainerDelegate, EditTextEditScreenDelegate, UIAlertViewDelegate, PanScrollerDelegate>

+ (NSArray *)getEditBubblesWithTitles:(NSArray *)titles texts:(NSArray *)texts placeholders:(NSArray *)placeholder types:(NSArray *)types delegate:(SimpleSelectionViewController *)delegate towardsRightSide:(BOOL)towardsRightSide andMainBubble:(BubbleContainer *)mainB;
- (void)editTheTextView:(EditTextBubbleContainer *)sender;

@property EditTextEditScreen *editScreen;
@property PanScroller *scroller;

+ (double)getMaximumForNumberOfTextBubbles;

@end
