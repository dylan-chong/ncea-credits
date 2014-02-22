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
    Number = 4
} EditTextDataType;
#define tNSN(x) [NSNumber numberWithInt:x]

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
@property (weak) EditTextBubbleContainer *viewToEdit;

- (void)show;
- (void)hide;
- (void)resetFrameWithAnimation:(BOOL)animated;

@end
