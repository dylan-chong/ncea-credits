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

#warning TODO: reconfigure to show “20 out of 80 (A)” rther than just “60 to go”
#warning TODO: fix break when no assessments

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float w = frame.size.width;
        float h = frame.size.height;
        _sizeOfAreaCovered = frame.size;
        
        _space = 6 * [Styles sizeModifier];
        
        //toGo 2/3 of height - credits 0-45%, label (45+space)-100%
        _toGoCredits = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, round(h*(2.0/3)))];
        _toGoCredits.textAlignment = NSTextAlignmentRight;
        _toGoCredits.font = [Styles heading2Font];
        _toGoCredits.textColor = [Styles mainTextColour];
        
        _toGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, round(h*(2.0/3)))];
        _toGoLabel.textAlignment = NSTextAlignmentLeft;
        _toGoLabel.font = [Styles body2Font];
        _toGoLabel.textColor = [Styles mainTextColour];
        _toGoLabel.text = @"to go";
        
        _goalNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, round(h*(2.0/3)), w, round(h*(1.0/3)))];
        _goalNameLabel.textAlignment = NSTextAlignmentCenter;
        _goalNameLabel.font = [Styles captionFont];
        _goalNameLabel.textColor = [Styles mainTextColour];
        
        [self addSubview:_toGoCredits];
        [self addSubview:_toGoLabel];
        [self addSubview:_goalNameLabel];
    }
    return self;
}

- (void)resetTextWithCredits:(NSUInteger)credits andTitle:(NSString *)title {
    _toGoCredits.text = [NSString stringWithFormat:@"%i", credits];
    _toGoLabel.text = title;
    
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
    switch (c.length) {
        case 0:
            return 0.43;
        case 1:
            return 0.41;
        case 2:
            return 0.43;
        default:
            return 0.45;
    }
}

@end
