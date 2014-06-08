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
    return CGRectMake(round(frame.size.width / 8.0),
                      round(frame.size.height / 8.0),
                      round(frame.size.width * (3.0/4)),
                      round(frame.size.height * (3.0/4)));
}

+ (Corner)getOppositeCornerToCorner:(Corner)c {
    if (c == TopLeft) return BottomRight;
    else if (c == TopRight) return BottomLeft;
    else if (c == BottomLeft) return TopRight;
    else return TopLeft;
}

+ (CGPoint)getExactOriginForCorner:(Corner)c andSize:(CGSize)size {
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

+ (Corner)getCornerForPoint:(CGPoint)point {
    
    if (point.x >= [Styles screenWidth] / 2) {
        if (point.y >= [Styles screenHeight] / 2) {
            return BottomRight;
        } else {
            return TopRight;
        }
    } else {
        if (point.y >= [Styles screenHeight] / 2) {
            return BottomLeft;
        } else {
            return TopLeft;
        }
    }
}

+ (CGRect)getRectCentreOfFrame:(CGRect)rect withSize:(CGSize)size {
    //For starting sliding animation
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    r.origin.x = rect.origin.x + ((rect.size.width - r.size.width) / 2);
    r.origin.y = rect.origin.y + ((rect.size.height - r.size.height) / 2);
    return r;
}

+ (CGSize)editTextBubbleSize {
    return CGSizeMake(450 * [Styles sizeModifier] * 2, 50 * [Styles sizeModifier] * 2);
}

//Selection Paging

+ (float)numberOfItemsInSelectionViewPer100px {
    return 1.2;
}

+ (NSUInteger)minimumItemsPerSelectionPage {
    return 2;
    //Don't set too high other wise it may be impossible to get a number of items per page
}

@end
