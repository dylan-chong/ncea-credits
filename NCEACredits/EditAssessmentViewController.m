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
BOOL (^EditTextBoolToBOOL) (NSString *) = ^(NSString *edit) {
    if ([edit isEqualToString:EditTextBoolYes]) return YES;
    else return NO;
};

@implementation EditAssessmentViewController

- (id)initWithMainBubble:(BubbleContainer *)mainBubble delegate:(id<BubbleViewControllerDelegate>)delegate andAssessmentOrNil:(Assessment *)assessment {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (!assessment) assessment = [[Assessment alloc] initWithPropertiesOrNil:nil];
        _assessment = assessment;
        self.staggered = NO;
        self.delegate = delegate;
        [self setMainBubbleSimilarToBubble:mainBubble];
        [self createBubbleContainersAndAddAsSubviews];
        [self createAnchorsIfNonExistent];
        
        [self createDeleteButton];
        [self createHomeButton];
    }
    
    return self;
}

//uncomment to make quick text bubble flash
//- (void)creationAnimationHasFinished {
//    [super creationAnimationHasFinished];
//    
//    CGFloat delay = [Styles getDurationOfAnimationWithFlashTimes:FLASH_BUBBLE_VC_MAIN_BUBBLE_TIMES];
//    delay += [Styles getDurationOfAnimationWithFlashTimes:FLASH_EDIT_TEXT_SCROLL_ARROW_TIMES];
//    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(flashContainers) userInfo:nil repeats:NO];
//}
//
//- (void)flashContainers {
//    EditTextBubbleContainer *quick = [self getEditTextBubbleContainerForTitle:ItemQuickName];
//    [Styles flashStartWithView:quick numberOfTimes:FLASH_DEFAULT_TIMES sizeIncreaseMultiplierOr0ForDefault:0];
//}

- (void)createBubbleContainersAndAddAsSubviews {
    NSArray *itemData = [EditAssessmentViewController getItemDataWithAssessmentOrNil:_assessment];
    
    Corner c = [self getCornerOfChildVCNewMainBubble:self.mainBubble];
    BOOL towardsRightSide = NO;
    if (c == TopLeft || c == BottomLeft) towardsRightSide = YES;
    
    self.childBubbles = [EditTextViewController getEditBubblesWithEditTextScreenItemDataArray:itemData delegate:self towardsRightSide:towardsRightSide flickScroller:[self getFlickScroller] corner:c andMainBubble:self.mainBubble];
    [self getFlickScroller].items = self.childBubbles.count;
    
    for (BubbleContainer *b in self.childBubbles) {
        [self.view addSubview:b];
    }
}

