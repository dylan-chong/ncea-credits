//
//  Styles.h
//  NCEACredits
//
//  Created by Dylan Chong on 6/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Styles.h"

#define showOrigins NO

@implementation Styles (Layout)

+ (CGRect)mainContainerRect {
    CGSize size = CGSizeMake(340 * [Styles sizeModifier], 340 * [Styles sizeModifier]);
    
    //centre of screen
    CGPoint point = CGPointMake(round(([Styles screenWidth] - size.width) / 2), round(([Styles screenHeight] - size.height) / 2));
    
    return CGRectMake(point.x + [Styles screenWidth], point.y + [Styles screenHeight], size.width, size.height);
}

+ (CGSize)titleContainerSize {  return CGSizeMake(200 * [Styles sizeModifier], 200 * [Styles sizeModifier]);    }

+ (CGRect)titleContainerRectWithCorner:(Corner)c {
    CGSize size = [Styles titleContainerSize];
    CGRect availableOrigins;
    CGRect mainRect = [Styles mainContainerRect];
    mainRect.origin.x -= [Styles screenWidth];
    mainRect.origin.y -= [Styles screenHeight];
    
    float x, y;
    
    switch (c) {
        case TopLeft:
            
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          [Styles spaceFromEdgeOfScreen],
                                          mainRect.origin.x - ([self spaceFromEdgeOfScreen] * 2) - size.width,
                                          mainRect.origin.y + (mainRect.size.height / 2) - [Styles spaceFromEdgeOfScreen] - size.height);
            
            break;
            
        case TopRight:
            
            availableOrigins = CGRectMake(mainRect.origin.x + mainRect.size.width + [Styles spaceFromEdgeOfScreen],
                                          [Styles spaceFromEdgeOfScreen],
                                          [Styles screenWidth] - ([Styles spaceFromEdgeOfScreen] * 2) - (mainRect.origin.x + mainRect.size.width) - size.width,
                                          mainRect.origin.y + (mainRect.size.height / 2) - [Styles spaceFromEdgeOfScreen] - size.height);
            
            break;
            
        case BottomLeft:
            
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          mainRect.origin.y + (mainRect.size.height / 2) + [Styles spaceFromEdgeOfScreen],
                                          mainRect.origin.x - ([self spaceFromEdgeOfScreen] * 2) - size.width,
                                          [Styles screenHeight] - [Styles spaceFromEdgeOfScreen] - mainRect.origin.y - (mainRect.size.height / 2) - size.height);
            break;
            
        case BottomRight:
            
            availableOrigins = CGRectMake(mainRect.origin.x + mainRect.size.width + [Styles spaceFromEdgeOfScreen],
                                          mainRect.origin.y + (mainRect.size.height / 2) + [Styles spaceFromEdgeOfScreen],
                                          [Styles screenWidth] - ([Styles spaceFromEdgeOfScreen] * 2) - (mainRect.origin.x + mainRect.size.width) - size.width,
                                          [Styles screenHeight] - [Styles spaceFromEdgeOfScreen] - mainRect.origin.y - (mainRect.size.height / 2) - size.height);
            
            
        default:
            break;
    }
    
    availableOrigins.origin.x += [Styles screenWidth];
    availableOrigins.origin.y += [Styles screenHeight];
    
 	x = (float) availableOrigins.origin.x + arc4random_uniform(availableOrigins.size.width);
    y = (float) availableOrigins.origin.y + arc4random_uniform(availableOrigins.size.height);
    if (showOrigins == YES) return availableOrigins;
    
    CGRect r = CGRectMake(x, y, size.width, size.height);
    
    return r;
}

+ (Corner)getCornerWithTitleContainerFrame:(CGRect)r {
    CGRect m = [Styles mainContainerRect];
    
    if (r.origin.x > m.origin.x + (m.size.width / 2)) {
        //Right
        if (r.origin.y > m.origin.y + (m.size.height / 2))  {
            return BottomRight;
        } else {
            return TopRight;
        }
    } else {
        //Left
        if (r.origin.y > m.origin.y + (m.size.height / 2))  {
            return BottomLeft;
        } else {
            return TopLeft;
        }
    }
}

+ (float)spaceFromEdgeOfScreen {
    return 30 * [self sizeModifier];
}

+ (CGRect)getBubbleFrameWithContainerFrame:(CGRect)frame {
    return CGRectMake(round(frame.size.width / 8),
                      round(frame.size.height / 8),
                      round(frame.size.width * (3.0/4)),
                      round(frame.size.height * (3.0/4)));
}

+ (CGRect)getFullScreenFrame {
    return CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight]);
}

+ (Corner)getOppositeCornerToCorner:(Corner)c {
    if (c == TopLeft) return BottomRight;
    else if (c == TopRight) return BottomLeft;
    else if (c == BottomLeft) return TopRight;
    else return TopLeft;
}

+ (CGPoint)getExactCornerPointForCorner:(Corner)c {
    CGSize size = [Styles titleContainerSize];
    float d = [Styles spaceFromEdgeOfScreen];
    CGPoint p;

    if (c == TopLeft) {
        p = CGPointMake(d, d);
    } else if (c == TopRight) {
        p = CGPointMake([Styles screenWidth] - d - size.width, d);
    } else if (c == BottomLeft) {
        p = CGPointMake(d, [Styles screenHeight] - d - size.height);
    } else {
        p = CGPointMake([Styles screenWidth] - d - size.width, [Styles screenHeight] - d - size.height);
    }
    
    p.x += [Styles screenWidth];
    p.y += [Styles screenHeight];
    return p;
}

+ (Corner)getCornerForExactCornerPoint:(CGPoint)point {
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:TopLeft]]) return TopLeft;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:TopRight]]) return TopRight;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:BottomLeft]]) return BottomLeft;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:BottomRight]]) return BottomRight;
    return NotValid;
}

@end
