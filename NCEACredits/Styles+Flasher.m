//
//  Styles+Flasher.m
//  NCEACredits
//
//  Created by Dylan Chong on 17/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "Styles.h"

#define OVERLAY_COLOUR [UIColor whiteColor]
#define FLASH_SPEED [Styles animationSpeed]
#define DEFAULT_SIZE_INCREASE 1.5

@implementation Styles (Flasher)

+ (void)flashStartWithView:(UIView *)view numberOfTimes:(NSUInteger)times sizeIncreaseMultiplierOr0ForDefault:(CGFloat)sizeMultiplier {
    CGFloat sm = (sizeMultiplier > 0) ? sizeMultiplier : DEFAULT_SIZE_INCREASE;
    [self flashOffWithView:view originalTransform:view.transform sizeMultiplier:sm andTimesLeft:times];
}

+ (void)flashOffWithView:(UIView *)view originalTransform:(CGAffineTransform)originalTransform sizeMultiplier:(CGFloat)sizeMultiplier andTimesLeft:(NSUInteger)timesLeft {
    [UIView animateWithDuration:FLASH_SPEED animations:^{
        //Scale up
        view.transform = [self getTransformForSizeIncrease:sizeMultiplier andTransform:view.transform];
        
    } completion:^(BOOL finished) {
        [self flashOnWithView:view originalTransform:originalTransform sizeMultiplier:sizeMultiplier andTimesLeft:timesLeft];
    }];
}

+ (void)flashOnWithView:(UIView *)view originalTransform:(CGAffineTransform)originalTransform sizeMultiplier:(CGFloat)sizeMultiplier andTimesLeft:(NSUInteger)timesLeft {
    [UIView animateWithDuration:FLASH_SPEED animations:^{
        //Scale up
        view.transform = [self getTransformForSizeIncrease:1/sizeMultiplier andTransform:view.transform];
        
    } completion:^(BOOL finished) {
        if (timesLeft > 1)
            [self flashOffWithView:view originalTransform:originalTransform sizeMultiplier:sizeMultiplier andTimesLeft:timesLeft - 1];
        else
            [self flashEndWithView:view originalTransform:originalTransform];
    }];
}

+ (void)flashEndWithView:(UIView *)view originalTransform:(CGAffineTransform)originalTransform {
    [UIView animateWithDuration:FLASH_SPEED animations:^{
        view.transform = originalTransform;
    }];
}

//------------------------------ Size modifier ------------------------------
+ (CGAffineTransform)getTransformForSizeIncrease:(CGFloat)sizeIncrease andTransform:(CGAffineTransform)trans {
    CGFloat currentXScale = sqrt(pow(trans.a, 2) + pow(trans.c, 2));
    CGFloat currentYScale = sqrt(pow(trans.b, 2) + pow(trans.d, 2));
    
    return CGAffineTransformMakeScale(currentXScale * sizeIncrease, currentYScale * sizeIncrease);
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Delayed    ************************************
//*************************
//****************
//*********
//****
//*

+ (CGFloat)getDurationOfAnimationWithFlashTimes:(NSUInteger)times {
    return (2 * times + 1) * FLASH_SPEED;

}

@end
