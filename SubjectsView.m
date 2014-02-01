//
//  SubjectsView.m
//  NCEACredits
//
//  Created by Dylan Chong on 20/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsView.h"

@implementation SubjectsView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, [Styles screenWidth], [Styles screenHeight])];
    if (self) {
        [self createBubbleContainers];
    }
    return self;
}

- (void)createBubbleContainers {
    NSArray *subjectTitles = [[NSArray alloc] initWithObjects:@"Mathematics", @"Science", @"English", nil];
    
    BubbleContainer *b;
    PositionCalculationBlock p;
    NSUInteger count = subjectTitles.count;
    for (int a = 0; a < count; a++) {
        p = ^{
            return [SimpleSelectionView getPositionOfObjectAtIndex:a outOfBubbles:count size:[Styles subtitleContainerSize] fromCorner:BottomRight];
        };
        
        
    }
}

@end
