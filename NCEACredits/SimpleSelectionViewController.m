//
//  SimpleSelectionViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>

#define SIMPLE_SELECTION_STAGGER_AMOUNT 0.73

@implementation SimpleSelectionViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andStaggered:(BOOL)staggered {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.staggered = staggered;
        self.delegate = delegate;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainersAndAddAsSubviews];
        [self createAnchorsIfNonExistent];
        
        [self createHomeButton];
    }
    return self;
}

- (void)createBubbleContainersAndAddAsSubviews {
    NSAssert(NO, @"You must override this method. Use the getArrayOfBubblesWithTitlesWithColoursOrNSNulls:... method (with [self getCornerOfChildVCNewMainBubble] for the corner).");
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    self.mainBubble = m;
    self.childBubbles = a;
}

+ (NSArray *)getArrayOfBubblesWithSubjectColourPairs:(NSArray *)subjectOptionalColourPairs target:(SimpleSelectionViewController *)target staggered:(BOOL)staggered corner:(Corner)cornerOfMainBubble andMainBubble:(BubbleContainer *)mainB {
    UIColor *c = mainB.colour;
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = subjectOptionalColourPairs.count;
    CGSize size = [Styles subtitleContainerSize];
    for (int a = 0; a < subjectOptionalColourPairs.count; a++) {
        PositionCalculationBlock x = ^{
            return [SimpleSelectionViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:cornerOfMainBubble andStaggered:staggered];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < subjectOptionalColourPairs.count; a++) {
        SubjectColourPair *pair = subjectOptionalColourPairs[a];  //If comes with colours use it, otherwise default to main bubble colour
        UIColor *colourToUse;
        
        if (pair.colour) colourToUse = pair.colour;
        else colourToUse = c;
        
        [m addObject:[[BubbleContainer alloc] initSubtitleBubbleWithFrameCalculator:blocks[a] colour:colourToUse title:pair.subject frameBubbleForStartingPosition:mainB.frame andDelegate:NO]];
    }
    
    for (BubbleContainer *b in m) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(bubbleWasPressedByGestureRecogniser:)];
        tap.delegate = target;
        [b addGestureRecognizer:tap];
    }
    
    return m;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Get Position    ************************************
//*************************
//****************
//*********
//****
//*

+ (CGRect)getPositionOfObjectAtIndex:(NSInteger)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered {
    double angleFromOrigin = 90.0 * ((index + 1.0) / (bubbles + 1.0));
    if (corner == TopLeft || corner == TopRight) //Order appears backwards when mainbubble is at top - flip order
        angleFromOrigin = 90 - angleFromOrigin;
    
    double r = [SimpleSelectionViewController getRadius];
    if (bubbles > 4 && (index + 1) / 2.0 == round((index + 1) / 2.0) && staggered) r *= SIMPLE_SELECTION_STAGGER_AMOUNT;
    
    double sinAns, cosAns;
    CGSize screen = [CurrentAppDelegate getScreenSize];
    if ([CurrentAppDelegate deviceIsInLandscape]) {
        sinAns = sin([Styles degreesToRadians:angleFromOrigin]) * r * (screen.width / screen.height);
        cosAns = cos([Styles degreesToRadians:angleFromOrigin]) * r;
    } else {
        sinAns = sin([Styles degreesToRadians:angleFromOrigin]) * r;
        cosAns = cos([Styles degreesToRadians:angleFromOrigin]) * r * (screen.height / screen.width);
    }
    
    double x, y;
    CGPoint origin;
    if (corner == TopLeft) {
        x = sinAns;
        y = cosAns;
        origin.x = [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles spaceFromEdgeOfScreen];
    } else if (corner == TopRight) {
        x = -sinAns;
        y = cosAns;
        origin.x = screen.width - [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles spaceFromEdgeOfScreen];
    } else if (corner == BottomLeft) {
        x = sinAns;
        y = -cosAns;
        origin.x = [Styles spaceFromEdgeOfScreen];
        origin.y = screen.height - [Styles spaceFromEdgeOfScreen];
    } else {
        x = -sinAns;
        y = -cosAns;
        origin.x = screen.width - [Styles spaceFromEdgeOfScreen];
        origin.y = screen.height - [Styles spaceFromEdgeOfScreen];
    }
    
    return CGRectMake(origin.x + x - (size.width / 2), origin.y + y - (size.height / 2), size.width, size.height);
}

- (void)bubbleWasPressedByGestureRecogniser:(UIGestureRecognizer *)sender {
    [self bubbleWasPressed:(BubbleContainer *)sender.view];
}

+ (double)getRadius {
    CGSize size = [CurrentAppDelegate getScreenSize];
    
    if (size.width > size.height) {
        return size.height - ([Styles spaceFromEdgeOfScreen] * 2) - ([Styles subtitleContainerSize].width / 2);
    } else {
        return size.width - ([Styles spaceFromEdgeOfScreen] * 2) - ([Styles subtitleContainerSize].width / 2);
    }
}

- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b {
    return [self.childBubbles indexOfObject:b];
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Corner and Home Buttons    ************************************
//*************************
//****************
//*********
//****
//*

//------------------------------ Corner ------------------------------
- (void)repositionCornerButtonAndHomeButton {
    if (_cornerButton) {
        [_cornerButton reposition];
    }
    if (_homeButton) {
        [_homeButton reposition];
    }
}

- (void)createCornerButtonWithTitle:(NSString *)title colourOrNilForMailBubbleColour:(UIColor *)colour target:(id)target selector:(SEL)selector {
    Corner corner = [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:self.mainBubble.center]];
    UIColor *buttonColour = (colour) ? colour : self.mainBubble.colour;
    
    _cornerButton = [[CornerButton alloc] initWithColour:buttonColour text:title corner:corner target:target selector:selector];
    [self.view addSubview:_cornerButton];
}

- (void)repositionBubbles {
    [super repositionBubbles];
    
    [self repositionCornerButtonAndHomeButton];
}

//------------------------------ Home ------------------------------

- (void)createHomeButton {
    _homeButton = [[HomeButton alloc] initWithSimpleVC:self];
    [self.view addSubview:_homeButton];
}

- (void)startGrowingAnimation {
    [self showOrHideCornerAndHomeButton:YES];
    
    [super startGrowingAnimation];
}

- (void)homeButtonPressed {
    CurrentAppDelegate.bubbleVCisReturningToHomeScreen = YES;
    [self startReturnScaleAnimation];
}

- (void)hasRepositionedBubbles {
    [super hasRepositionedBubbles];
    [self showOrHideCornerAndHomeButton:YES];
    
    //return home
    if (CurrentAppDelegate.bubbleVCisReturningToHomeScreen) {
        if (self.delegate) {
            [self startReturnScaleAnimation];
        }
    }
}

- (void)startReturnScaleAnimation {
    [super startReturnScaleAnimation];
    [self showOrHideCornerAndHomeButton:NO];
}

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController {
    [super startTransitionToChildBubble:b andBubbleViewController:bubbleViewController];
    [self showOrHideCornerAndHomeButton:NO];
}

- (void)showOrHideCornerAndHomeButton:(BOOL)showsOrNO {
    if (showsOrNO) {
        if (_homeButton) [_homeButton show];
        if (_cornerButton) [_cornerButton show];
    } else {
        if (_homeButton) [_homeButton hide];
        if (_cornerButton) [_cornerButton hide];
    }
}

@end
