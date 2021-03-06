//
//  BubbleViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "Styles.h"
#import "Assessment.h"
#import "MainViewController.h"

#define MAIN_BUBBLE_TRANSITION_MOVE_MULTIPLIER 1.5

@implementation BubbleViewController

- (NSString *)GET_CHILD_MAIN_BUBBLE_OVERRIDE_TITLE {
    return @"Back";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _shouldDelayCreationAnimation = NO;
    _isDoingAnimation = YES; //Stops the automatic reposition bubbles animation, but not the creation animation
    _hasDoneCreationAnimation = NO;
    _hasInitiatedCreationAnimation = NO;
    
    _initiallyThoughtScreenSize = [CurrentAppDelegate getScreenSize]; //Device may rotate during transition, reposition after if needed
    return self;
}

- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container  {
    _parentBubble = container;
    Corner c = [self getCornerOfChildVCNewMainBubble:container];
    CGSize s = container.frame.size;
    
    PositionCalculationBlock p = ^{
        CGRect r;
        r.origin = [Styles getExactOriginForCorner:c andSize:s];
        r.size = s;
        return r;
    };
    
    NSString *overrideTitle = [self GET_CHILD_MAIN_BUBBLE_OVERRIDE_TITLE];
    NSString *title;
    if (overrideTitle)
        title = overrideTitle;
    else
        title = container.bubble.title.text;
    
    if (container.bubbleType == TitleBubble) {
        _mainBubble = [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:p colour:container.colour iconName:container.imageName title:title frameBubbleForStartingPosition:CGRectZero andDelegate:YES];
    } else if (container.bubbleType == SubtitleBubble) {
        _mainBubble = [[BubbleContainer alloc] initSubtitleBubbleWithFrameCalculator:p colour:container.colour title:title frameBubbleForStartingPosition:CGRectZero andDelegate:YES];
    }
    
    [_mainBubble addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainBubbleWasPressed)]];
    [self.view addSubview:_mainBubble];
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    _mainBubble = m;
    _childBubbles = a;
    
    [self createAnchorsIfNonExistent];
    [self.view bringSubviewToFront:_mainBubble];
}

- (void)mainBubbleWasPressed {
    [self startReturnScaleAnimation];
}

- (void)repositionBubbles {
    self.initiallyThoughtScreenSize = [CurrentAppDelegate getScreenSize];
    CGSize screen = [CurrentAppDelegate getScreenSize];
    _anchors.frame = CGRectMake(0, 0, screen.width, screen.height);
    [self redrawAnchors];
    
    [self animateRepositionObjects];
}

- (void)hasRepositionedBubbles {
    if (!CGSizeEqualToSize(_initiallyThoughtScreenSize, [CurrentAppDelegate getScreenSize]))
        [self repositionBubbles];
}

- (BubbleContainer *)getChildBubbleContainerForTitle:(NSString *)title {
    for (BubbleContainer *b in self.childBubbles) {
        if ([b.bubble.title.text isEqualToString:title]) {
            return b;
        }
    }
    return nil;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    General Animation    ************************************
//*************************
//****************
//*********
//****
//*

- (void)setAnimationManager:(AnimationManager *)animationManager {
    if (!_shouldDelayCreationAnimation) {
        if (_animationManager && !_animationManager.animationHasFinished) {
            [_animationManager stopAnimationMidWay];
        }
        
        _isDoingAnimation = YES;
        _animationManager = animationManager;
    }
}

- (void)animationHasFinished:(NSInteger)tag {
    _isDoingAnimation = NO;
    
    if (tag == 1) {
        //Sliding finished
        [self startGrowingAnimation];
    } else if (tag == 2) {
        //Growing finished
        [self creationAnimationHasFinished];
    } else if (tag == 3) {
        //transition
        [self stopWiggle];
        [self presentViewController:_childBubbleViewController animated:NO completion:nil];
        _childBubbleViewController.anchors.relativityFromMainBubble =
        CGPointMake(_mainBubble.center.x - _childBubbleViewController.parentBubble.center.x,
                    _mainBubble.center.y - _childBubbleViewController.parentBubble.center.y);
        
        [_childBubbleViewController hasTransitionedFromParentViewController];
        _isCurrentViewController = NO;
    } else if (tag == 4) {
        //reposition bubbles or transition reverse
        [self enableChildButtons];
        [self hasRepositionedBubbles];
    } else if (tag == 5) {
        //return scale
        [self startReturnSlideAnimation];
    } else if (tag == 6) {
        //return slide
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate hasReturnedFromChildViewController];
        }];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Starting Animation    ************************************
