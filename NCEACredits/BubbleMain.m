//
//  BubbleMain.m
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleMain.h"
#import "Styles.h"

@implementation BubbleMain

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.colour = [Styles redColour];
        self.transform = CGAffineTransformMakeScale([Styles mainBubbleStartingScaleFactor], [Styles mainBubbleStartingScaleFactor]);
        
        CGFloat d = frame.size.width;
        
        //title 23-43% height of bubble
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, round(d*0.23), d, round(d*0.2))];
        self.title.text = [NSString stringWithFormat:@"Credits: %i", arc4random_uniform(100)];
        self.title.font = [Styles heading1Font];
        self.title.textColor = [Styles mainTextColour];
        self.title.textAlignment = NSTextAlignmentCenter;
        
        //credit labels 45-55% height - E 13-37% width, M 38-62%, A 63-88%
        _excellenceCredits = [[BubbleMainCredits alloc] initWithFrame:
                              CGRectMake(round(d*0.13), round(d*0.45), round(d*0.24), round(d*0.1))
                                                              andType:Excellence];
        _meritCredits = [[BubbleMainCredits alloc] initWithFrame:
                              CGRectMake(round(d*0.38), round(d*0.45), round(d*0.24), round(d*0.1))
                                                              andType:Merit];
        _achievedCredits = [[BubbleMainCredits alloc] initWithFrame:
                              CGRectMake(round(d*0.63), round(d*0.45), round(d*0.24), round(d*0.1))
                                                              andType:Achieved];
        
         //goal 65-85% height
        _goal = [[GoalTitle alloc] initWithFrame:CGRectMake(0, round(d*0.65), d, round(d*0.2))];
        
        
        [self addSubview:self.title];
        
        [self addSubview:_excellenceCredits];
        [self addSubview:_meritCredits];
        [self addSubview:_achievedCredits];
        
        [self addSubview:_goal];
        
        [self updateStats];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //circle
    [self.colour setFill];
    [[UIColor clearColor] setStroke];
    CGContextFillEllipseInRect(c, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    //chord
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(c, 2.0f);
    CGPoint left = [BubbleMain getChordVerticeWithRadius:self.bounds.size.width/2 andLeft:YES];
    CGPoint right = [BubbleMain getChordVerticeWithRadius:self.bounds.size.width/2 andLeft:NO];
    CGContextMoveToPoint(c, left.x - 1, left.y);
    CGContextAddLineToPoint(c, right.x + 1, right.y);
    
    CGContextStrokePath(c);
}

+ (CGPoint)getChordVerticeWithRadius:(CGFloat)r andLeft:(BOOL)getLeft { //yes==left,no==right
    if (getLeft == YES) {
        return CGPointMake(
                           round(r - sqrt(pow(r, 2) - pow((r/5), 2))),
                           round(1.2 * r));
    } else {
        return CGPointMake(
                           round(r + sqrt(pow(r, 2) - pow((r/5), 2))),
                           round(1.2 * r));
    }
}

//*
//****
//*********
//****************
//*************************
//************************************    Stats    ************************************
//*************************
//****************
//*********
//****
//*

- (void)updateStats {
#warning TODO: main bubble update stats
}


@end
