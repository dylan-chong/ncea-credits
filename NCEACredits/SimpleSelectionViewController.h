//
//  SimpleSelectionViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 13/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"

@protocol SimpleSelectionDelegate <NSObject>
- (void)subjectTitleWasPressed:(BubbleContainer *)bubble;
@end

@interface SimpleSelectionViewController : BubbleViewController

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner;
+ (double)getRadius;
+ (NSArray *)getArrayOfBubblesWithTitles:(NSArray *)titles buttonClickSelector:(NSString *)sel target:(SimpleSelectionViewController *)target andMainBubble:(BubbleContainer *)mainB;
- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b;

@property Corner mainBubbleCorner;

@end
