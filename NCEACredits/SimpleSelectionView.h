//
//  SimpleSelectionView.h
//  NCEACredits
//
//  Created by Dylan Chong on 19/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleView.h"

@interface SimpleSelectionView : BubbleView

+ (CGRect)getPositionOfObjectAtIndex:(int)index outOfBubbles:(int)bubbles size:(CGSize)size fromCorner:(Corner)corner;
+ (double)getRadius;

@end