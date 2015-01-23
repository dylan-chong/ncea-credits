//
//  EditTextEditScreen.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextEditScreen.h"
#import "EditTextBubble.h"
#import "Styles.h"
#import "EditTextBubbleContainer.h"
#import "Grade.h"

#define NEW_SUBJECT_TITLE @"New Subject"
#define CANCEL_BUTTON_TITLE @"Cancel"
//#define TOO_LONG_CHARACTERS 14

@implementation EditTextEditScreen

- (id)initWithEditTextBubbleContainerToEdit:(EditTextBubbleContainer *)toEdit
{
    CGSize screen = [ApplicationDelegate getScreenSize];
    self = [super initWithFrame:CGRectMake(0, 0, screen.width, screen.height)];
    if (self) {
        _viewToEdit = toEdit;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [Styles heading2Font];
        _title.text = ((EditTextBubble *)(toEdit.bubble)).titleLabel.text;
        _title.textAlignment = NSTextAlignmentRight;
        [self addSubview:_title];
        
        _text = [[UITextField alloc] initWithFrame:CGRectZero];
        _text.font = [Styles bodyFont];
        _text.text = ((EditTextBubble *)(toEdit.bubble)).textLabel.text;
        if ([_text.text isEqualToString:((EditTextBubble *)toEdit.bubble).placeholder]) _text.text = @"";
        _text.textAlignment = NSTextAlignmentLeft;
        _text.delegate = self;
        _text.userInteractionEnabled = NO;
        [self addSubview:_text];
        
        _type = toEdit.type;
        if (toEdit.type == EditTextDataTypeText) {
            [_text becomeFirstResponder];
            _text.userInteractionEnabled = YES;
        } else {
            [self setButtonsWithType:toEdit.type];
        }
        
        [self resetFrameWithAnimation:NO];
    }
    return self;
}

- (void)resetFrameWithAnimation:(BOOL)animated {
    float size = 0.25;
    float middle = 0.5;
    CGSize screen = [ApplicationDelegate getScreenSize];
    
    self.frame = CGRectMake(0, 0, screen.width, screen.height);
    float t = [Styles animationSpeed];
    if (!animated) t = 0;
    
    [UIView animateWithDuration:t animations:^{
        _buttonContainer.frame = [self getFrameOfButtonContainer];
        _title.frame = CGRectMake(0,
                                  self.frame.size.height * size / 2,
                                  self.frame.size.width * (middle - 0.005),
                                  self.frame.size.height * size);
        
        _text.frame = CGRectMake(self.frame.size.width * (middle + 0.005),
                                 self.frame.size.height * size / 2 + ([Styles sizeModifier] * 3),
                                 self.frame.size.width * (1 - middle - 0.005),
                                 self.frame.size.height * size);
        if (_type == EditTextDataTypeNumber || _type == EditTextDataTypeDate) {
            for (int a = 0; a < _buttons.count; a++) {
                ((UIButton *)_buttons[a]).frame = [EditTextEditScreen getNumpadButtonFrameWithIndex:a andSize:_buttonContainer.frame.size];
            }
        } else if (_type != EditTextDataTypeText) {
            for (int x = 0; x < _buttons.count; x++) {
                ((UIButton *)_buttons[x]).frame = [EditTextEditScreen getFrameOfButtonWithIndex:x outOf:_buttons.count withScreenSize:_buttonContainer.frame.size];
            }
        }
    }];
}

- (void)show {
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        self.backgroundColor = [Styles translucentWhite];
    }];
    
    //Type of credits warning
    NSString *title = ((EditTextBubble *)_viewToEdit.bubble).titleLabel.text;
    if ([[title substringToIndex:title.length - TitleSuffix.length] isEqualToString:ItemTypeOfCredits]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Remember that literacy and numeracy credits are only for NCEA Level 1." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.delegate showAlert:alert];
    }
}

- (void)hide {
    _text.text = [_text.text stringByReplacingOccurrencesOfString:@"\"" withString:@"-"];
    
    EditTextBubble *b = ((EditTextBubble *)(_viewToEdit.bubble));
    [b setTextLabelText:_text.text];
    
    [UIView animateWithDuration:[Styles animationSpeed] animations:^{
        self.alpha = 0.0;
    }];
}

- (void)showAlertIfTooLong:(NSString *)textToCheck {
    if ([BubbleText textContainsWordsThatWillBeTooLargeForSubtitleBubble:textToCheck]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"A word in the name you just entered will be a little too long to display. You should shorten it to approximately 12-15 characters or less." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self.delegate showAlert:alert];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Buttons    ************************************
//*************************
//****************
//*********
//****
//*
//*

- (CGRect)getFrameOfButtonContainer {
    return CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.4);
}

