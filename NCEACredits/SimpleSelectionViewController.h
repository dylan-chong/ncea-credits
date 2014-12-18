//
//  SimpleSelectionViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 13/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "Styles.h"

@protocol SimpleSelectionDelegate <NSObject>
- (void)subjectTitleWasPressed:(BubbleContainer *)bubble;
@end

@interface SimpleSelectionViewController : BubbleViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble andStaggered:(BOOL)staggered;
- (void)createBubbleContainers;
+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered;
+ (double)getRadius;
+ (NSArray *)getArrayOfBubblesWithTitles:(NSArray *)titles buttonClickSelector:(NSString *)sel target:(SimpleSelectionViewController *)target staggered:(BOOL)staggered andMainBubble:(BubbleContainer *)mainB;
- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b;

@property Corner mainBubbleCorner;
@property BOOL staggered;

@end
