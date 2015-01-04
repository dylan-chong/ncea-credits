//
//  Styles+Colours.m
//  NCEACredits
//
//  Created by Dylan Chong on 6/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Styles.h"

@implementation Styles (Colours)

#define RGB(redLevel, greenLevel, blueLevel) [UIColor colorWithRed:redLevel/255.0 green:greenLevel/255.0 blue:blueLevel/255.5 alpha:1.0]
+ (UIColor *)mainTextColour {       return [UIColor whiteColor];}
+ (UIColor *)cyanColour{            return RGB(51, 172, 227);}
+ (UIColor *)greenColour{           return RGB(144, 217, 75);}
+ (UIColor *)orangeColour{          return RGB(255, 153, 42);}
+ (UIColor *)pinkColour{            return RGB(242, 99, 131);}
+ (UIColor *)blueColour{            return RGB(24, 94, 189);}
+ (UIColor *)redColour{             return RGB(205, 20, 20);}

+ (UIColor *)darkGreyColour{        return [UIColor colorWithWhite:75/255.0 alpha:1.0];}
+ (UIColor *)mediumDarkGreyColour{  return [UIColor colorWithWhite:107/255.0 alpha:1.0];}
+ (UIColor *)greyColour{            return [UIColor colorWithWhite:140/255.0 alpha:1.0];}
+ (UIColor *)mediumLightGreyColour{ return [UIColor colorWithWhite:170/255.0 alpha:1.0];}
+ (UIColor *)lightGreyColour{       return [UIColor colorWithWhite:215/255.0 alpha:1.0];}

+ (UIColor *)translucentWhite{      return [UIColor colorWithWhite:1.0 alpha:0.97];}
+ (UIColor *)lightBlueColour{       return RGB(51, 172, 227);}

#define ROUNDCGFLOAT(varName) varName = roundf(varName * 255);
+ (BOOL)colour:(UIColor *)colourA isTheSameAsColour:(UIColor *)colourB {
    CGFloat redA, greenA, blueA, alphaA, redB, greenB, blueB, alphaB;
    [colourA getRed:&redA green:&greenA blue:&blueA alpha:&alphaA];
    [colourB getRed:&redB green:&greenB blue:&blueB alpha:&alphaB];

    ROUNDCGFLOAT(redA);
    ROUNDCGFLOAT(greenA);
    ROUNDCGFLOAT(blueA);
    ROUNDCGFLOAT(alphaA);
    ROUNDCGFLOAT(redB);
    ROUNDCGFLOAT(greenB);
    ROUNDCGFLOAT(blueB);
    ROUNDCGFLOAT(alphaB);
    
    if (redA == redB && greenA == greenB && blueA == blueB && alphaA == alphaB)
        return YES;
    else
        return NO;
}


+ (NSArray *)getSortedDefaultColours {
    
    //Returns the order (and colours) for them to be automatically set
    return @[[Styles redColour], //red
             [Styles greenColour], //lime green
             [Styles blueColour], //darkish blue
             [Styles orangeColour], //orange
             [Styles pinkColour], //pink/magenta
             [Styles lightBlueColour], //light blue (cyanish)
             [Styles greyColour], //medium grey
             [Styles darkGreyColour], //dark grey (blackish)
             [Styles lightGreyColour], //light grey
             [Styles mediumDarkGreyColour], //medium-dark grey
             [Styles mediumLightGreyColour], //medium-light grey
             ];
}

@end
