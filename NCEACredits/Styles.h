//
//  Styles.h
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

//corner
typedef enum {
    TopLeft = 0,
    TopRight = 1,
    BottomLeft = 2,
    BottomRight = 3,
    NotValid = 4
} Corner;


//device
typedef enum {
    iPad = 0,
    iPhone3_5Inch = 1,
    iPhone4Inch = 2
} Device;

//********************************************* Main *********************************************
@interface Styles : NSObject

+ (float)sizeModifier;
+ (Device)getDevice;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (float)startingScaleFactor;
+ (float)mainBubbleStartingScaleFactor;
+ (float)animationSpeed;
+ (BOOL)rect:(CGRect)r1 isEqualToRect:(CGRect)r2;
+ (BOOL)point:(CGPoint)r1 isEqualToPoint:(CGPoint)r2;

@end

//********************************************* Fonts *********************************************
@interface Styles (Fonts)

+ (UIFont *)heading1Font;
+ (UIFont *)heading2Font;
+ (UIFont *)bodyFont;
+ (UIFont *)captionFont;

@end

//******************************************** Colours *********************************************
@interface Styles (Colours)

+ (UIColor *)mainTextColour;
+ (UIColor *)cyanColour;
+ (UIColor *)greenColour;
+ (UIColor *)orangeColour;
+ (UIColor *)pinkColour;
+ (UIColor *)blueColour;
+ (UIColor *)redColour;
+ (UIColor *)greyColour;

@end

//********************************************* Layout *********************************************

@interface Styles (Layout)

+ (CGRect)mainContainerRect;
+ (CGRect)titleContainerRectWithCorner:(Corner)c;
+ (float)spaceFromEdgeOfScreen;
+ (CGRect)getBubbleFrameWithContainerFrame:(CGRect)frame;
+ (CGRect)getFullScreenFrame;
+ (Corner)getOppositeCornerToCorner:(Corner)c;
+ (Corner)getCornerWithTitleContainerFrame:(CGRect)r;
+ (CGPoint)getExactCornerPointForCorner:(Corner)c;
+ (Corner)getCornerForExactCornerPoint:(CGPoint)point;

@end