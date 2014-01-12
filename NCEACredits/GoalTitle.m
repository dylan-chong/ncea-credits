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
        
        float space = 6 * [Styles sizeModifier];
        
        NSString *credits = [NSString stringWithFormat:@"%i", arc4random_uniform(100)];
        float toGoCreditsLabelWidth = [GoalTitle getToGoCreditsWidthWithCredits:credits];
        
        //toGo 2/3 of height - credits 0-45%, label (45+space)-100%
        _toGoCredits = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, round(w*toGoCreditsLabelWidth), round(h*(2.0/3)))];
        _toGoCredits.textAlignment = NSTextAlignmentRight;
        _toGoCredits.font = [Styles heading2Font];
        _toGoCredits.textColor = [Styles mainTextColour];
        _toGoCredits.text = credits;
        
        _toGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(round(w*toGoCreditsLabelWidth) + space, 0, round(w*(1.0-toGoCreditsLabelWidth)) - space, round(h*(2.0/3)))];
        _toGoLabel.textAlignment = NSTextAlignmentLeft;
        _toGoLabel.font = [Styles bodyFont];
        _toGoLabel.textColor = [Styles mainTextColour];
        _toGoLabel.text = @"to go";
        
        _goalNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, round(h*(2.0/3)), w, round(h*(1.0/3)))];
        _goalNameLabel.textAlignment = NSTextAlignmentCenter;
        _goalNameLabel.font = [Styles captionFont];
        _goalNameLabel.textColor = [Styles mainTextColour];
        _goalNameLabel.text = @"Achievement";
        
        [self addSubview:_toGoCredits];
        [self addSubview:_toGoLabel];
        [self addSubview:_goalNameLabel];
    }
    return self;
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