//*************************
//****************
//*********
//****
//*

- (void)startChildBubbleCreationAnimation {
    if (!_shouldDelayCreationAnimation && !_hasDoneCreationAnimation && !_hasInitiatedCreationAnimation) {
        _hasInitiatedCreationAnimation = YES;
        
        NSArray *a = [[NSArray alloc] init];
        for (BubbleContainer *b in _childBubbles) {
            a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForSlidingAnimation]];
        }
        
        [self.view bringSubviewToFront:_mainBubble];
        
        //Only works on main vc
        CGFloat speed = [Styles animationSpeed];
        if ([self class] == [MainViewController class]) {
            [NSTimer scheduledTimerWithTimeInterval:[Styles animationSpeed] / 2 * ANIMATION_SPEED_LOAD_MULTIPLIER
                                             target:self.mainBubble
                                           selector:@selector(startGrowingMainBubbleAnimation)
                                           userInfo:nil
                                            repeats:NO];
            
            speed *= ANIMATION_SPEED_LOAD_MULTIPLIER;
        }
        
        [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:a length:speed tag:1 andDelegate:self]];
        [_animationManager startAnimation];
    }
    
}

- (void)startGrowingAnimation {
    CGFloat speed = [Styles animationSpeed];
    if ([self class] == [MainViewController class]) speed *= ANIMATION_SPEED_LOAD_MULTIPLIER;
    [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:[[NSArray alloc] initWithObjects:
                                                                                  [[AnimationObject alloc] initWithStartingPoint:[Styles startingScaleFactor] endingPoint:1.0 tag:ScaleWidth andDelegate:self],
                                                                                  nil]
                                                                          length:speed
                                                                             tag:2 andDelegate:self]];
    [_animationManager startAnimation];
    
}

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    if (tag == ScaleWidth || tag == ScaleHeight) { //Growing
        for (BubbleContainer *b in _childBubbles) {
            b.bubble.transform = CGAffineTransformMakeScale(value, value);
        }
    }
}

- (void)creationAnimationHasFinished {
    _hasDoneCreationAnimation = YES;
    [self enableChildButtons];
    
    //Dont flash if has no parent
    if (self.delegate)
        [Styles flashStartWithView:_mainBubble numberOfTimes:FLASH_BUBBLE_VC_MAIN_BUBBLE_TIMES sizeIncreaseMultiplierOr0ForDefault:0];
    
    //Reposition if needed
    if (!CGSizeEqualToSize(_initiallyThoughtScreenSize, [CurrentAppDelegate getScreenSize])) [self repositionBubbles];
}

- (void)disableChildButtons {
    for (BubbleContainer *b in _childBubbles) {
        b.userInteractionEnabled = NO;
    }
}