+ (NSArray *)getItemDataWithAssessmentOrNil:(Assessment *)assessment {
    if (!assessment) assessment = [[Assessment alloc] initWithPropertiesOrNil:nil];
    
    NSString *quickName = (assessment.quickName) ? assessment.quickName : @"";
    NSString *ASNum = (assessment.assessmentNumber) ? [NSString stringWithFormat:@"%lu", (unsigned long)assessment.assessmentNumber] : @"";
    NSString *subj = (assessment.subject) ? assessment.subject : @"";
    NSString *credits = [NSString stringWithFormat:@"%lu", (unsigned long)assessment.creditsWhenAchieved];
    
    NSString *isAnInternal = BOOLToEditTextBool(assessment.isAnInternal);
    
    NSString *finalGrade = (assessment.gradeSet.final) ? assessment.gradeSet.final : GradeTextNone;
    NSString *expectGrade = (assessment.gradeSet.expected) ? assessment.gradeSet.expected : GradeTextNone;
    NSString *prelimGrade = (assessment.gradeSet.preliminary) ? assessment.gradeSet.preliminary : GradeTextNone;
    
    NSString *isUnitStandard = BOOLToEditTextBool(assessment.isUnitStandard);
    NSString *level = [NSString stringWithFormat:@"%lu", (unsigned long)assessment.level];
    NSString *typeOfCredits = assessment.typeOfCredits;
    
    //ItemData(theTitle, theText (i.e. default), thePlaceholder, theType)
    return @[
             ItemData(ItemQuickName,        quickName,                        @"E.g. Algebra",               tNSN(EditTextDataTypeText)),
             ItemData(ItemASNumber,         ASNum,                        @"901234 (optional)",                  tNSN(EditTextDataTypeNumber)),
             ItemData(ItemSubject,           subj,                        @"E.g. Maths",                 tNSN(EditTextDataTypeSubject)),
             ItemData(ItemCredits,          credits,                    @"Usually 3 or 4",                    tNSN(EditTextDataTypeNumber)),
             
             ItemData(ItemIsAnInternal,    isAnInternal,               isAnInternal,               tNSN(EditTextDataTypeBool)),
             
             ItemData(ItemFinalGrade,       finalGrade,                        @"If you have it",          tNSN(EditTextDataTypeGrade)),
             ItemData(ItemExpectedGrade,    expectGrade,                        @"To predict results",      tNSN(EditTextDataTypeGrade)),
             ItemData(ItemPreliminaryGrade,  prelimGrade,                        @"Latest practice",         tNSN(EditTextDataTypeGrade)),
             
             ItemData(ItemIsUnitStandard,  isUnitStandard,             @"Probably not",             tNSN(EditTextDataTypeBool)),
             ItemData(ItemNCEALevel,        level,                      level,                      tNSN(EditTextDataTypeNumber)),
             ItemData(ItemTypeOfCredits,   typeOfCredits,              @"Look it up?",              tNSN(EditTextDataTypeTypeOfCredits)),
             ];
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

- (NSString *)getTextOfEditTextBubbleContainerWithTitle:(NSString *)title {
    EditTextBubbleContainer *b = [self getEditTextBubbleContainerForTitle:title];
    if (b) return ((EditTextBubble *)b.bubble).textLabel.text;
    else return nil;
}

- (EditTextBubbleContainer *)getEditTextBubbleContainerForTitle:(NSString *)title {
    for (EditTextBubbleContainer *b in self.childBubbles) {
        EditTextBubble *bubble = (EditTextBubble *)b.bubble;
        
        if ([bubble.titleLabel.text isEqualToString:[title stringByAppendingString:TitleSuffix]]) {
            return b;
        }
    }
    
    NSLog(@"There is no EditTextBubbleContainer for title '%@'.", title);
    return nil;
}

- (BOOL)textBubbleIsShowingPlaceHolder:(NSString *)title { //I.e. no data entered
    EditTextBubbleContainer *bubbleContainer = [self getEditTextBubbleContainerForTitle:title];
    if (!bubbleContainer) {
        return NO;
    }
    
    EditTextBubble *bubble = (EditTextBubble *)bubbleContainer.bubble;
    UIColor *textColour = bubble.textLabel.textColor;
    UIColor *placeholderColour = [EditTextBubble placeholderColour];
    
    if ([Styles colour:textColour isTheSameAsColour:placeholderColour]) {
        return YES;
    }
    
    
    return NO;
}

//Call [super startReturnScaleAnimation] to exit without saving
- (void)startReturnScaleAnimation {
    NSString *subjectText = [self getTextOfEditTextBubbleContainerWithTitle:ItemSubject];
    NSString *quickName = [self getTextOfEditTextBubbleContainerWithTitle:ItemQuickName];
    
    if ([CurrentProfile isAlreadyAssessmentForSubject:subjectText quickName:quickName andDifferentIdentifier:_assessment.identifier]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                       message:@"There is already an assessment by this name and subject."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:RandomOK style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
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
}

- (void)saveAssessment {
    Assessment *newOrEditedAssessment = (_assessment) ? _assessment : [[Assessment alloc] initWithPropertiesOrNil:nil];
    NSArray *editTextBubbleContainers = self.childBubbles;
    BOOL isNewAssessment = ![CurrentProfile assessmentExistsByIdentifier:newOrEditedAssessment];
    
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
            if (isNewAssessment) CurrentAppSettings.lastEnteredSubject = text;
            
        } else if ([title isEqualToString:ItemCredits]) {
            newOrEditedAssessment.creditsWhenAchieved = [text integerValue];
            
            
        } else if ([title isEqualToString:ItemIsAnInternal]) {
            newOrEditedAssessment.isAnInternal = [text boolValue];
            if (isNewAssessment) CurrentAppSettings.lastEnteredWasInternal = EditTextBoolToBOOL(text);
            
        } else if ([title isEqualToString:ItemFinalGrade]) {
            newOrEditedAssessment.gradeSet.final = text;
            if (isNewAssessment) CurrentAppSettings.lastEnteredFinalGrade = text;
            
        } else if ([title isEqualToString:ItemExpectedGrade]) {
            newOrEditedAssessment.gradeSet.expected = text;
            if (isNewAssessment) CurrentAppSettings.lastEnteredExpectGrade = text;
            
        } else if ([title isEqualToString:ItemPreliminaryGrade]) {
            newOrEditedAssessment.gradeSet.preliminary = text;
            if (isNewAssessment) CurrentAppSettings.lastEnteredPrelimGrade = text;
            
            
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

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************    Delete and Home   ************************************
//*************************
//****************
//*********
//****
//*

- (void)createDeleteButton {
    [self createCornerButtonWithTitle:@"Delete" colourOrNilForMailBubbleColour:[Styles redColour] target:self selector:@selector(deletePressed)];
}

- (void)deletePressed {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Are you sure you want to delete this assessment?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
        //Delete
        [self deleteAssessment];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteAssessment {
    //Delete if it exists, otherwise exit without saving
    if ([CurrentProfile assessmentExistsByIdentifier:_assessment]) {
        [CurrentProfile deleteAssessment:_assessment];
    }
    
    [super startReturnScaleAnimation];
}

//------------------------------ Home ------------------------------

//uncomment to make home button exit without saving (and ask for confirmation)
//- (void)homeButtonPressed {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:@"Are you sure you want to exit without saving and return to the home screen?" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        CurrentAppDelegate.bubbleVCisReturningToHomeScreen = YES;
//        [super startReturnScaleAnimation];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
//}

- (void)mainBubbleWasPressed {
    CurrentAppDelegate.bubbleVCisReturningToHomeScreen = NO;
    [super mainBubbleWasPressed];
}

@end
