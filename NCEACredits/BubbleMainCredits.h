//
//  BubbleMainCredits.h
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Excellence = 0,
    Merit = 1,
    Achieved = 2
} GradeType;

@interface BubbleMainCredits : UIView

@property UILabel *header, *credits;
@property GradeType grade;

- (id)initWithFrame:(CGRect)frame andType:(GradeType)grade;

@end
