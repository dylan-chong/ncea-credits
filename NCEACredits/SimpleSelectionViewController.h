//
//  SimpleSelectionViewController.h
//  NCEACredits
//
//  Created by Dylan Chong on 13/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "Styles.h"
#import "SubjectColourPair.h"

@interface SimpleSelectionViewController : BubbleViewController <UIGestureRecognizerDelegate>

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andStaggered:(BOOL)staggered;
- (void)createBubbleContainersAndAddAsSubviews;
+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered;
+ (double)getRadius;

+ (NSArray *)getArrayOfBubblesWithSubjectColourPairs:(NSArray *)subjectOptionalColourPairs target:(SimpleSelectionViewController *)target staggered:(BOOL)staggered corner:(Corner)cornerOfMainBubble andMainBubble:(BubbleContainer *)mainB;
- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b;

@property Corner mainBubbleCorner;
@property BOOL staggered;

@end
