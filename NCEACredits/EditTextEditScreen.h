//
//  EditTextEditScreen.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleSuffix @":"

@class EditTextBubbleContainer;

typedef NS_ENUM(NSInteger, EditTextDataType) {
    EditTextDataTypeText = 1,
    EditTextDataTypeGrade,
    EditTextDataTypeBool,
    EditTextDataTypeNumber,
    EditTextDataTypeDate,
    EditTextDataTypeTypeOfCredits,
} ;

@protocol EditTextEditScreenDelegate <NSObject>

- (void)finishedEditing;

@end

@interface EditTextEditScreen : UIView <UITextFieldDelegate>

- (id)initWithEditTextBubbleContainerToEdit:(EditTextBubbleContainer *)toEdit;

@property UILabel *title;
@property UITextField *text;
@property UIView *buttonContainer;
@property NSArray *buttons;
@property EditTextDataType type;
@property (weak) EditTextBubbleContainer *viewToEdit;

- (void)show;
- (void)hide;
- (void)resetFrameWithAnimation:(BOOL)animated;

@end
