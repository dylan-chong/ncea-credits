//
//  CornerButton.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CornerButton : UIButton

+ (CornerButton *)cornerButtonWithTitle:(NSString *)title width:(CGFloat)width corner:(Corner)corner colour:(UIColor *)colour target:(id)target selector:(SEL)selector;
- (void)reposition;
@property Corner buttonCorner;
@property UIColor *colour;

@end
