//
//  EditTextBubbleContainer.h
//  NCEACredits
//
//  Created by Dylan Chong on 16/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleContainer.h"
#import "EditTextEditScreen.h"
#import "EditTextScreenItemData.h"

@class EditTextBubble;
@class EditTextBubbleContainer;

@protocol EditTextBubbleContainerDelegate

- (void)editTheTextView:(EditTextBubbleContainer *)editTextView;

@end

@interface EditTextBubbleContainer : BubbleContainer

- (id)initWithPositionCalculatorBlock:(PositionCalculationBlock)pos frameForStartingPosition:(CGRect)frameForStartingPosition itemData:(EditTextScreenItemData *)itemData towardsRightSide:(BOOL)isTowardsRight andDelegate:(id)delegate;
@property id<EditTextBubbleContainerDelegate> touchDelegate;
@property EditTextDataType type;

@end
