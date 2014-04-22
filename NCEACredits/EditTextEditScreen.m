//
//  EditTextEditScreen.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextEditScreen.h"
#import "EditTextBubbleContainer.h"
#import "EditTextBubble.h"

@implementation EditTextEditScreen

- (id)initWithEditTextBubbleContainerToEdit:(EditTextBubbleContainer *)toEdit
{
    self = [super initWithFrame:CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight])];
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
        if (toEdit.type == Text) {
            [_text becomeFirstResponder];
            _text.userInteractionEnabled = YES;
        } else {
            NSArray *titles;
            _buttonContainer = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:_buttonContainer];
            
            
            if (toEdit.type != Date && toEdit.type != Number) {
                if (toEdit.type == Grade) {
                    titles = @[@"Excellence", @"Merit", @"Achieved", @"Not Achieved", @"None"];
                } else if (toEdit.type == Bool) {
                    titles = @[@"Yes", @"No"];
                }
                
                _buttons = [EditTextEditScreen getArrayOfControlsWithTexts:titles andTarget:self];
            } else {
                _buttons = [EditTextEditScreen getNumpadButtonsWithTarget:self];
            }
            
            
            
            for (UIButton *b in _buttons) {
                [_buttonContainer addSubview:b];
            }
        }
        
        
        [self resetFrameWithAnimation:NO];
    }
    return self;
}

- (void)resetFrameWithAnimation:(BOOL)animated {
    float size = 0.25;
    float middle = 0.5;
    
    self.frame = CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight]);
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
        if (_type == Grade || _type == Bool) {
            for (int x = 0; x < _buttons.count; x++) {
                ((UIButton *)_buttons[x]).frame = [EditTextEditScreen getFrameOfButtonWithIndex:x outOf:_buttons.count withScreenSize:_buttonContainer.frame.size];
            }
        } else if (_type == Number || _type == Date) {
            for (int a = 0; a < _buttons.count; a++) {
                ((UIButton *)_buttons[a]).frame = [EditTextEditScreen getNumpadButtonFrameWithIndex:a andSize:_buttonContainer.frame.size];
            }
        }
    }];
}

- (CGRect)getFrameOfButtonContainer {
    return CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.4);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hide];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self hide];
    return YES;
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [Styles translucentWhite];
    }];
}

- (void)hide {
    [_text resignFirstResponder];
    _text.text = [_text.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    EditTextBubble *b = ((EditTextBubble *)(_viewToEdit.bubble));
    [b setTextLabelText:_text.text];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    }];
}

+ (NSArray *)getArrayOfControlsWithTexts:(NSArray *)texts andTarget:(EditTextEditScreen *)target {
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < texts.count; x++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectZero;
        [b setTitle:texts[x] forState:UIControlStateNormal];
        [b.titleLabel setFont:[Styles bodyFont]];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[Styles darkGreyColour] forState:UIControlStateHighlighted];
        [b addTarget:target action:@selector(setTextFieldText:) forControlEvents:UIControlEventTouchUpInside];
        [a addObject:b];
    }
    
    return a;
}

+ (CGRect)getFrameOfButtonWithIndex:(float)index outOf:(int)outOf withScreenSize:(CGSize)size {
    return CGRectMake(0, size.height * (index / outOf), size.width, size.height / outOf);
}

- (void)setTextFieldText:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"None"]) [_text setText:@""];
    else [_text setText:sender.titleLabel.text];
    [self hide];
}

- (void)deleteButtonPressed {
    if (_text.text.length > 0)
        _text.text = [_text.text substringToIndex:_text.text.length - 1];
}

- (void)doneButtonPressed {
    [self hide];
}

- (void)numpadButtonPressed:(UIButton *)sender {
    if (_type == Date) {
#warning TODO: date numpad
    } else if (_type == Number) {
        _text.text = [_text.text stringByAppendingString:sender.titleLabel.text];
    }
}

//*
//****
//*********
//****************
//*************************
//************************************    Button Layouts    ************************************
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

+ (CGRect)getNumpadButtonFrameWithIndex:(int)index andSize:(CGSize)size {
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