- (void)setButtonsWithType:(EditTextDataType)type {
    NSArray *titles;
    _buttonContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_buttonContainer];
    
    //Decide type
    if (type == EditTextDataTypeDate || type == EditTextDataTypeNumber) {
        //Numpad
        _buttons = [EditTextEditScreen getNumpadButtonsWithTarget:self];
    } else {
        //Selection buttons
        if (type == EditTextDataTypeGrade) {
            titles = @[GradeTextExcellence,
                       GradeTextMerit,
                       GradeTextAchieved,
                       GradeTextNotAchieved,
                       GradeTextTitleNone];
            
        } else if (type == EditTextDataTypeBool) {
            titles = @[EditTextBoolYes,
                       EditTextBoolNo];
            
        } else if (type == EditTextDataTypeTypeOfCredits) {
            titles = @[TypeOfCreditsNormal,
                       TypeOfCreditsLiteracy,
                       TypeOfCreditsNumeracy];
            
        } else if (type == EditTextDataTypeSubject) {
            titles = [[CurrentProfile getSubjectsAndColoursOrNilForCurrentYear] allKeys]; //Subjects are keys
            if (titles) {
                titles = [Styles sortArray:titles];
                titles = [titles arrayByAddingObject: NEW_SUBJECT_TITLE];
            } else {
                titles = @[NEW_SUBJECT_TITLE];
            }
            
        } else {
            //Non-existent type
            NSException *e = [[NSException alloc] initWithName:@"EditTextEditScreen type" reason:@"No valid type" userInfo:nil];
            [e raise];
        }
        
        titles = [titles arrayByAddingObject:CANCEL_BUTTON_TITLE];
        
        _buttons = [EditTextEditScreen getArrayOfControlsWithTexts:titles andTarget:self];
    }
    
    //Add buttons to view
    for (UIButton *b in _buttons) {
        [_buttonContainer addSubview:b];
    }
}

+ (NSArray *)getArrayOfControlsWithTexts:(NSArray *)texts andTarget:(EditTextEditScreen *)target {
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < texts.count; x++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectZero; //set in reeset layout
        [b setTitle:texts[x] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[Styles darkGreyColour] forState:UIControlStateHighlighted];
        [b addTarget:target action:@selector(multiChoiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [a addObject:b];
        [b setBackgroundColor:[UIColor clearColor]];
        
        [b.titleLabel setFont:[Styles bodyFont]];
        
    }
    
    return a;
}

+ (CGRect)getFrameOfButtonWithIndex:(float)index outOf:(NSUInteger)outOf withScreenSize:(CGSize)size {
    return CGRectMake(0, size.height * (index / outOf), size.width, size.height / outOf);
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Text Field    ************************************
//*************************
//****************
//*********
//****
//*

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_text resignFirstResponder];
    
    if ([((EditTextBubble *)_viewToEdit.bubble).titleLabel.text isEqualToString:[ItemQuickName stringByAppendingString:TitleSuffix]])
        [self showAlertIfTooLong:textField.text];
    [self hide];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self hide];
    return YES;
}

- (void)multiChoiceButtonPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:GradeTextTitleNone]) {
        [_text setText:@""];
        [self hide];
    }
    else if ([sender.titleLabel.text isEqualToString:NEW_SUBJECT_TITLE])
        [self newSubjectPressed];
    else if ([sender.titleLabel.text isEqualToString:CANCEL_BUTTON_TITLE])
        [self hide];
    else [self setTextFieldText:sender.titleLabel.text];
}

- (void)setTextFieldText:(NSString *)t {
    [_text setText:t];
    [self hide];
}

- (void)newSubjectPressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Please enter your new subject." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Subject";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self newSubjectTyped:((UITextField *)alert.textFields[0]).text];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self.delegate showAlert:alert];
}

- (BOOL)newSubjectTyped:(NSString *)newSub {
    //make sure subject doesn't already exist
    NSArray *existingSubs = [[CurrentProfile getSubjectsAndColoursOrNilForCurrentYear] allKeys];
    for (NSString *sub in existingSubs) {
        if ([sub isEqualToString:newSub]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"This subject already exists." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self.delegate showAlert:alert];
            
            return NO;
        }
    }
    
    //make sure isn't blank
    if (newSub.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"The subject cannot be blank." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.delegate showAlert:alert];
        
        return NO;
    }
    
    //they typed in new subject
    if ([newSub isEqualToString:NEW_SUBJECT_TITLE] ||
        [newSub isEqualToString:CANCEL_BUTTON_TITLE] ||
        [newSub isEqualToString:GradeTextTitleNone]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"OK. You're very lucky I thought about this before you did. Imagine what could've happened if I didn't! You could've broken the VERY FOUNDATIONS of NCEA Credits! You would be completely screwed! And so would the whole world for that matter. Then what would you do?\n\n Very lucky." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.delegate showAlert:alert];
        return NO;
    }

    
    [self showAlertIfTooLong:newSub];
    
    [self setTextFieldText:newSub];
    return YES;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Button Pressed    ************************************
//*************************
//****************
//*********
//****
//*

- (void)deleteButtonPressed {
    if (_text.text.length > 0)
        _text.text = [_text.text substringToIndex:_text.text.length - 1];
}

