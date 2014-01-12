//
//  Bubble.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Bubble.h"
#import "Styles.h"

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};


@implementation Bubble

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colour = colour;
        self.clipsToBounds = YES;
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        
        //title 60-85% height of bubble
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, round(h*0.6), w, round(h*0.25))];
        _title.text = title;
        _title.font = [Styles heading2Font];
        _title.textColor = [Styles mainTextColour];
        _title.textAlignment = NSTextAlignmentCenter;
        
        //icon 10-60%
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, round(h*0.1), w, round(h*0.5))];
        _icon.image = [UIImage imageNamed:iconName];
        
        _usesDelegateToCallRedrawAnchors = hasDelegate;
        
        [self addSubview:_title];
        [self addSubview:_icon];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    if (!_colour) _colour = [UIColor darkGrayColor];
    [_colour setFill];
    [[UIColor clearColor] setStroke];
    
    CGContextAddEllipseInRect(c, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CGContextFillPath(c);
}

//********************************** Wiggle ************************************

- (void)startWiggle {
    _direction = arc4random() % 360;
    _clockwise = arc4random() % 2;
    _wiggleSpeedFPS = 30.0;
    _wiggleSpeedPixelsPerFrame = (0.05 + (arc4random_uniform(1000) / 1000.0 * 0.1)) * [Styles sizeModifier];
    _wiggleTurnSpeed = 1 + arc4random_uniform(3);
    
    _wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:1/_wiggleSpeedFPS target:self selector:@selector(wiggle) userInfo:Nil repeats:YES];
}

- (void)wiggle {
    
    float xMov = sin(DegreesToRadians(_direction)) * _wiggleSpeedPixelsPerFrame;
    float yMov = cos(DegreesToRadians(_direction)) * _wiggleSpeedPixelsPerFrame;

    CGPoint original = self.center;
    self.center = CGPointMake(original.x + xMov, original.y + yMov);
    
    if (_clockwise == YES) {
        _direction += _wiggleTurnSpeed;
        if (_direction > 359) _direction = 0;
    } else {
        _direction -= _wiggleTurnSpeed;
        if (_direction < 0) _direction = 359;
    }
    
    if (_usesDelegateToCallRedrawAnchors == YES) {
        [self.delegate redrawAnchors];
    }
}

- (void)stopWiggle {
    [_wiggleTimer invalidate];
    _wiggleTimer = nil;
    
    float centerX = self.frame.size.width * (4.0/3) / 2;
    CGPoint centreOfContainer = CGPointMake(centerX, centerX);
    
    [UIView animateWithDuration: [self secondsForPixelsToMoveBetweenPoint:self.center andPoint:centreOfContainer] animations:^{
        self.center = centreOfContainer;
    }];
}

- (float)secondsForPixelsToMoveBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB {
    float xDif = abs(pointA.x - pointB.x);
    float yDif = abs(pointA.y - pointB.y);
    
    float distance = sqrtf(powf(xDif, 2) + powf(yDif, 2));
    float seconds = distance / _wiggleSpeedPixelsPerFrame / _wiggleSpeedFPS;
    
    return seconds;
}

@end

