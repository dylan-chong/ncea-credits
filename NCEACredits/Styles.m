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
    float a = 1;
    Device d = [Styles getDevice];
    if (d == iPhone4Inch || d == iPhone3_5Inch) {
        a = 0.5;
    }
    return a;
}

+ (Device)getDevice {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        if ([Styles screenWidth] == 480) {
            //NSLog(@"iPhone/iPod 3.5 inch");
            return iPhone3_5Inch;
        } else {
            //NSLog(@"iPhone/iPod 4 inch");
            return iPhone4Inch;
        }
    } else {
        //NSLog(@"iPad");
        return iPad;
    }
}

+ (CGFloat)screenWidth {    return [[UIScreen mainScreen] bounds].size.height;  }
+ (CGFloat)screenHeight {   return [[UIScreen mainScreen] bounds].size.width;  }

+ (float)startingScaleFactor {  return 0.05;    }
+ (float)mainBubbleStartingScaleFactor {    return 0.25; }
+ (float)slidingAnimationSpeed {    return 1.0; }
+ (float)growingAnimationSpeed {    return 1.0; }

@end
