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

#define ANIMATION_SPEED_SELECTION_INCREMENT 0.1
#define ANIMATION_SPEED_SELECTION_NORMAL 0.3
typedef NS_ENUM(NSInteger, AnimationSpeedSelection) {
    AnimationSpeedSelectionNormal = 1,
    AnimationSpeedSelectionFaster,
    AnimationSpeedSelectionFast,
    AnimationSpeedSelectionSlow,
    AnimationSpeedSelectionSlower
};
#define ANIMATION_SPEED_LOAD_MULTIPLIER 1.5

#define TOO_MANY_CREDITS_FOR_ASSESSMENT 15

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

+ (CGFloat)sizeModifier;
+ (Device)getDevice;
+ (CGFloat)startingScaleFactor;
+ (CGFloat)mainBubbleStartingScaleFactor;
+ (CGFloat)animationSpeed;
+ (BOOL)rect:(CGRect)r1 isEqualToRect:(CGRect)r2;
+ (BOOL)point:(CGPoint)r1 isEqualToPoint:(CGPoint)r2;
+ (BOOL)size:(CGSize)s1 isEqualToSize:(CGSize)s2;
+ (CGFloat)degreesToRadians:(CGFloat)d;
+ (CGFloat)radiansToDegrees:(CGFloat)r;
+ (CGFloat)frameRate;
+ (NSArray *)sortArray:(NSArray *)array;
+ (NSArray *)sortArray:(NSArray *)array byPropertyKey:(NSString *)key ascending:(BOOL)ascending;

+ (NSString *)getRandomOKTitle;
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
+ (CGFloat)minimumFontSize;

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

#define ANCHOR_THICKNESS 2.5

@interface Styles (Colours)

+ (UIColor *)mainTextColour;
+ (UIColor *)greenColour;
+ (UIColor *)orangeColour;
+ (UIColor *)pinkColour;
+ (UIColor *)purpleColour;
+ (UIColor *)blueColour;
+ (UIColor *)redColour;
+ (UIColor *)greyColour;
+ (UIColor *)darkGreyColour;
+ (UIColor *)lightGreyColour;
+ (UIColor *)translucentWhite;
+ (UIColor *)lightBlueColour;
+ (UIColor *)mediumDarkGreyColour;
+ (UIColor *)mediumLightGreyColour;
+ (UIColor *)goldColour;

+ (BOOL)colour:(UIColor *)colourA isTheSameAsColour:(UIColor *)colourB;
+ (NSArray *)getSortedDefaultColours;

@end

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

#define BUBBLE_TO_BUBBLE_CONTAINER_SIZE_RATIO 0.75

@interface Styles (Layout)

+ (CGRect)mainContainerRect;
+ (CGRect)titleContainerRectWithCorner:(Corner)c;
+ (CGSize)titleContainerSize;
+ (CGSize)subtitleContainerSize;
+ (CGFloat)spaceFromEdgeOfScreen;
+ (CGRect)getBubbleFrameWithContainerSize:(CGSize)size;
+ (Corner)getOppositeCornerToCorner:(Corner)c;
+ (Corner)getCornerWithTitleContainerFrame:(CGRect)r;
+ (CGPoint)getExactOriginForCorner:(Corner)c andSize:(CGSize)size;
+ (Corner)getCornerForPoint:(CGPoint)point;
+ (BOOL)cornerIsLeft:(Corner)corner;
+ (BOOL)cornerIsTop:(Corner)corner;
+ (CGRect)getRectCentreOfFrame:(CGRect)rect withSize:(CGSize)size;
+ (CGSize)editTextBubbleSize;
+ (CGFloat)numberOfItemsInSelectionViewPer100Points;
+ (NSUInteger)minimumItemsPerSelectionPage;

@end

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Flasher    ************************************
//*************************
//****************
//*********
//****
//*

#define FLASH_DEFAULT_TIMES 2
#define FLASH_EDIT_TEXT_SCROLL_ARROW_TIMES FLASH_DEFAULT_TIMES
#define FLASH_BUBBLE_VC_MAIN_BUBBLE_TIMES FLASH_DEFAULT_TIMES - 1
@interface Styles (Flasher)

+ (void)flashStartWithView:(UIView *)view numberOfTimes:(NSUInteger)times sizeIncreaseMultiplierOr0ForDefault:(CGFloat)sizeMultiplier;
+ (CGFloat)getDurationOfAnimationWithFlashTimes:(NSUInteger)times;

@end