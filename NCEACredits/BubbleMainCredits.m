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
        _credits.text = @"";
        _credits.font = [Styles body2Font];
        _credits.textColor = [Styles mainTextColour];
        _credits.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_credits];
        
        [self updateCredits];
    }
    return self;
}

- (void)updateCredits {
    if (_grade == GradeExcellence) _credits.text = [NSString stringWithFormat:@"%i", arc4random_uniform(100)];
    else if (_grade == GradeMerit) _credits.text = [NSString stringWithFormat:@"%i", arc4random_uniform(100)];
    else _credits.text = [NSString stringWithFormat:@"%i", arc4random_uniform(100)];
}

+ (NSString *)getCharTitleForGradeType:(GradeType)grade {
    if (grade == GradeExcellence) return @"E";
    else if (grade == GradeMerit) return @"M";
    else return @"A";
}

@end
