//
//  CornerButton.h
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIGHLIGHT_ANIMATION_TIME 0.1

@interface CornerButton : UIButton

- (id)initWithColour:(UIColor *)colour text:(NSString *)title corner:(Corner)corner target:(id)target selector:(SEL)selector;
- (void)reposition;
- (void)setTitleLabelWithColour:(UIColor *)colour andText:(NSString *)title;
- (void)resizeToFit;
@property Corner buttonCorner;
@property UIColor *colour;

- (void)highlight;
- (void)unhighlight;

- (void)show;
- (void)hide;

@end
