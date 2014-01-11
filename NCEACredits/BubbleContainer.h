//
//  BubbleContainer.h
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bubble.h"
#import "BubbleMain.h"
#import "Styles.h"

@protocol BubbleContainerDelegate <BubbleDelegate>
@end

@interface BubbleContainer : UIView <BubbleDelegate>

@property id<BubbleContainerDelegate> delegate;

@property Bubble *bubble;

@property BOOL isMainBubbleContainer;

- (id)initMainBubble;

- (id)initTitleBubbleWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate;

- (CGPoint)getanchorPoint;

@end
