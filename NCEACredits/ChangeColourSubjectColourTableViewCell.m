//
//  ChangeColourSubjectColourTableViewCell.m
//  NCEACredits
//
//  Created by Dylan Chong on 9/01/15.
//  Copyright (c) 2015 PiGuyGames. All rights reserved.
//

#import "ChangeColourSubjectColourTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define COLOUR_HEIGHT_DECIMAL 0.8
#define CORNER_RADIUS 6.0 * [Styles sizeModifier]
#define COLOUR_WIDTH_OR_HEIGHT 30 * [Styles sizeModifier]

@implementation ChangeColourSubjectColourTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self layoutIfNeeded];
    
    //    //Colour View
    //    //Size
    //    CGRect rect;
    //    rect.size.height = self.frame.size.height * COLOUR_HEIGHT_DECIMAL; //80% height
    //    rect.size.width = rect.size.height;
    //
    //    //Position
    //    CGFloat gap = self.frame.size.height * (1 - COLOUR_HEIGHT_DECIMAL) / 2;
    //    rect.origin.y = gap;
    //    rect.origin.x = self.frame.size.width - rect.size.width - gap;
    
    UIView *c = [[UIView alloc] init];
    c.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:c];
    
    //Auto layout
    NSDictionary *viewsDict = @{@"c":c, @"self":self};
    
    NSString *widthString = [NSString stringWithFormat:@"H:[c(%f)]", COLOUR_WIDTH_OR_HEIGHT];
    NSString *heightString = [NSString stringWithFormat:@"V:[c(%f)]", COLOUR_WIDTH_OR_HEIGHT];
    NSString *xString = [NSString stringWithFormat:@"H:[self]-(<=1)-[c]-%f-|", 20 * [Styles sizeModifier] + 27];
    
    NSArray *constrWidth =
    [NSLayoutConstraint constraintsWithVisualFormat:widthString
                                            options:0
                                            metrics:nil
                                              views:viewsDict];
    NSArray *constrHeight =
    [NSLayoutConstraint constraintsWithVisualFormat:heightString
                                            options:0
                                            metrics:nil
                                              views:viewsDict];
    NSArray *constrX =
    [NSLayoutConstraint constraintsWithVisualFormat:xString
                                            options:NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:viewsDict];

    
    [self addConstraints:constrWidth];
    [self addConstraints:constrHeight];
    [self addConstraints:constrX];
    
    
    [c setBackgroundColor:[UIColor blackColor]];
    [c.layer setCornerRadius:CORNER_RADIUS];
    
    _colourView = c;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setColourViewColour:(UIColor *)colour {
    [_colourView setBackgroundColor:colour];
}

@end
