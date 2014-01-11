//
//  AnchorView.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnchorView : UIView

@property (nonatomic) CGPoint startingPoint;
@property (nonatomic) NSArray *pointsToDrawTo;

- (id)initWithStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo;
- (void)setStartingPoint:(CGPoint)startingPoint andPointsToDrawTo:(NSArray *)pointsToDrawTo;

@end