- (void)enableChildButtons {
    for (BubbleContainer *b in _childBubbles) {
        b.userInteractionEnabled = YES;
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Transition    ************************************
//*************************
//****************
//*********
//****
//*
- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController {
    _childBubbleViewController = bubbleViewController;
    [self setTransitionDifsWithBubbleContainer:b inBubbleVC:self];
    [self disableChildButtons];
    _isDoingAnimation = YES;
    
    NSArray *a = [_mainBubble getAnimationObjectsForXDif:_transitionXDif * MAIN_BUBBLE_TRANSITION_MOVE_MULTIPLIER andYDif:_transitionYDif * MAIN_BUBBLE_TRANSITION_MOVE_MULTIPLIER];
    CGPoint mainEndPos = [AnimationObject getOriginOfWhereBubble:_mainBubble willBeWithXTransitionDif:_transitionXDif * MAIN_BUBBLE_TRANSITION_MOVE_MULTIPLIER andYTransitionDif:_transitionYDif * MAIN_BUBBLE_TRANSITION_MOVE_MULTIPLIER];
    
    for (BubbleContainer *bub in _childBubbles) {
        //move all except tapped to same position as main
        if (bub == b) {
            //tapped bubble container
            a = [a arrayByAddingObjectsFromArray:[bub getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
        } else {
            a = [a arrayByAddingObjectsFromArray:[bub getAnimationObjectsToGoToOrigin:mainEndPos]];
        }
    }
    
    [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:3 andDelegate:self]];
    [_animationManager startAnimation];
}

- (void)startReturnScaleAnimation {
    self.view.userInteractionEnabled = NO;
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    for (BubbleContainer *b in _childBubbles) {
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:1.0 endingPoint:[Styles startingScaleFactor] tag:ScaleWidth andDelegate:b]];
    }
    
    [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:objects length:[Styles animationSpeed] tag:5 andDelegate:self]];
    [_animationManager startAnimation];
}

- (void)startReturnSlideAnimation {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    CGRect pos = [Styles getRectCentreOfFrame:_mainBubble.frame withSize:((BubbleContainer *)_childBubbles[0]).frame.size];
    
    for (BubbleContainer *b in _childBubbles) {
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.x endingPoint:pos.origin.x tag:X andDelegate:b]];
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.y endingPoint:pos.origin.y tag:Y andDelegate:b]];
    }
    
    [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:objects length:[Styles animationSpeed] tag:6 andDelegate:self]];
    [_animationManager startAnimation];
}

- (void)hasTransitionedFromParentViewController {
    [self startChildBubbleCreationAnimation];
    
    if (_parentBubble) {
        self.mainBubble.bubble.frame = _parentBubble.bubble.frame;
    }
    
    [self.view bringSubviewToFront:_mainBubble];
    [self.view sendSubviewToBack:_anchors];
}

- (void)animateRepositionObjects {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    CGRect pos = _mainBubble.calulatePosition();
    [objects addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.x endingPoint:pos.origin.x tag:X andDelegate:_mainBubble]];
    [objects addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.y endingPoint:pos.origin.y tag:Y andDelegate:_mainBubble]];
    
    for (BubbleContainer *b in _childBubbles) {
        pos = b.calulatePosition();
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.x endingPoint:pos.origin.x tag:X andDelegate:b]];
        [objects addObject:[[AnimationObject alloc] initWithStartingPoint:b.frame.origin.y endingPoint:pos.origin.y tag:Y andDelegate:b]];
    }
    
    [self setAnimationManager:[[AnimationManager alloc] initWithAnimationObjects:objects length:[Styles animationSpeed] tag:4 andDelegate:self]];
    [_animationManager startAnimation];
}

//------------------------------ Transition Corners and Difs ------------------------------
- (Corner)getCornerOfParentMainBubble {
    if (self.delegate) {//If current has a parent
        return [Styles getCornerForPoint:_mainBubble.center];
    } else {
        return [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:self.lastTappedBubble.center]];
    }
}

- (Corner)getCornerOfChildVCNewMainBubble:(BubbleContainer *)bubble {
    if (self.delegate) { //has parent vc
        return [self.delegate getCornerOfParentMainBubble];
    } else {
        //Is root of mindmap (i.e. mainvc)
        return [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:self.lastTappedBubble.center]];
    }
}

- (Corner)getCornerWhereTappedBubbleWillTransitionTo {
    if (self.delegate) { //Has parent bubble vc
        return [Styles getCornerForPoint:_mainBubble.center];
    } else {
        //Doesnt have parent - root
        return [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:self.lastTappedBubble.center]];
    }
}

