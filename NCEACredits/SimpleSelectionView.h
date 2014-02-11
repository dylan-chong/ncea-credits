//
//  SimpleSelectionView.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleView.h"

@protocol SimpleSelectionDelegate <NSObject>
- (void)subjectTitleWasPressed:(BubbleContainer *)bubble;
@end

@interface SimpleSelectionView : BubbleView

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner;
+ (double)getRadius;
+ (NSArray *)getArrayOfBubblesWithTitles:(NSArray *)titles buttonClickSelector:(NSString *)sel target:(SimpleSelectionView *)target andMainBubble:(BubbleContainer *)mainB;
- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b;

@property Corner mainBubbleCorner;

@end
