//
//  GoalTitle.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalTitle : UIView

@property UILabel *toGoLabel, *toGoCredits, *goalNameLabel;
@property CGSize sizeOfAreaCovered;
@property float space;

- (void)resetTextWithCredits:(NSUInteger)credits outOf:(NSUInteger)outOf grade:(NSString *)grade andTitle:(NSString *)title;

@end
