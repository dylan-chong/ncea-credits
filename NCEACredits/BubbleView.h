//
//  BubbleView.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleContainer.h"
#import "AnchorView.h"

@interface BubbleView : UIScrollView <BubbleContainerDelegate>

@property (nonatomic) NSArray *childBubbles;
@property (nonatomic, strong) BubbleContainer *mainBubble;
@property AnchorView *anchors;

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a;

@end
