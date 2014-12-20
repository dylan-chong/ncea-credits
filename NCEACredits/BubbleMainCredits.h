//
//  BubbleMainCredits.h
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleMainCredits : UIView

@property UILabel *header, *credits;
@property NSString *grade;

- (id)initWithFrame:(CGRect)frame andGradeTextType:(NSString*)grade;
- (void)setNumberOfCredits:(NSUInteger)credits;

@end
