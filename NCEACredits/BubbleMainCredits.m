//
//  BubbleMainCredits.m
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleMainCredits.h"
#import "Styles.h"

@implementation BubbleMainCredits

- (id)initWithFrame:(CGRect)frame andType:(GradeType)grade {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _grade = grade;
        int halfOfSpaceBetweenLabels = [Styles sizeModifier];
        int distanceFromTop = round(4 * [Styles sizeModifier]);
        
        _header = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            self.frame.size.width/2 - halfOfSpaceBetweenLabels,
                                                            self.frame.size.height)];
        _header.text = [BubbleMainCredits getCharTitleForGradeType:grade];
        _header.font = [Styles heading2Font];
        _header.textAlignment = NSTextAlignmentRight;
        _header.textColor = [Styles mainTextColour];
        [self addSubview:_header];
        
        _credits = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + halfOfSpaceBetweenLabels,
                                                             distanceFromTop,
                                                             self.frame.size.width/2 - halfOfSpaceBetweenLabels,
                                                             self.frame.size.height - distanceFromTop)];
        _credits.text = @"0";
        _credits.font = [Styles bodyFont];
        _credits.textColor = [Styles mainTextColour];
        _credits.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_credits];
        
        [self updateCredits];
    }
    return self;
}

- (void)updateCredits {
    if (_grade == Excellence) _credits.text = @"1";
    else if (_grade == Merit) _credits.text = @"2";
    else _credits.text = @"3";
}

+ (NSString *)getCharTitleForGradeType:(GradeType)grade {
    if (grade == Excellence) return @"E";
    else if (grade == Merit) return @"M";
    else return @"A";
}

@end
