//
//  ChangeColourSubjectColourTableViewCell.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeColourSubjectColourTableViewCell : UITableViewCell

@property UIView *colourView;
@property UIColor *colour;
- (void)setColourViewColour:(UIColor *)colour;

@end
