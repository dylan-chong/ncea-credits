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
#import "CornerButton.h"
#import "HomeButton.h"

@interface SimpleSelectionViewController : BubbleViewController <UIGestureRecognizerDelegate>

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andStaggered:(BOOL)staggered;
- (void)createBubbleContainersAndAddAsSubviews;
+ (CGRect)getPositionOfObjectAtIndex:(NSInteger)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered;
+ (double)getRadius;

+ (NSArray *)getArrayOfBubblesWithSubjectColourPairs:(NSArray *)subjectOptionalColourPairs target:(SimpleSelectionViewController *)target staggered:(BOOL)staggered corner:(Corner)cornerOfMainBubble andMainBubble:(BubbleContainer *)mainB;
- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b;

@property Corner mainBubbleCorner;
@property BOOL staggered;

@property CornerButton *cornerButton;
@property HomeButton *homeButton;
- (void)createCornerButtonWithTitle:(NSString *)title colourOrNilForMailBubbleColour:(UIColor *)colour target:(id)target selector:(SEL)selector;
- (void)homeButtonPressed;

@end
