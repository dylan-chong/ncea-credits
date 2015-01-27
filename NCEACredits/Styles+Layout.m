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

+ (CGFloat)spaceFromEdgeOfScreen {
    if ([self getDevice] == iPhone) {
        return 6;
    } else if ([self getDevice] == iPad) {
        return 30;
    }
    
    return 30 * [Styles sizeModifier];
}

+ (CGRect)mainContainerRect {
    CGSize size = CGSizeMake(340 * [Styles sizeModifier], 340 * [Styles sizeModifier]);
    CGSize screen = [CurrentAppDelegate getScreenSize];
    //centre of screen
    CGPoint point = CGPointMake(round((screen.width - size.width) / 2), round((screen.height - size.height) / 2));
    
    return CGRectMake(point.x, point.y, size.width, size.height);
}

+ (CGSize)titleContainerSize {  return CGSizeMake(200 * [Styles sizeModifier], 200 * [Styles sizeModifier]);    }

+ (CGSize)subtitleContainerSize {  return CGSizeMake(180 * [Styles sizeModifier], 180 * [Styles sizeModifier]);    }

+ (CGRect)titleContainerRectWithCorner:(Corner)c {
    CGSize size = [Styles titleContainerSize];
    CGRect availableOrigins;
    
    CGFloat x, y;
    
    switch (c) {
        case TopLeft:
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          [Styles spaceFromEdgeOfScreen] + [CurrentAppDelegate statusBarHeight],
                                          0,
                                          0);
            break;
            
        case TopRight:
            availableOrigins = CGRectMake([Styles middleXTitleBubblePosition],
                                          [Styles spaceFromEdgeOfScreen] + [CurrentAppDelegate statusBarHeight],
                                          0,
                                          0);
            break;
            
        case BottomLeft:
            availableOrigins = CGRectMake([Styles spaceFromEdgeOfScreen],
                                          [Styles middleYTitleBubblePosition],
                                          0,
                                          0);
            break;
            
        default: //Bottom right
            availableOrigins = CGRectMake([Styles middleXTitleBubblePosition],
                                          [Styles middleYTitleBubblePosition],
                                          0,
                                          0);
            break;
    }
    
    availableOrigins.size = [Styles getAvailableOriginsSizeWithCorner:c];
    
 	x = (CGFloat) availableOrigins.origin.x + arc4random_uniform(availableOrigins.size.width);
    y = (CGFloat) availableOrigins.origin.y + arc4random_uniform(availableOrigins.size.height);
    if (showOrigins == YES) return availableOrigins;
    
    CGRect r = CGRectMake(x, y, size.width, size.height);
    
    return r;
}

+ (CGSize)getAvailableOriginsSizeWithCorner:(Corner)corner {
    CGSize s;
    CGRect mainRect = [Styles mainContainerRect];
    CGFloat sbh = [CurrentAppDelegate getStatusBarHeight];
    
    if ([CurrentAppDelegate deviceIsInLandscape]) {
        s.width = mainRect.origin.x - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].width;
        s.height = mainRect.origin.y + (mainRect.size.height / 2) - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].height;
    } else {
        s.width = mainRect.origin.x + (mainRect.size.width / 2) - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].width;
        s.height = mainRect.origin.y - ([Styles spaceFromEdgeOfScreen] * 2) - [Styles titleContainerSize].height;
    }
    
    if ([CurrentAppDelegate deviceIsInLandscape] && [Styles getDevice] == iPhone) {
        //no status bar
    } else {
        if ([Styles cornerIsTop:corner]) {
            s.height -= sbh;
        }
    }
    
    if (s.height < 0) s.height = 0;
    if (s.width < 0) s.width = 0;
    return s;
}

+ (CGFloat)middleXTitleBubblePosition {
    CGRect mainRect = [Styles mainContainerRect];
    if ([CurrentAppDelegate deviceIsInLandscape]) {
        return mainRect.origin.x + mainRect.size.width + [Styles spaceFromEdgeOfScreen];
    } else {
        return mainRect.origin.x + (mainRect.size.width / 2) + [Styles spaceFromEdgeOfScreen];
    }
}

+ (CGFloat)middleYTitleBubblePosition {
    CGRect mainRect = [Styles mainContainerRect];
    if ([CurrentAppDelegate deviceIsInLandscape]) {
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



+ (CGRect)getBubbleFrameWithContainerSize:(CGSize)size {
    return CGRectMake(round(size.width / 8.0),
                      round(size.height / 8.0),
                      round(size.width * BUBBLE_TO_BUBBLE_CONTAINER_SIZE_RATIO),
                      round(size.height * BUBBLE_TO_BUBBLE_CONTAINER_SIZE_RATIO));
}

+ (Corner)getOppositeCornerToCorner:(Corner)c {
    if (c == TopLeft) return BottomRight;
    else if (c == TopRight) return BottomLeft;
    else if (c == BottomLeft) return TopRight;
    else return TopLeft;
}

+ (CGPoint)getExactOriginForCorner:(Corner)c andSize:(CGSize)size {
    CGFloat d = [Styles spaceFromEdgeOfScreen];
    CGPoint p;
    CGSize screen = [CurrentAppDelegate getScreenSize];
    
    if (c == TopLeft) {
        p = CGPointMake(d, d);
    } else if (c == TopRight) {
        p = CGPointMake(screen.width - d - size.width, d);
    } else if (c == BottomLeft) {
        p = CGPointMake(d, screen.height - d - size.height);
    } else {
        p = CGPointMake(screen.width - d - size.width, screen.height - d - size.height);
    }
    
    if (c == TopLeft || c == TopRight) {
        if (!([Styles getDevice] == iPhone && [CurrentAppDelegate deviceIsInLandscape]))
            p.y += [CurrentAppDelegate getStatusBarHeight];
    }
    
    return p;
}

+ (Corner)getCornerForPoint:(CGPoint)point {
    CGSize screen = [CurrentAppDelegate getScreenSize];
    
    if (point.x >= screen.width / 2) {
        if (point.y >= screen.height / 2) {
            return BottomRight;
        } else {
            return TopRight;
        }
    } else {
        if (point.y >= screen.height / 2) {
            return BottomLeft;
        } else {
            return TopLeft;
        }
    }
}

+ (BOOL)cornerIsLeft:(Corner)corner {
    if (corner == TopLeft || corner == BottomLeft) return YES;
    return NO;
}

+ (BOOL)cornerIsTop:(Corner)corner {
    if (corner == TopLeft || corner == TopRight) return YES;
    return NO;
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

+ (CGFloat)numberOfItemsInSelectionViewPer100Points {
    return 0.8 / [Styles sizeModifier];
}

+ (NSUInteger)minimumItemsPerSelectionPage {
    return 2;
    //Don't set too high other wise it may be impossible to get a number of items per page
}

@end
