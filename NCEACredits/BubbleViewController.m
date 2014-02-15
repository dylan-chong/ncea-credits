//
//  BubbleViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleViewController.h"
#import "Styles.h"

@implementation BubbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setMainBubbleSimilarToBubble:(BubbleContainer *)container {
    _parentBubble = container;
    Corner c = [Styles getOppositeCornerToCorner:[Styles getCornerForPoint:container.center]];
    CGSize s = container.frame.size;
    
    PositionCalculationBlock p = ^{
        CGRect r;
        r.origin = [Styles getExactOriginForCorner:c andSize:s];
        r.size = s;
        return r;
    };
    
    if (container.bubbleType == TitleBubble) {
        _mainBubble = [[BubbleContainer alloc] initTitleBubbleWithFrameCalculator:p colour:container.colour iconName:container.imageName title:container.bubble.title.text frameBubbleForStartingPosition:CGRectZero andDelegate:YES];
        _mainBubble.delegate = self;
    } else if (container.bubbleType == SubtitleBubble) {
        _mainBubble = [[BubbleContainer alloc] initSubtitleBubbleWithFrameCalculator:p colour:container.colour title:container.bubble.title.text frameBubbleForStartingPosition:CGRectZero andDelegate:YES];
        _mainBubble.delegate = self;
    }
    
    [self.view addSubview:_mainBubble];
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    _mainBubble = m;
    _childBubbles = a;
    
    [self createAnchors];
    [self.view bringSubviewToFront:_mainBubble];
}

- (void)createAnchors {
    _anchors = [[AnchorView alloc] initWithStartingPoint:[self.view convertPoint:_mainBubble.bubble.center fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
    [self.view addSubview:_anchors];
    [self.view sendSubviewToBack:_anchors];
}

- (void)redrawAnchors {
    if (_disableAnchorReDraw != YES) {
#warning fix this being called when not front vc
        [_anchors setStartingPoint:[self.view convertPoint:_mainBubble.bubble.center fromView:_mainBubble] andPointsToDrawTo:[self getAnchorPointsFromChildBubbles]];
        [_anchors setNeedsDisplay];
    }
}

- (NSArray *)getAnchorPointsFromChildBubbles {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        [points addObject:[NSValue valueWithCGPoint:[self.view convertPoint:b.bubble.center fromView:b]]];
    }
    
    return points;
}

- (void)repositionBubbles {
    _anchors.frame = CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight]);
    [self redrawAnchors];
    
    if (_isDoingAnimation) {
        NSMutableArray *m = [[NSMutableArray alloc] init];
        CGRect r = _mainBubble.calulatePosition();
        [m addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.x endingPoint:r.origin.x tag:X andDelegate:_mainBubble]];
        [m addObject:[[AnimationObject alloc] initWithStartingPoint:_mainBubble.frame.origin.y endingPoint:r.origin.y tag:Y andDelegate:_mainBubble]];
        
    } else {
        [self animateRepositionObjects];
    }
}

//************************************** Starting Animation **************************************

- (void)startChildBubbleCreationAnimation {
    NSArray *a = [[NSArray alloc] init];
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForSlidingAnimation]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:1 andDelegate:self];
    [_animationManager startAnimation];
}

- (void)startSlidingAnimation {
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:[[NSArray alloc] initWithObjects:
                                                                            [[AnimationObject alloc] initWithStartingPoint:[Styles startingScaleFactor] endingPoint:1.0 tag:ScaleWidth andDelegate:self],
                                                                            nil]
                                                                    length:[Styles animationSpeed]
                                                                       tag:2 andDelegate:self];
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

- (void)useDistanceFromBase:(double)value tag:(AnimationObjectTag)tag {
    if (tag == ScaleWidth || tag == ScaleHeight) { //Growing
        for (BubbleContainer *b in _childBubbles) {
            b.bubble.transform = CGAffineTransformMakeScale(value, value);
        }
    }
}

- (void)animationHasFinished:(int)tag {
    if (tag == 1) {
        [self startSlidingAnimation];
    } else if (tag == 2) {
        //Growing finished
        [self enableChildButtons];
    } else if (tag == 3) {
        //transition
        [self presentViewController:_childBubbleViewController animated:NO completion:nil];
        _childBubbleViewController.anchors.relativityFromMainBubble =
        CGPointMake(_mainBubble.center.x - _childBubbleViewController.parentBubble.center.x,
                    _mainBubble.center.y - _childBubbleViewController.parentBubble.center.y);
        
        [_childBubbleViewController hasTransitionedFromParentViewController];
    } else if (tag == 4) {
        //transition reverse
        [self enableChildButtons];
        _isDoingAnimation = NO;
    }
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

//************************************** Transition ****************************************

- (void)startTransitionToChildBubble:(BubbleContainer *)b andBubbleViewController:(BubbleViewController *)bubbleViewController {
    _childBubbleViewController = bubbleViewController;
    [self setTransitionDifsWithBubbleContainerFrame:b.frame];
    [self disableChildButtons];
    _isDoingAnimation = YES;
    
    NSArray *a = [_mainBubble getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif];
    
    for (BubbleContainer *b in _childBubbles) {
        a = [a arrayByAddingObjectsFromArray:[b getAnimationObjectsForXDif:_transitionXDif andYDif:_transitionYDif]];
    }
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:a length:[Styles animationSpeed] tag:3 andDelegate:self];
    [_animationManager startAnimation];
}

- (void)returnToPreviousViewController {
#warning return to vc
}

- (void)reverseTransitionToPreviousBubbleContainerPosition {
    [self animateRepositionObjects];
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
    
    _animationManager = [[AnimationManager alloc] initWithAnimationObjects:objects length:[Styles animationSpeed] tag:4 andDelegate:self];
    [_animationManager startAnimation];
}

- (void)setTransitionDifsWithBubbleContainerFrame:(CGRect)b {
    Corner opposite = [Styles getOppositeCornerToCorner:[Styles getCornerWithTitleContainerFrame:b]];
    
    CGPoint newPoint = [Styles getExactOriginForCorner:opposite andSize:b.size];
    CGPoint oldPoint = b.origin;
    
    _transitionXDif = newPoint.x - oldPoint.x;
    _transitionYDif = newPoint.y - oldPoint.y;
}

- (void)disableWiggleForTransition {
    _mainBubble.bubble.disableWiggleForTransition = YES;
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.disableWiggleForTransition = YES;
    }
}

- (void)enableWiggleAfterTransition {
    _mainBubble.bubble.disableWiggleForTransition = NO;
    for (BubbleContainer *b in _childBubbles) {
        b.bubble.disableWiggleForTransition = NO;
    }
}

//******************************************* View Controller Stuff *******************************************

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self repositionBubbles];
}

- (NSUInteger)supportedInterfaceOrientations {
    Device d = [Styles getDevice];
    
    if (d == iPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

@end
