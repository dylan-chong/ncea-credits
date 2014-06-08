//
//  AddViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 18/02/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "AddViewController.h"
#import "EditTextBubble.h"
#import "EditTextScreenItemData.h"

@implementation AddViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.staggered = NO;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
        [self createAnchors];
    }
    return self;
}

- (void)createBubbleContainers {
    NSArray *itemData = [AddViewController getItemData];
    
    self.childBubbles = [EditTextViewController getEditBubblesWithEditTextScreenItemDataArray:itemData delegate:self towardsRightSide:NO flickScroller:[self getFlickScroller] andMainBubble:self.mainBubble];
    [self getFlickScroller].items = self.childBubbles.count;
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

- (BOOL)isPlaceholderForTitle:(NSString *)title {
    for (EditTextBubbleContainer *b in self.childBubbles) {
        EditTextBubble *bubble  = (EditTextBubble *)b.bubble;
        if ([bubble.titleLabel.text isEqualToString:[title stringByAppendingString:@":"]]) {
            return bubble.isPlaceHolder;
        }
    }
    
    return NO;
}

- (void)startReturnScaleAnimation {
    int count = 0;
    NSArray *titles = @[@"Level", @"Quick Name", @"Subject", @"Credits"];
    
    for (NSString *t in titles) {
        if (![self isPlaceholderForTitle:t]) count++;
    }
    
    if (count == 3) {
        [super startReturnScaleAnimation];
#warning TODO: save stuff
    } else if (count == 0) {
        [super startReturnScaleAnimation];
    } else {
        NSString *message = @"You must at least enter details for the AS Number, Name, and Subject.";
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:AppName message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Don't Save", nil];
        [a show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Cancel
    } else {
        //Don't Save
        [super startReturnScaleAnimation];
    }
}

+ (NSArray *)getItemData {
    #warning TODO: level get current level for placeholder
    return @[ItemData(@"Level",             @"1",               @"1",               tNSN(Number)),
             ItemData(@"AS Number",         @"",                @"901234",          tNSN(Number)),
             ItemData(@"Quick Name",        @"",                @"Mechanics",       tNSN(Text)),
             ItemData(@"Subject",           @"",                @"Science",         tNSN(Text)),
             ItemData(@"Credits",           @"",                @"4",               tNSN(Number)),
             
             ItemData(@"Is an Internal",    EditTextBoolYes,    EditTextBoolYes,    tNSN(Bool)),
             ItemData(@"Exam/Due Date",     @"",                @"12/04/14",        tNSN(Date)),
             ItemData(@"Is Unit Standard",  EditTextBoolNo,     EditTextBoolNo,     tNSN(Bool)),
             ItemData(@"Type of Credits",   @"No",              @"No",              tNSN(TypeOfCredits)),
             
             ItemData(@"Expected Grade",    @"",                @"Achieved",        tNSN(Grade)),
             ItemData(@"Pre-Resub Grade",   @"",                @"Achieved",        tNSN(Grade)),
             ItemData(@"Practice Grade",    @"",                @"Achieved",        tNSN(Grade)),
             ItemData(@"Prelminary Grade",  @"",                @"Achieved",        tNSN(Grade)),
             ItemData(@"Practice Grade",    @"",                @"Achieved",        tNSN(Grade)),
             ItemData(@"Final Grade",       @"",                @"Achieved",        tNSN(Grade))];
}

@end