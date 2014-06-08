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
    Text = 1,
    Grade = 2,
    Bool = 3,
    Number = 4,
    Date = 5,
    TypeOfCredits = 6,
} EditTextDataType;

typedef enum {
    Normal = 1,
    Literacy = 2,
    Numeracy = 3
} CreditTypes;

#define EditTextBoolYes @"Yes"
#define EditTextBoolNo @"No"

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
