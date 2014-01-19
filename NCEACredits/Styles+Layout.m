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
    
    return CGRectMake(point.x, point.y, size.width, size.height);
}

+ (CGSize)titleContainerSize {  return CGSizeMake(200 * [Styles sizeModifier], 200 * [Styles sizeModifier]);    }

+ (CGSize)subtitleContainerSize {  return CGSizeMake(180 * [Styles sizeModifier], 180 * [Styles sizeModifier]);    }

+ (CGRect)titleContainerRectWithCorner:(Corner)c {
    CGSize size = [Styles titleContainerSize];
    CGRect availableOrigins;
    
    float x, y;
    
    switch (c) {
        case TopLeft:
            
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          [Styles spaceFromEdgeOfScreen],
                                          0,
                                          0);
            
            break;
            
        case TopRight:
            
            availableOrigins = CGRectMake([Styles middleXTitleBubblePosition],
                                          [Styles spaceFromEdgeOfScreen],
                                          0,
                                          0);
            
            break;
            
        case BottomLeft:
            
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          [Styles middleYTitleBubblePosition],
                                          0,
                                          0);
            break;
            
        case BottomRight:
            
            availableOrigins = CGRectMake([Styles middleXTitleBubblePosition],
                                          [Styles middleYTitleBubblePosition],
                                          0,
                                          0);
            
            
        default:
            break;
    }
    
    availableOrigins.size = [Styles getAvailableOriginsSize];
    
 	x = (float) availableOrigins.origin.x + arc4random_uniform(availableOrigins.size.width);
    y = (float) availableOrigins.origin.y + arc4random_uniform(availableOrigins.size.height);
    if (showOrigins == YES) return availableOrigins;
    
    CGRect r = CGRectMake(x, y, size.width, size.height);
    
    return r;
}

+ (CGSize)getAvailableOriginsSize {
    CGSize s;
    CGRect mainRect = [Styles mainContainerRect];
    
    if ([Styles deviceIsInLandscape]) {
        s.width = mainRect.origin.x - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].width;
        s.height = mainRect.origin.y + (mainRect.size.height / 2) - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].height;
    } else {
        s.width = mainRect.origin.x + (mainRect.size.width / 2) - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].width;
        s.height = mainRect.origin.y - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].height;
    }
    
    return s;
}

+ (float)middleXTitleBubblePosition {
    CGRect mainRect = [Styles mainContainerRect];
    if ([Styles deviceIsInLandscape]) {
        return mainRect.origin.x + mainRect.size.width + [Styles spaceFromEdgeOfScreen];
    } else {
        return mainRect.origin.x + (mainRect.size.width / 2) + [Styles spaceFromEdgeOfScreen];
    }
}

+ (float)middleYTitleBubblePosition {
    CGRect mainRect = [Styles mainContainerRect];
    if ([Styles deviceIsInLandscape]) {
        return mainRect.origin.y + (mainRect.size.height / 2) + [Styles spaceFromEdgeOfScreen];
    } else {
        return mainRect.origin.y + mainRect.size.height + [Styles spaceFromEdgeOfScreen];
    }
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
    
    return p;
}

+ (Corner)getCornerForExactCornerPoint:(CGPoint)point {
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:TopLeft]]) return TopLeft;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:TopRight]]) return TopRight;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:BottomLeft]]) return BottomLeft;
    if ([Styles point:point isEqualToPoint:[Styles getExactCornerPointForCorner:BottomRight]]) return BottomRight;
    return NotValid;
}

+ (float)getRadiusOfRadialView {
    return [Styles screenHeight] - ([Styles spaceFromEdgeOfScreen] * 2);
}

+ (CGRect)getRectOfSubtitleButtonOfIndexInArray:(int)index withNumberOfObjects:(int)count fromCorner:(Corner)corner {
    CGSize size = CGSizeMake([Styles titleContainerSize].width * 0.8, [Styles titleContainerSize].height * 0.8);
    float angleFromOrigin = 90.0 * (index + 1.0) / (count + 1);
    
    float x = sinf([Styles degreesToRadians:angleFromOrigin]) * [Styles getRadiusOfRadialView];
    float y = cosf([Styles degreesToRadians:angleFromOrigin]) * [Styles getRadiusOfRadialView];
    
    
    return CGRectMake(x, y, size.width, size.height);
}

@end
