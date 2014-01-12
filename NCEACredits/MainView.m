//
//  MainView.m
//  NCEACredits
//
//  Created by Dylan Chong on 11/01/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)init {
    self = [super init];
    if (self) {
        [self createBubbleContainers];
    }
    return self;
}

- (void)createBubbleContainers {
    self.mainBubble = [[BubbleContainer alloc] initMainBubble];
    self.mainBubble.delegate = self;
    [self addSubview:self.mainBubble];
    
    [self setMainBubble:self.mainBubble
        andChildBubbles:[NSArray arrayWithObjects:
                           [[BubbleContainer alloc] initTitleBubbleWithFrame:[Styles titleContainerRectWithCorner:TopLeft] colour:[Styles greenColour] iconName:@"Add.png" title:@"Add" andDelegate:NO],
                           [[BubbleContainer alloc] initTitleBubbleWithFrame:[Styles titleContainerRectWithCorner:TopRight] colour:[Styles pinkColour] iconName:@"Subjects.png" title:@"Subjects" andDelegate:NO],
                           [[BubbleContainer alloc] initTitleBubbleWithFrame:[Styles titleContainerRectWithCorner:BottomLeft] colour:[Styles blueColour] iconName:@"Stats.png" title:@"Stats" andDelegate:NO],
                           [[BubbleContainer alloc] initTitleBubbleWithFrame:[Styles titleContainerRectWithCorner:BottomRight] colour:[Styles orangeColour] iconName:@"Options.png" title:@"Options" andDelegate:NO],
                           nil]];
    
    
    _addContainer = self.childBubbles[0];
    [self addSubview:_addContainer];
    
    _subjectsContainer = self.childBubbles[1];
    [self addSubview:_subjectsContainer];
    
    _statsContainer = self.childBubbles[2];
    [self addSubview:_statsContainer];
    
    _optionsContainer = self.childBubbles[3];
    [self addSubview:_optionsContainer];
    
    [self bringSubviewToFront:self.mainBubble];
    
    /*[self startChildBubbleCreationAnimation];
    [NSTimer scheduledTimerWithTimeInterval:[Styles slidingAnimationSpeed]
                            target:self.mainBubble
                          selector:@selector(startGrowingAnimationFromTimer:)
                          userInfo:[NSNumber numberWithFloat:[Styles mainBubbleStartingScaleFactor]]
                           repeats:NO];*/
}

@end
