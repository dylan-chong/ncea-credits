//
//  Styles.h
//  NCEACredits
//
//  Created by Dylan Chong on 6/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Styles.h"

@implementation Styles (Fonts)

+ (UIFont *)heading1Font{   return [UIFont fontWithName:@"Comfortaa-Bold" size:36.0 * [Styles sizeModifier]];   }
+ (UIFont *)heading2Font{   return [UIFont fontWithName:@"Comfortaa-Bold" size:24.0 * [Styles sizeModifier]];   }
+ (UIFont *)heading3Font{   return [UIFont fontWithName:@"Comfortaa-Bold" size:21.0 * [Styles sizeModifier]];   }
+ (UIFont *)bodyFont{   return [UIFont fontWithName:@"Comfortaa-Bold" size:18.0 * [Styles sizeModifier]];   }
+ (UIFont *)captionFont{   return [UIFont fontWithName:@"Comfortaa-Bold" size:16.0 * [Styles sizeModifier]];    }

@end