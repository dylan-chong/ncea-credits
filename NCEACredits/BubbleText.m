//
//  BubbleText.m
//  NCEACredits
//
//  Created by Dylan Chong on 20/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "BubbleText.h"
#import <QuartzCore/QuartzCore.h>
#import "Bubble.h"

#define BUBBLE_TEXT_UNREMOVABLE_SPACE_FROM_SIDES 6
#define BUBBLE_TEXT_EXTRA_SIDE_INSET 1
#define BUBBLE_TEXT_DEFAULT_FONT [Styles heading3Font]
#define BUBBLE_TEXT_CHARACTERS_THAT_SEPARATE_WORDS @" -,/\\|:;"

@implementation BubbleText

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text fontOrNil:(UIFont *)fontOrNil {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textColor = [Styles mainTextColour];
        
        UIFont *f = (fontOrNil) ? fontOrNil : BUBBLE_TEXT_DEFAULT_FONT;
        [self setFont:f];
        self.text = text;
        self.userInteractionEnabled = NO;
        
        if (DEBUG_MODE_ON && BUBBLE_TEXT_SHOW_BACKGROUND) {
            self.backgroundColor = [UIColor lightGrayColor];
            self.alpha = 0.5;
            [self setTextAlignment:NSTextAlignmentLeft];
        } else {
            self.backgroundColor = [UIColor clearColor];
            [self setTextAlignment:NSTextAlignmentCenter];
        }
        
        CGFloat side = -BUBBLE_TEXT_UNREMOVABLE_SPACE_FROM_SIDES + BUBBLE_TEXT_EXTRA_SIDE_INSET;
        [self setTextContainerInset:UIEdgeInsetsMake(0, side, 0, side)];
        
        [self resizeFontToFix];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"Don't use BubbleText -initWithFrame:, use -initWithFrame: andText: instead");
    return nil;
}

- (void)resizeFrameAndCentre {
    CGRect originalFrame = self.frame;
    [self sizeToFit];
    
    CGPoint centre = self.center;
    centre.x = originalFrame.origin.x + (originalFrame.size.width / 2);
    centre.y = originalFrame.origin.y + (originalFrame.size.height / 2);
    self.center = centre;
}

- (id)styleString {
    return [[super styleString] stringByAppendingString:@";margin:0;"];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Font Checking    ************************************
//*************************
//****************
//*********
//****
//*

- (void)resizeFontToFix {
    //Resize to fix
    CGFloat fontSize = self.font.pointSize;
    CGFloat minSize = [Styles minimumFontSize];
    while ([BubbleText shouldContinueDecreasingFontSizeWithText:self.text withFont:self.font minSize:minSize textView:self]) {
        fontSize -= 0.1;
        self.font = [self.font fontWithSize:fontSize];
    }

    if (!(DEBUG_MODE_ON && BUBBLE_TEXT_SHOW_BACKGROUND))
        [self resizeFrameAndCentre];
}

+ (BOOL)shouldContinueDecreasingFontSizeWithText:(NSString *)text withFont:(UIFont *)font minSize:(CGFloat)minSize textView:(UITextView *)textView {
    if (font.pointSize <= minSize) return NO;
    
    //If sizetofit returns size bigger than frame, keep decreasing font
    CGSize sizeToFitView = [textView sizeThatFits:(CGSizeMake(textView.frame.size.width, FLT_MAX))];
    if (sizeToFitView.height >= textView.frame.size.height) return YES;
    
    NSArray *words = [self splitTextIntoWords:text];
    for (NSString *word in words) {
        if ([self word:word isTooBigToFitTextViewWidth:textView.frame.size.width withFont:font])
            return YES;
    }
    
    return NO;
}

+ (BOOL)word:(NSString *)word isTooBigToFitTextViewWidth:(CGFloat)textViewWidth withFont:(UIFont *)font {
    textViewWidth -= 2 * BUBBLE_TEXT_EXTRA_SIDE_INSET;
    CGFloat wordWidth = [word sizeWithAttributes:@{NSFontAttributeName:font}].width;
    
    if (wordWidth > textViewWidth) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)wordisTooBigToFitDefaultTextViewWithMinimumSizeFont:(NSString *)word  {
    CGFloat textViewWidth = [Styles getBubbleFrameWithContainerSize:[Styles subtitleContainerSize]].size.width * BUBBLE_WITHOUT_ICON_TEXT_FIELD_SPACE_FILL_DECIMAL;
    UIFont *minimumFont = [BUBBLE_TEXT_DEFAULT_FONT fontWithSize:[Styles minimumFontSize]];
    return [self word:word isTooBigToFitTextViewWidth:textViewWidth withFont:minimumFont];
}

+ (NSArray *)splitTextIntoWords:(NSString *)text {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:BUBBLE_TEXT_CHARACTERS_THAT_SEPARATE_WORDS];
    NSArray *words = [text componentsSeparatedByCharactersInSet:charSet];
    return words;
}

+ (BOOL)textContainsWordsThatWillBeTooLargeForSubtitleBubble:(NSString *)text {
    NSArray *words = [self splitTextIntoWords:text];
    for (NSString *word in words) {
        if ([self wordisTooBigToFitDefaultTextViewWithMinimumSizeFont:word])
            return YES;
    }
    
    return NO;
}

@end
