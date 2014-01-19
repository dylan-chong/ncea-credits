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

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(int)bubbles size:(CGSize)size fromCorner:(Corner)corner {
    double angleFromOrigin = 90.0 * ((index + 1.0) / (bubbles + 1.0));
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

+ (double)getRadius {
    double w = [Styles screenWidth];
    double h = [Styles screenHeight];
    
    if (w > h) {
        return h - ([Styles spaceFromEdgeOfScreen] * 2);
    } else {
        return w - ([Styles spaceFromEdgeOfScreen] * 2);
    }
}

@end
