//
//  SimpleSelectionViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 13/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionViewController.h"

@interface SimpleSelectionViewController ()

@end

@implementation SimpleSelectionViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble andStaggered:(BOOL)staggered {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.staggered = staggered;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
        [self createAnchors];
    }
    return self;
}

- (void)createBubbleContainers {
    
}

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    self.mainBubble = m;
    self.childBubbles = a;
}

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner andStaggered:(BOOL)staggered {
    double angleFromOrigin = 90.0 * ((index + 1.0) / (bubbles + 1.0));
    double r = [SimpleSelectionViewController getRadius];
    if (bubbles > 5 && (index + 1) / 2.0 == round((index + 1) / 2.0) && staggered) r *= 0.77;
    
    double sinAns, cosAns;
    CGSize screen = [ApplicationDelegate getScreenSize];
    if ([ApplicationDelegate deviceIsInLandscape]) {
         sinAns = sin([Styles degreesToRadians:angleFromOrigin]) * r * (screen.width / screen.height);
         cosAns = cos([Styles degreesToRadians:angleFromOrigin]) * r;
    } else {
         sinAns = sin([Styles degreesToRadians:angleFromOrigin]) * r;
         cosAns = cos([Styles degreesToRadians:angleFromOrigin]) * r * (screen.height / screen.width);
    }
    
    double x, y;
    CGPoint origin;
    if (corner == TopLeft) {
        x = cosAns;
        y = sinAns;
        origin.x = [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles spaceFromEdgeOfScreen];
    } else if (corner == TopRight) {
        x = -cosAns;
        y = sinAns;
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

+ (NSArray *)getArrayOfBubblesWithSubjectsWithColoursOrNot:(NSDictionary *)subjectsAndColours buttonClickSelector:(NSString *)sel target:(SimpleSelectionViewController *)target staggered:(BOOL)staggered andMainBubble:(BubbleContainer *)mainB {
    UIColor *c = mainB.colour;
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = subjectsAndColours.count;
    CGSize size = mainB.frame.size;
    for (int a = 0; a < subjectsAndColours.count; a++) {
        PositionCalculationBlock x = ^{
            return [SimpleSelectionViewController getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner andStaggered:staggered];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    NSArray *allKeys = [subjectsAndColours allKeys];
    
    for (int a = 0; a < subjectsAndColours.count; a++) {
        UIColor *overrideColour = [subjectsAndColours objectForKey:allKeys[a]]; //If subjects and colours come with colours use it, otherwise default to main bubble colour
        if (!overrideColour) overrideColour = c;
        [m addObject:[[BubbleContainer alloc] initSubtitleBubbleWithFrameCalculator:blocks[a] colour:overrideColour title:allKeys[a] frameBubbleForStartingPosition:mainB.frame andDelegate:NO]];
    }
    
    for (BubbleContainer *b in m) {
        [b addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(sel)]];
    }
    
    return m;
}

+ (double)getRadius {
    CGSize size = [ApplicationDelegate getScreenSize];
    
    if (size.width > size.height) {
        return size.height - ([Styles spaceFromEdgeOfScreen] * 2) - ([Styles subtitleContainerSize].width / 2);
    } else {
        return size.width - ([Styles spaceFromEdgeOfScreen] * 2) - ([Styles subtitleContainerSize].width / 2);
    }
}

- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b {
    return [self.childBubbles indexOfObject:b];
}

@end