- (void)setTransitionDifsWithBubbleContainer:(BubbleContainer *)b inBubbleVC:(BubbleViewController *)bvc {
    
    Corner c = [self getCornerWhereTappedBubbleWillTransitionTo];
    
    CGPoint newPoint = [Styles getExactOriginForCorner:c andSize:b.frame.size];
    CGPoint oldPoint = b.frame.origin;
    
    _transitionXDif = newPoint.x - oldPoint.x;
    _transitionYDif = newPoint.y - oldPoint.y;
}

- (void)bubbleWasPressed:(BubbleContainer *)container {
    self.lastTappedBubble = container;
    NSLog(@"Bubble '%@' was pressed in '%@'.", container.bubble.title.text, NSStringFromClass([self class]));
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Wiggle  and Anchors    ************************************
//*************************
//****************
//*********
//****
//*

- (void)startWiggle {
    if (!self.wiggleTimer)
        self.wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/[Styles frameRate] target:self selector:@selector(wiggle) userInfo:nil repeats:YES];
}

- (void)wiggle {
    [self.mainBubble.bubble wiggle];
    
    for (BubbleContainer *container in self.childBubbles) {
        [container.bubble wiggle];
    }
    
    if ([[self class] allowsAnchorRedrawToStopWhenBubbleContainersAreStationary]) {
        if (_isDoingAnimation) {
            [self redrawAnchors];
            _drawsAnchors = YES;
        } else {
            if (_drawsAnchors) {
                [self redrawAnchors];
                _drawsAnchors = NO;
            }
        }
    } else {
        [self redrawAnchors];
    }
}

+ (BOOL)allowsAnchorRedrawToStopWhenBubbleContainersAreStationary {
    return YES;
}

- (void)stopWiggle {
    [self.wiggleTimer invalidate];
    self.wiggleTimer = nil;
}

//------------------------------ Anchors ------------------------------
- (void)createAnchorsIfNonExistent {
    if (!_anchors) {
        _anchors = [[AnchorView alloc] initWithStartingPoint:[self.view convertPoint:[_mainBubble.bubble getAnchorPoint] fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
        [self.view addSubview:_anchors];
        [self.view sendSubviewToBack:_anchors];
    }
}

- (void)redrawAnchors {
    [self.anchors redrawAnchorsWithStartingPoint:[self.view convertPoint:[_mainBubble.bubble getAnchorPoint] fromView:_mainBubble]
                               andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
}

- (NSArray *)getAnchorPointsFromChildBubbles {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        [points addObject:[NSValue valueWithCGPoint:[self.view convertPoint:[b.bubble getAnchorPoint] fromView:b]]];
    }
    
    return points;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Delegate    ************************************
//*************************
//****************
//*********
//****
//*

- (void)hasReturnedFromChildViewController {
    self.childBubbleViewController = nil;
    [self repositionBubbles];
}

- (NSString *)getTitleOfMainBubble {
    return _mainBubble.bubble.title.text;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    View Controller Stuff    ************************************
//*************************
//****************
//*********
//****
//*

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [CurrentAppDelegate setScreenSize:size];
    
    if ([CurrentAppDelegate deviceIsInLandscape] && [Styles getDevice] == iPhone) [_statusBarFiller setHidden:YES];
    else [_statusBarFiller setHidden:NO];
    
    if (!_shouldDelayCreationAnimation && _isCurrentViewController && !_isDoingAnimation) [self repositionBubbles];
}

- (NSUInteger)supportedInterfaceOrientations {
    Device d = [Styles getDevice];
    
    if (d == iPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isCurrentViewController = YES;
    
    [self createAnchorsIfNonExistent];
    [self startWiggle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Make sure status bar filler is large enough for portrait and landscape
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGSize screen = [CurrentAppDelegate getScreenSize];
    if (screen.width > screen.height) rect.size.width = screen.width;
    else rect.size.width = screen.height;
    
    _statusBarFiller = [[UIView alloc] initWithFrame:rect];
    _statusBarFiller.backgroundColor = [Styles translucentWhite];
    [self.view addSubview:_statusBarFiller];
    _statusBarFiller.layer.zPosition = MAXFLOAT;
}

@end
