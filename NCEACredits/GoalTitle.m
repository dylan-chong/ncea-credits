//
//  GoalTitle.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "GoalTitle.h"
#import "Styles.h"

@implementation GoalTitle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float w = frame.size.width;
        float h = frame.size.height;
        _sizeOfAreaCovered = frame.size;
        
        _space = 6 * [Styles sizeModifier];
        
        //toGo 2/3 of height - credits 0-45%, label (45+space)-100%
        _toGoCredits = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, h*(2.0/3))];
        _toGoCredits.textAlignment = NSTextAlignmentRight;
        _toGoCredits.font = [Styles bodyFont];
        _toGoCredits.textColor = [Styles mainTextColour];
        
        _toGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, h*(2.0/3))];
        _toGoLabel.textAlignment = NSTextAlignmentLeft;
        _toGoLabel.font = [Styles body2Font];
        _toGoLabel.textColor = [Styles mainTextColour];
        
        _goalNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(w*(0.5/3), h*(2.1/3), w*(2.0/3), h*(1.2/3))];
        _goalNameLabel.textAlignment = NSTextAlignmentCenter;
        _goalNameLabel.font = [Styles captionFont];
        _goalNameLabel.textColor = [Styles mainTextColour];
        _goalNameLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_toGoCredits];
        [self addSubview:_toGoLabel];
        [self addSubview:_goalNameLabel];
    }
    return self;
}

- (void)resetTextWithCredits:(NSUInteger)credits outOf:(NSUInteger)outOf grade:(NSString *)grade andTitle:(NSString *)title {
    _toGoCredits.text = [NSString stringWithFormat:@"%lu", (unsigned long)credits];
    _toGoLabel.text = [NSString stringWithFormat:@"out of %lu (%@)", (unsigned long)outOf, [grade substringToIndex:1]]; //substring gets first letter of grade (E/M/A)
    
    _goalNameLabel.text = title;
    
    [self setWidthOfToGoCreditsAndLabel];
}

- (void)setWidthOfToGoCreditsAndLabel {
    CGRect frameCredits = _toGoCredits.frame;
    CGRect frameLabel = _toGoLabel.frame;
    
    float widthMultiplier = [GoalTitle getToGoCreditsWidthWithCredits:_toGoCredits.text];
    
    frameCredits.size.width = _sizeOfAreaCovered.width * widthMultiplier;
    frameLabel.origin.x = _sizeOfAreaCovered.width * widthMultiplier + _space;
    frameLabel.size.width = _sizeOfAreaCovered.width * (1.0 - widthMultiplier);
    
    _toGoCredits.frame = frameCredits;
    _toGoLabel.frame = frameLabel;
}

+ (float)getToGoCreditsWidthWithCredits:(NSString *)c {
    return 0.3 + (0.015 * c.length);
}

@end
