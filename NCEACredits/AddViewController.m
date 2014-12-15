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
    //Required fields
    NSArray *titles = @[@"Level", @"Quick Name", @"Subject", ItemCredits];
    
    for (NSString *t in titles) {
        if (![self isPlaceholderForTitle:t]) count++;
    }
    
    if (count == 3) {
        [super startReturnScaleAnimation];
#warning TODO: save stuff
    } else if (count == 0) {
        [super startReturnScaleAnimation];
    } else {
        
        //Add requirements to messages
        NSString *message = @"You must at least enter details for the ";
        for (int a = 0; a < titles.count - 1; a++) {
            message = [message stringByAppendingString:
                       [NSString stringWithFormat:@"'%@', ", titles[a]]];
        }
        message = [message stringByAppendingString:@"and '"];
        message = [message stringByAppendingString:titles[titles.count - 1]];
        message = [message stringByAppendingString:@"' fields."];
        
        
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
    return @[
             ItemData(@"Quick Name",        @"",                        @"Mechanics",               tNSN(EditTextDataTypeText)),
             ItemData(@"AS Number",         @"",                        @"901234",                  tNSN(EditTextDataTypeNumber)),
             ItemData(@"Subject",           @"",                        @"Science",                 tNSN(EditTextDataTypeText)),
             ItemData(ItemCredits,          @"",                        @"4",                       tNSN(EditTextDataTypeNumber)),
             #warning TODO: maybe remove date, dont forget assessment.h
             ItemData(@"Exam / Due Date",   @"",                        @"12/04/14",                tNSN(EditTextDataTypeDate)),
             
             ItemData(@"Is an Internal",    EditTextBoolYes,            EditTextBoolYes,            tNSN(EditTextDataTypeBool)),
             ItemData(@"Is Unit Standard",  EditTextBoolNo,             @"Probably not",            tNSN(EditTextDataTypeBool)),
             ItemData(@"NCEA Level",        @"",                        @"1",                       tNSN(EditTextDataTypeNumber)),
#warning TODO: get level
             ItemData(@"Type of Credits",   EditTextCreditTypeNormal,   EditTextCreditTypeNormal,   tNSN(EditTextDataTypeTypeOfCredits)),
             
             ItemData(@"Final Grade",       @"",                        @"If you have it",          tNSN(EditTextDataTypeGrade)),
             ItemData(@"Expected Grade",    @"",                        @"To predict results",      tNSN(EditTextDataTypeGrade)),
             ItemData(@"Prelminary Grade",  @"",                        @"Latest practice",         tNSN(EditTextDataTypeGrade)),
             ];
}

@end