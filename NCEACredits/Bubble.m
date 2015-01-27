//
//  Bubble.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "Bubble.h"
#import "Styles.h"

@implementation Bubble

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour iconName:(NSString *)iconName title:(NSString *)title andDelegate:(BOOL)hasDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        _colour = colour;
        
        float w = frame.size.width;
        float h = frame.size.height;
        
        //title 60-85% height of bubble
        _title = [[BubbleText alloc] initWithFrame:CGRectMake(w*0.12, (h*0.6), w*0.76, (h*0.25))
                                              text:title
                                         fontOrNil:[Styles heading2Font]];
        
        //icon 10-60%
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (h*0.1), w, (h*0.5))];
        if (!([iconName isEqualToString:@""] || !iconName)) _icon.image = [UIImage imageNamed:iconName];
        
        
        self.wiggles = YES;
        [self addSubview:_title];
        [self addSubview:_icon];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame colour:(UIColor *)colour title:(NSString *)title andDelegate:(BOOL)hasDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colour = colour;
        self.clipsToBounds = NO;
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        
        //Title should make up most of the bubble
        CGFloat spaceFillDecimal = BUBBLE_WITHOUT_ICON_TEXT_FIELD_SPACE_FILL_DECIMAL;
        _title = [[BubbleText alloc] initWithFrame:CGRectMake(w*(1-spaceFillDecimal)/2, h*(1-spaceFillDecimal)/2, w*spaceFillDecimal, h*spaceFillDecimal)
                                              text:title
                                         fontOrNil:nil];
        
        self.wiggles = YES;
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

- (CGPoint)getAnchorPoint {
    return self.center;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Wiggle    ************************************
//*************************
//****************
//*********
//****
//*


- (void)setupWiggle {
    _direction = arc4random() % 360;
    _clockwise = arc4random() % 2;
    _wiggleSpeedPixelsPerFrame = (0.05 + (arc4random_uniform(1000) / 1000.0 * 0.1)) * [Styles sizeModifier];
    _wiggleTurnSpeed = (1 + arc4random_uniform(3));
    
    self.hasSetupWiggle = YES;
}

- (void)wiggle {
    if (!self.hasSetupWiggle && _wiggles) {
        [self setupWiggle];
    }
    
    if (_wiggles) {
        float xMov = sin([Styles degreesToRadians:_direction]) * _wiggleSpeedPixelsPerFrame;
        float yMov = cos([Styles degreesToRadians:_direction]) * _wiggleSpeedPixelsPerFrame;
        
        CGPoint original = self.center;
        self.center = CGPointMake(original.x + xMov, original.y + yMov);
        
        if (_clockwise == YES) {
            _direction += _wiggleTurnSpeed;
            if (_direction > 359) _direction = 0;
        } else {
            _direction -= _wiggleTurnSpeed;
            if (_direction < 0) _direction = 359;
        }
    }
}

- (float)secondsForPixelsToMoveBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB {
    float xDif = abs(pointA.x - pointB.x);
    float yDif = abs(pointA.y - pointB.y);
    
    float distance = sqrtf(powf(xDif, 2) + powf(yDif, 2));
    float seconds = distance / _wiggleSpeedPixelsPerFrame / [Styles frameRate];
    
    return seconds;
}

@end

