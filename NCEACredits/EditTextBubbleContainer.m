//
//  EditTextBubbleContainer.m
//  NCEACredits
//
//  Created by Dylan Chong on 16/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextBubble.h"

@implementation EditTextBubbleContainer

- (id)initWithPositionCalculatorBlock:(PositionCalculationBlock)pos frameForStartingPosition:(CGRect)frameForStartingPosition itemData:(EditTextScreenItemData *)itemData towardsRightSide:(BOOL)isTowardsRight andDelegate:(id)delegate {
    if ([Styles rect:frameForStartingPosition isEqualToRect:CGRectZero]) {
        self = [super initWithFrame:pos()];
    } else {
        self = [super initWithFrame:[Styles getRectCentreOfFrame:frameForStartingPosition withSize:pos().size]];
        self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
    }
    
    if (self) {
        _touchDelegate = delegate;
        _type = [itemData.type intValue];
        self.backgroundColor = [UIColor clearColor];
        self.calulatePosition = pos;
        self.bubble = [[EditTextBubble alloc] initWithFrame:
                       [Styles getRectCentreOfFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                           withSize:CGSizeMake(self.frame.size.width * 0.95, self.frame.size.height * 0.95)]
                                                      title:itemData.title
                                                       text:itemData.text
                                            placeHolderText:itemData.placeholder
                                           towardsRightSide:isTowardsRight
                                                    andType:[itemData.type intValue]];
        [self addSubview:self.bubble];
        [((EditTextBubble *)(self.bubble)).viewContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
        
        if (![Styles rect:frameForStartingPosition isEqualToRect:CGRectZero]) {
            self.bubble.transform = CGAffineTransformMakeScale([Styles startingScaleFactor], [Styles startingScaleFactor]);
            self.userInteractionEnabled = NO;
        } else {
            self.userInteractionEnabled = YES;
        }
        
        [self.bubble startWiggle];
    }
    return self;
}

- (void)touch {
    [self.touchDelegate editTheTextView:self];
}

@end
