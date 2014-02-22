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
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;
        
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
        
        if (toEdit.type == Text) {
            [_text becomeFirstResponder];
            _text.userInteractionEnabled = YES;
        } else if (toEdit.type == Number) {
            [_text becomeFirstResponder];
            _text.userInteractionEnabled = YES;
            _text.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            NSArray *titles;
            if (toEdit.type == Grade) {
                titles = @[@"Excellence", @"Merit", @"Achieved", @"Not Achieved", @"None"];
            } else if (toEdit.type == Bool) {
                titles = @[@"Yes", @"No"];
            }
            
            _buttonContainer = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:_buttonContainer];
            
            _buttons = [EditTextEditScreen getArrayOfControlsWithTexts:titles andTarget:self];
            
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
        _title.frame = CGRectMake(0,
                                  self.frame.size.height * size / 2,
                                  self.frame.size.width * (middle - 0.005),
                                  self.frame.size.height * size);
        
        _text.frame = CGRectMake(self.frame.size.width * (middle + 0.005),
                                 self.frame.size.height * size / 2 + ([Styles sizeModifier] * 3),
                                 self.frame.size.width * (1 - middle - 0.005),
                                 self.frame.size.height * size);
        if (_buttons) {
            _buttonContainer.frame = [self getFrameOfButtonContainer];
            for (int x = 0; x < _buttons.count; x++) {
                ((UIButton *)_buttons[x]).frame = [EditTextEditScreen getFrameOfButtonWithIndex:x outOf:_buttons.count withScreenSize:_buttonContainer.frame.size];
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
        self.alpha = 0.97;
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

@end
