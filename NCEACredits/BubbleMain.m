//
//  BubbleMain.m
//  NCEACredits
//
//  Created by Dylan Chong on 5/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "BubbleMain.h"
#import "Styles.h"
#import "Grade.h"
#import "GoalMain.h"

#define CREDITS_FORMAT @"Credits: %lu"

@implementation BubbleMain

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.colour = [Styles redColour];
        self.transform = CGAffineTransformMakeScale([Styles mainBubbleStartingScaleFactor], [Styles mainBubbleStartingScaleFactor]);
        
        CGFloat d = frame.size.width;
        
        //title 23-43% height of bubble
        self.title = [[BubbleText alloc] initWithFrame:CGRectMake(0, round(d*0.23), d, round(d*0.2))
                                                  text:[NSString stringWithFormat:CREDITS_FORMAT, (unsigned long)333]
                                             fontOrNil:[Styles heading1Font]];
        
        //credit labels 45-55% height - E 9-36% width, M 36-63%, A 63-90%
        _excellenceCredits = [[BubbleMainCredits alloc] initWithFrame:
                              CGRectMake(round(d*0.09), round(d*0.45), round(d*0.27), round(d*0.1))
                                                     andGradeTextType:GradeTextExcellence];
        _meritCredits = [[BubbleMainCredits alloc] initWithFrame:
                         CGRectMake(round(d*0.36), round(d*0.45), round(d*0.27), round(d*0.1))
                                                andGradeTextType:GradeTextMerit];
        _achievedCredits = [[BubbleMainCredits alloc] initWithFrame:
                            CGRectMake(round(d*0.63), round(d*0.45), round(d*0.27), round(d*0.1))
                                                   andGradeTextType:GradeTextAchieved];
        
        //goal 65-85% height
        _goal = [[GoalTitle alloc] initWithFrame:CGRectMake(0, round(d*0.65), d, round(d*0.2))];
        
        [self addSubview:self.title];
        
        [self addSubview:_excellenceCredits];
        [self addSubview:_meritCredits];
        [self addSubview:_achievedCredits];
        
        [self addSubview:_goal];
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
    CGContextSetLineWidth(c, 2.0 * [Styles sizeModifier]);
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
#pragma mark - ***************************    Stats    ************************************
//*************************
//****************
//*********
//****
//*

- (void)updateStats {
    if ([CurrentProfile hasAllNecessaryInformationFromSetup]) {
        //credit stats
        NSDictionary *creds = [CurrentProfile getNumberOfAllCreditsForPriority:GradePriorityFinalGrade];
        
        NSUInteger exc = [[creds objectForKey:GradeTextExcellence] integerValue];
        NSUInteger mer = [[creds objectForKey:GradeTextMerit] integerValue];
        NSUInteger ach = [[creds objectForKey:GradeTextAchieved] integerValue];
        
        [_excellenceCredits setNumberOfCredits:exc];
        [_meritCredits setNumberOfCredits:mer];
        [_achievedCredits setNumberOfCredits:ach];
        
        [self setTitleCredits:exc + mer + ach];
        
        //goal
        NSString *goalTitle = CurrentProfile.selectedGoalTitle;
        Goal *goal = [DefaultGoals getGoalForTitle:goalTitle];
        NSString *grade = goal.primaryGrade;
        NSUInteger level = [CurrentProfile getPrimaryNCEALevelForCurrentYear];
        NSUInteger credits = [CurrentProfile getNumberOfCreditsForGradeIncludingBetterGrades:grade priority:GradePriorityFinalGrade andLevel:level];
        NSUInteger creditReq = [goal getRequirementForLevel:level];
        
        [_goal resetTextWithCredits:credits outOf:creditReq grade:grade andTitle:goalTitle];
    }
}

- (void)setTitleCredits:(NSUInteger)credits {
    self.title.text = [NSString stringWithFormat:CREDITS_FORMAT, (unsigned long)credits];
}

@end
