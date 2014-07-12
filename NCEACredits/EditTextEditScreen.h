//
//  EditTextEditScreen.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationManager.h"

typedef enum {
    EditTextDataTypeText = 1,
    EditTextDataTypeGrade = 2,
    EditTextDataTypeBool = 3,
    EditTextDataTypeNumber = 4,
    EditTextDataTypeDate = 5,
    EditTextDataTypeTypeOfCredits = 6,
} EditTextDataType;

@protocol EditTextEditScreenDelegate <NSObject>

- (void)finishedEditing;

@end

@class EditTextBubbleContainer;

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
