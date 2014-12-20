//
//  Styles.h
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

//corner
typedef NS_ENUM(NSInteger, Corner) {
    TopLeft = 1,
    TopRight,
    BottomLeft,
    BottomRight,
    NotValid
} ;


//device
typedef NS_ENUM(NSInteger, Device) {
    iPad = 1,
//    iPhone3_5Inch = 1,
//    iPhone4Inch = 2,
    iPhone
};

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Main    ************************************
//*************************
//****************
//*********
//****
//*
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
+ (BOOL)size:(CGSize)s1 isEqualToSize:(CGSize)s2;
+ (CGFloat)degreesToRadians:(CGFloat)d;
+ (CGFloat)radiansToDegrees:(CGFloat)r;
+ (BOOL)deviceIsInLandscape;
+ (double)frameRate;

@end

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Fonts    ************************************
//*************************
//****************
//*********
//****
//*
@interface Styles (Fonts)

+ (UIFont *)heading1Font;
+ (UIFont *)heading2Font;
+ (UIFont *)bodyFont;
+ (UIFont *)heading3Font;
+ (UIFont *)body2Font;
+ (UIFont *)bigTextFont;
+ (UIFont *)captionFont;

@end

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Colours    ************************************
//*************************
//****************
//*********
//****
//*
@interface Styles (Colours)

+ (UIColor *)mainTextColour;
+ (UIColor *)cyanColour;
+ (UIColor *)greenColour;
+ (UIColor *)orangeColour;
+ (UIColor *)pinkColour;
+ (UIColor *)blueColour;
+ (UIColor *)redColour;
+ (UIColor *)greyColour;
+ (UIColor *)darkGreyColour;
+ (UIColor *)lightGreyColour;
+ (UIColor *)translucentWhite;

+ (BOOL)colour:(UIColor *)colourA isTheSameAsColour:(UIColor *)colourB;

@end

#define StandardScrollArrowWidth 45
#define StandardScrollArrowHeight 15
#define StandardScrollArrowSpaceFromEdge 25

#define StandardScrollArrowShowAlpha 0.75

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Layouts    ************************************
//*************************
//****************
//*********
//****
//*

@interface Styles (Layout)

+ (CGRect)mainContainerRect;
+ (CGRect)titleContainerRectWithCorner:(Corner)c;
+ (CGSize)titleContainerSize;
+ (CGSize)subtitleContainerSize;
+ (float)spaceFromEdgeOfScreen;
+ (CGRect)getBubbleFrameWithContainerFrame:(CGRect)frame;
+ (Corner)getOppositeCornerToCorner:(Corner)c;
+ (Corner)getCornerWithTitleContainerFrame:(CGRect)r;
+ (CGPoint)getExactOriginForCorner:(Corner)c andSize:(CGSize)size;
+ (Corner)getCornerForPoint:(CGPoint)point;
+ (CGRect)getRectCentreOfFrame:(CGRect)rect withSize:(CGSize)size;
+ (CGSize)editTextBubbleSize;
+ (float)numberOfItemsInSelectionViewPer100px;
+ (NSUInteger)minimumItemsPerSelectionPage;

@end