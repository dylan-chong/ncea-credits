//
//  Styles.m
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Styles.h"

@implementation Styles

+ (float)sizeModifier {
    Device d = [Styles getDevice];
//    if (d == iPhone4Inch || d == iPhone3_5Inch) {
    if (d == iPhone) {
        return 0.5;
    }
    return 1; //iPad
}

+ (Device)getDevice {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location == NSNotFound) {
//        if ([[UIScreen mainScreen] bounds].size.height == 480) {
//            //NSLog(@"iPhone/iPod 3.5 inch");
//            return iPhone3_5Inch;
//        } else {
//            //NSLog(@"iPhone/iPod 4 inch");
//            return iPhone4Inch;
//        }
        return iPhone;
    } else {
        //NSLog(@"iPad");
        return iPad;
    }
}

+ (float)startingScaleFactor {  return 0.01;    }
+ (float)mainBubbleStartingScaleFactor {    return 0.25; } //changing this will require changing launch image size (340 * this * sizeModifier * 0.75)
+ (float)animationSpeed {
    if (SPEED_MODE && DEBUG_MODE_ON) return 0.15;
    else if (SLOW_MODE && DEBUG_MODE_ON) return 0.4;
    else return 0.3;
}

+ (double)frameRate {
    return 30.0; //Do not change unless you alter animation class formula
}

+ (BOOL)rect:(CGRect)r1 isEqualToRect:(CGRect)r2 {
    if (r1.origin.x == r2.origin.x &&
        r1.origin.y == r2.origin.y &&
        r1.size.width == r2.size.width &&
        r1.size.height == r2.size.height) return YES;
    else return NO;
}

+ (BOOL)point:(CGPoint)r1 isEqualToPoint:(CGPoint)r2 {
    if (r1.x == r2.x && r1.y == r2.y) return YES;
    else return NO;
}

+ (BOOL)size:(CGSize)s1 isEqualToSize:(CGSize)s2 {
    if (s1.width == s2.width && s1.height == s2.height) return YES;
    else return NO;
}

+ (CGFloat)degreesToRadians:(CGFloat)d {
    return d * M_PI / 180;
}

+ (CGFloat)radiansToDegrees:(CGFloat)r {
    return r * 180 / M_PI;
}

+ (NSArray *)sortArray:(NSArray *)array {
    return [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
