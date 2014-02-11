//
//  SimpleSelectionView.m
//  NCEACredits
//
//  Created by Dylan Chong on 19/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SimpleSelectionView.h"

@implementation SimpleSelectionView

- (void)setMainBubble:(BubbleContainer *)m andChildBubbles:(NSArray *)a {
    self.mainBubble = m;
    self.childBubbles = a;
}

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(NSUInteger)bubbles size:(CGSize)size fromCorner:(Corner)corner {
    double angleFromOrigin = 90.0 * ((index + 1.0) / (bubbles + 1.0));
    double r = [SimpleSelectionView getRadius];
    if (bubbles > 5 && (index + 1) / 2.0 == round((index + 1) / 2.0)) r /= 2;
    double sinAns = sin([Styles degreesToRadians:angleFromOrigin]) * [SimpleSelectionView getRadius];
    double cosAns = cos([Styles degreesToRadians:angleFromOrigin]) * [SimpleSelectionView getRadius];
 
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
        origin.x = [Styles screenWidth] - [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles spaceFromEdgeOfScreen];
    } else if (corner == BottomLeft) {
        x = sinAns;
        y = -cosAns;
        origin.x = [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles screenHeight] - [Styles spaceFromEdgeOfScreen];
    } else {
        x = -sinAns;
        y = -cosAns;
        origin.x = [Styles screenWidth] - [Styles spaceFromEdgeOfScreen];
        origin.y = [Styles screenHeight] - [Styles spaceFromEdgeOfScreen];
    }
    
    return CGRectMake(origin.x + x - (size.width / 2), origin.y + y - (size.height / 2), size.width, size.height);
}

+ (NSArray *)getArrayOfBubblesWithTitles:(NSArray *)titles buttonClickSelector:(NSString *)sel target:(SimpleSelectionView *)target andMainBubble:(BubbleContainer *)mainB {
    UIColor *c = mainB.colour;
    Corner corner = [Styles getCornerForPoint:mainB.frame.origin];
    
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSUInteger count = titles.count;
    CGSize size = mainB.frame.size;
    for (int a = 0; a < titles.count; a++) {
        PositionCalculationBlock x = ^{
            return [SimpleSelectionView getPositionOfObjectAtIndex:a outOfBubbles:count size:size fromCorner:corner];
        };
        
        [blocks addObject:x];
    }
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < titles.count; a++) {
        [m addObject:[[BubbleContainer alloc] initSubtitleBubbleWithFrameCalculator:blocks[a] colour:c title:titles[a] andDelegate:NO]];
    }
    
    for (BubbleContainer *b in m) {
        [b addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(sel)]];
    }
    
    return m;
}

+ (double)getRadius {
    double w = [Styles screenWidth];
    double h = [Styles screenHeight];
    
    if (w > h) {
        return h - ([Styles spaceFromEdgeOfScreen] * 2);
    } else {
        return w - ([Styles spaceFromEdgeOfScreen] * 2);
    }
}

- (NSUInteger)getIndexOfBubble:(BubbleContainer *)b {
    return [self.childBubbles indexOfObject:b];
}

@end
