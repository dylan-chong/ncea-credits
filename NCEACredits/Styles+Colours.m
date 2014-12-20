//
//  Styles+Colours.m
//  NCEACredits
//
//  Created by Dylan Chong on 6/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Styles.h"

@implementation Styles (Colours)

+ (UIColor *)mainTextColour {       return [UIColor whiteColor];}
+ (UIColor *)cyanColour{            return [UIColor colorWithRed:51.0/255 green:172.0/255 blue:227.0/255 alpha:1.0];}
+ (UIColor *)greenColour{           return [UIColor colorWithRed:144.0/255 green:217.0/255 blue:75.0/255 alpha:1.0];}
+ (UIColor *)orangeColour{          return [UIColor colorWithRed:255.0/255 green:153.0/255 blue:42.0/255 alpha:1.0];}
+ (UIColor *)pinkColour{            return [UIColor colorWithRed:242.0/255 green:99.0/255 blue:131.0/255 alpha:1.0];}
+ (UIColor *)blueColour{            return [UIColor colorWithRed:24.0/255 green:94.0/255 blue:189.0/255 alpha:1.0];}
+ (UIColor *)redColour{             return [UIColor colorWithRed:205.0/255 green:20.0/255 blue:20.0/255 alpha:1.0];}
+ (UIColor *)greyColour{            return [UIColor colorWithRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:1.0];}
+ (UIColor *)darkGreyColour{        return [UIColor colorWithWhite:100.0/255 alpha:1.0];}
+ (UIColor *)lightGreyColour{       return [UIColor colorWithWhite:230.0/255 alpha:1.0];}
+ (UIColor *)translucentWhite{      return [UIColor colorWithWhite:1.0 alpha:0.97];}

+ (BOOL)colour:(UIColor *)colourA isTheSameAsColour:(UIColor *)colourB {
    CGFloat redA, greenA, blueA, alphaA, redB, greenB, blueB, alphaB;
    [colourA getRed:&redA green:&greenA blue:&blueA alpha:&alphaA];
    [colourB getRed:&redB green:&greenB blue:&blueB alpha:&alphaB];
    if (redA == redB && greenA == greenB && blueA == blueB && alphaA == alphaB)
        return YES;
    else
        return NO;
}

#warning TODO: merge colours with subjects and colorus
@end
