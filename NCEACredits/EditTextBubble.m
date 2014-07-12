//
//  EditTextBubble.m
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextBubble.h"

@implementation EditTextBubble

- (id)initWithFrame:(CGRect)frame title:(NSString *)title text:(NSString *)text placeHolderText:(NSString *)placeholder towardsRightSide:(BOOL)isTowardsRight andType:(EditTextDataType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _isTowardsRight = isTowardsRight;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height / 2)];
        if (_isTowardsRight) _viewContainer.frame = CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewContainer];
        
        _placeholder = placeholder;
        
        
        float middle = 0.5;
        _titleLabel = [[UILabel alloc] initWithFrame:
                  CGRectMake(0,
                             0,
                             _viewContainer.frame.size.width * (middle - 0.01),
                             _viewContainer.frame.size.height)];

        _titleLabel.font = [Styles heading3Font];
        _titleLabel.text = [title stringByAppendingString:@":"];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        [_viewContainer addSubview:_titleLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(_viewContainer.frame.size.width * (middle + 0.01),
                                 2.0 * [Styles sizeModifier],
                                 _viewContainer.frame.size.width * (1 - middle - 0.01),
                                 _viewContainer.frame.size.height)];

        _textLabel.font = [Styles body2Font];
        [self setTextLabelText:text];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [_viewContainer addSubview:_textLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setTextLabelText:(NSString *)text {
    if (_type == EditTextDataTypeNumber) text = [EditTextBubble numbersOnlyStringFilter:text];
    
    if (![text isEqualToString:@""]) {
        _textLabel.text = text;
        _textLabel.textColor = [UIColor blackColor];
        _isPlaceHolder = NO;
    } else {
        _textLabel.text = _placeholder;
        _isPlaceHolder = YES;
        _textLabel.textColor = [Styles greyColour];
    }
}

- (CGPoint)getAnchorPoint {
    return self.center;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[Styles greyColour] setStroke];
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    if (_isTowardsRight) CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height / 2);
    else CGContextAddLineToPoint(context, 0, self.bounds.size.height / 2);
    
    CGContextStrokePath(context);
}

+ (NSString *)numbersOnlyStringFilter:(NSString *)originalString {
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return strippedString;
}

@end