- (void)doneButtonPressed {
    if (_type == EditTextDataTypeDate) {
        //Prevent
        if ([EditTextEditScreen dateIsValid:_text.text] || _text.text.length == 0)
            [self hide];
        else
            [[[UIAlertView alloc] initWithTitle:AppName
                                        message:@"Make sure the date is valid. Check that the day and month are possible.\n\nIt must also be in the format:\ndd/mm/yy."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
    } else {
        //Lots of credits
        if ([[ItemCredits stringByAppendingString:TitleSuffix] isEqualToString:_title.text] && [_text.text intValue] > 15)
            [[[UIAlertView alloc] initWithTitle:AppName
                                        message:@"Gee that's a lot of credits. I hope you aren't trying to cheat the system...\n\nHave fun with that."
                                       delegate:nil
                              cancelButtonTitle:@"Sigh"
                              otherButtonTitles: nil] show];
        [self hide];
    }
}

#define AppendNumpadCharacter(stringToAppend) _text.text = [_text.text stringByAppendingString:stringToAppend]
#define SenderButtonString sender.titleLabel.text

- (void)numpadButtonPressed:(UIButton *)sender {
    if (_type == EditTextDataTypeDate) {
        if (_text.text.length < 8) {//6 for ddmmyy + 2 for slashes
            if (_text.text.length == 2 || _text.text.length == 4 + 1) {//+ 1 for previous slash
                AppendNumpadCharacter(@"/");
            }
            
            AppendNumpadCharacter(SenderButtonString);
        }
    } else if (_type == EditTextDataTypeNumber && _text.text.length < 10) {
        AppendNumpadCharacter(SenderButtonString);
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Date Validity    ************************************
//*************************
//****************
//*********
//****
//*

+ (BOOL)dateIsValid:(NSString *)date {
    if (date.length != 8) return NO; //Wrong length
    
    NSArray *dateParts = [date componentsSeparatedByString:@"/"];
    NSInteger day = [dateParts[0] integerValue];
    NSInteger month = [dateParts[1] integerValue];
    NSInteger year = [dateParts[2] integerValue];
    
    if (day > 31 || day == 0) return NO; //Impossible date
    if (month == 0 || month > 12) return NO; //Impossible month
    
    //Check for incompatible day/month combinations
    if (month == 2) {
        if (day > 29) return NO;
        
        if (day == 29 && [self yearIsPrime:year])
            return YES;
        else
            return NO;
    }
    
    if (month == 4 || month == 6 ||
        month == 9 || month == 11) {
        if (day < 31)
            return YES;
        else
            return NO;
    }
    
    return YES;
}

+ (BOOL)yearIsPrime:(NSInteger)year {
    double divided = year / 4.0;
    
    if (round(divided) == divided)
        return YES;
    else
        return NO;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Numpad    ************************************
//*************************
//****************
//*********
//****
//*

+ (NSArray *)getNumpadButtonsWithTarget:(EditTextEditScreen *)target {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *texts0 = @[@"1", @"2", @"3"];
    NSArray *texts1 = @[@"4", @"5", @"6"];
    NSArray *texts2 = @[@"7", @"8", @"9"];
    NSArray *texts3 = @[@"Done", @"0", @"←"];
    
    for (int a = 0; a < 4; a++) {
        for (int b = 0; b < 3; b++) {
            NSString *s;
            switch (a) {
                case 0:
                    s = texts0[b];
                    break;
                    
                case 1:
                    s = texts1[b];
                    break;
                    
                case 2:
                    s = texts2[b];
                    break;
                    
                case 3:
                    s = texts3[b];
                    break;
            }
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectZero;
            b.backgroundColor = [UIColor clearColor];
            [b setTitle:s forState:UIControlStateNormal];
            [b.titleLabel setFont:[Styles bigTextFont]];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setTitleColor:[Styles darkGreyColour] forState:UIControlStateHighlighted];
            [b.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            if ([s isEqualToString: @"Done"]) [b addTarget:target action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else if ([s isEqualToString:@"←"]) [b addTarget:target action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else [b addTarget:target action:@selector(numpadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [array addObject:b];
        }
    }
    
    return array;
}

+ (CGRect)getNumpadButtonFrameWithIndex:(NSInteger)index andSize:(CGSize)size {
    CGRect r;
    
    float cols = 5;
    r.size.width = size.width / cols;
    r.size.height = size.height / 4;
    
    //rows
    if (index >= 0 && index <= 2) r.origin.y = 0;
    else if (index >= 3 && index <= 5) r.origin.y = size.height * 0.25;
    else if (index >= 6 && index <= 8) r.origin.y = size.height * 0.5;
    else if (index >= 9 && index <= 11) r.origin.y = size.height * 0.75;
    
    //cols
    if (index == 0 || index == 3 || index == 6 || index == 9) r.origin.x = size.width * (floor(cols / 2) - 1) / cols;
    else if (index == 1 || index == 4 || index == 7 || index == 10) r.origin.x = size.width * floor(cols / 2) / cols;
    else if (index == 2 || index == 5 || index == 8 || index == 11) r.origin.x = size.width * (floor(cols / 2) + 1) / cols;
    
    return r;
}

@end
