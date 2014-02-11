//
//  BubbleViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"

@protocol BubbleViewControllerTransitionDelegate <NSObject>
//child view controllers will implement the delegate to communicate with the parent
- (void)fromTransitionWillStartWithButton:(BubbleContainer *)container;
@end

@interface BubbleViewController : UIViewController

@property (nonatomic) BubbleView *bubbleView;
@property id<BubbleViewControllerTransitionDelegate> delegate;
@property BubbleViewController *childViewController;

@end
