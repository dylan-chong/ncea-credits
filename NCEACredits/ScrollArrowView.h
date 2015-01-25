//
//  ScrollArrowView.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/04/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StandardScrollArrowWidth 70 * [Styles sizeModifier]
#define StandardScrollArrowHeight 20 * [Styles sizeModifier]
#define StandardScrollArrowSpaceFromEdge 5 * [Styles sizeModifier]
#define StandardScrollArrowShowAlpha 0.75
#define StandardScrollArrowExtraTappingBoxSpace 30

@protocol ScrollArrowViewDelegate <NSObject>
- (void)showAlertControllerAlert:(UIAlertController *)alert;
@end

@interface ScrollArrowView : UIView

@property UIView *container;
@property BOOL isUp;
@property BOOL enabled;
@property id<ScrollArrowViewDelegate> delegate;

- (id)initWithContainer:(UIView *)container upDirectionInsteadOfDown:(BOOL)isUp delegate:(id<ScrollArrowViewDelegate>)delegate andSizeOrZero:(CGSize)size;
- (void)resetPositionAnimated:(BOOL)animated;

- (void)show;
- (void)hide;

@end
