//
//  EditAssessmentViewController.m
//  NCEACredits
//
//  Created by Dylan Chong on 18/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditAssessmentViewController.h"
#import "EditTextBubble.h"
#import "EditTextScreenItemData.h"
#import "Grade.h"

// type of credits only available in lvl1

NSString *(^BOOLToEditTextBool) (BOOL) = ^(BOOL boolean) {
    if (boolean) return EditTextBoolYes;
    else return EditTextBoolNo;
};

@interface EditAssessmentViewController ()

@end

@implementation EditAssessmentViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble andAssessmentOrNil:(Assessment *)assessment {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (!assessment) assessment = [[Assessment alloc] initWithPropertiesOrNil:nil];
        _assessment = assessment;
        self.staggered = NO;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainers];
        [self createAnchors];
    }
    
    return self;
}

+ (NSArray *)getItemDataWithAssessmentOrNil:(Assessment *)assessment {
    if (!assessment) assessment = [[Assessment alloc] initWithPropertiesOrNil:nil];
    
    NSString *credits = [NSString stringWithFormat:@"%lu", (unsigned long)assessment.creditsWhenAchieved];
    NSString *level = [NSString stringWithFormat:@"%lu", (unsigned long)assessment.level];
    NSString *isAnInternal = BOOLToEditTextBool(assessment.isAnInternal);
    NSString *isUnitStandard = BOOLToEditTextBool(assessment.isUnitStandard);
    NSString *typeOfCredits = assessment.typeOfCredits;
    
    //ItemData(theTitle, theText (i.e. default), thePlaceholder, theType)
    return @[
             ItemData(ItemQuickName,        @"",                        @"Mechanics",               tNSN(EditTextDataTypeText)),
             ItemData(ItemASNumber,         @"",                        @"901234 (optional)",                  tNSN(EditTextDataTypeNumber)),
             ItemData(ItemSubject,           @"",                        @"Science",                 tNSN(EditTextDataTypeText)),
             ItemData(ItemCredits,          credits,                    @"Usually 3 or 4",                    tNSN(EditTextDataTypeNumber)),
             
             ItemData(ItemIsAnInternal,    isAnInternal,               isAnInternal,               tNSN(EditTextDataTypeBool)),
             
             ItemData(ItemFinalGrade,       @"",                        @"If you have it",          tNSN(EditTextDataTypeGrade)),
             ItemData(ItemExpectedGrade,    @"",                        @"To predict results",      tNSN(EditTextDataTypeGrade)),
             ItemData(ItemPreliminaryGrade,  @"",                        @"Latest practice",         tNSN(EditTextDataTypeGrade)),
             
             ItemData(ItemIsUnitStandard,  isUnitStandard,             @"Probably not",             tNSN(EditTextDataTypeBool)),
             ItemData(ItemNCEALevel,        level,                      level,                      tNSN(EditTextDataTypeNumber)),
             ItemData(ItemTypeOfCredits,   typeOfCredits,              @"Look it up?",              tNSN(EditTextDataTypeTypeOfCredits)),
             ];
}

- (void)createBubbleContainers {
    NSArray *itemData = [EditAssessmentViewController getItemDataWithAssessmentOrNil:_assessment];
    
    self.childBubbles = [EditTextViewController getEditBubblesWithEditTextScreenItemDataArray:itemData delegate:self towardsRightSide:NO flickScroller:[self getFlickScroller] andMainBubble:self.mainBubble];
    [self getFlickScroller].items = self.childBubbles.count;
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Closing stuff    ************************************
//*************************
//****************
//*********
//****
//*

- (BOOL)textBubbleIsShowingPlaceHolder:(NSString *)title { //I.e. no data entered
    for (EditTextBubbleContainer *b in self.childBubbles) {
        EditTextBubble *bubble = (EditTextBubble *)b.bubble;

        if ([bubble.titleLabel.text isEqualToString:[title stringByAppendingString:TitleSuffix]]) {
            UIColor *textColour = bubble.textLabel.textColor;
            UIColor *placeholderColour = [EditTextBubble placeholderColour];
            
            if ([Styles colour:textColour isTheSameAsColour:placeholderColour]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)startReturnScaleAnimation {
    NSInteger count = 0;
    //Required fields
    NSArray *titles = @[ItemNCEALevel, ItemQuickName, ItemSubject, ItemCredits];
    
    for (NSString *t in titles) {
        if (![self textBubbleIsShowingPlaceHolder:t]) count++;
    }
    
    if (count == titles.count) {
        //Save
        [self saveAssessment];
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

- (void)saveAssessment {
    Assessment *newOrEditedAssessment = [[Assessment alloc] initWithPropertiesOrNil:nil];
    NSArray *editTextBubbleContainers = self.childBubbles;
    
    for (EditTextBubbleContainer *bubble in editTextBubbleContainers) {
        NSString *title = ((EditTextBubble *)bubble.bubble).titleLabel.text;
        NSString *text = ((EditTextBubble *)bubble.bubble).textLabel.text;
        
        title = [title substringToIndex:title.length - TitleSuffix.length];//Get rid of the colon on the end
        
        if ([title containsString:@"Grade"] && [self textBubbleIsShowingPlaceHolder:title]) //Placeholder = no grade
             text = GradeTextNone;
        
        if ([title isEqualToString:ItemQuickName]) {
            newOrEditedAssessment.quickName = text;
        } else if ([title isEqualToString:ItemASNumber]) {
            if ([self textBubbleIsShowingPlaceHolder:title]) {
                //Placeholder? set AS to 0
                newOrEditedAssessment.assessmentNumber = 0;
            } else {
                newOrEditedAssessment.assessmentNumber = [text integerValue];
            }
            
        } else if ([title isEqualToString:ItemSubject]) {
            newOrEditedAssessment.subject = text;
        } else if ([title isEqualToString:ItemCredits]) {
            newOrEditedAssessment.creditsWhenAchieved = [text integerValue];

        } else if ([title isEqualToString:ItemIsAnInternal]) {
            newOrEditedAssessment.isAnInternal = [text boolValue];
            
        } else if ([title isEqualToString:ItemFinalGrade]) {
            newOrEditedAssessment.gradeSet.final = text;
        } else if ([title isEqualToString:ItemExpectedGrade]) {
            newOrEditedAssessment.gradeSet.expected = text;
        } else if ([title isEqualToString:ItemPreliminaryGrade]) {
            newOrEditedAssessment.gradeSet.preliminary = text;
            
        } else if ([title isEqualToString:ItemIsUnitStandard]) {
            newOrEditedAssessment.isUnitStandard = [text boolValue];
        } else if ([title isEqualToString:ItemNCEALevel]) {
            newOrEditedAssessment.level = [text integerValue];
        } else if ([title isEqualToString:ItemTypeOfCredits]) {
            newOrEditedAssessment.typeOfCredits = text;
        }
    }
    
    [CurrentProfile addAssessmentOrReplaceACurrentOne:newOrEditedAssessment];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Cancel
    } else {
        //Don't Save
        [super startReturnScaleAnimation];
    }
}


@end
