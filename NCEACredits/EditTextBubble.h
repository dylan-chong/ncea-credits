//
//  EditTextBubble.h
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleContainer.h"
#import "EditTextBubbleContainer.h"

@interface EditTextBubble : Bubble

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *textLabel;
@property UIView *viewContainer;
@property NSString *placeholder;
@property BOOL isPlaceHolder;
@property BOOL isTowardsRight;
@property EditTextDataType type;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text placeHolderText:(NSString *)placeholder towardsRightSide:(BOOL)isTowardsRight andType:(EditTextDataType)type;
- (void)setTextLabelText:(NSString *)text;

@end
