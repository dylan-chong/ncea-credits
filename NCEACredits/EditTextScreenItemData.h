//
//  EditTextScreenItemData.h
//  NCEACredits
//
//  Created by Dylan Chong on 8/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ItemData(theTitle, theText, thePlaceholder, theType) [[EditTextScreenItemData alloc] initWithTitle:theTitle text:theText placeholder:thePlaceholder andType:theType]

#define ItemQuickName @"Quick Name"
#define ItemASNumber @"AS Number"
#define ItemSubject @"Subject"
#define ItemCredits @"Credits"

#define ItemIsAnInternal @"Internally assessed?"

#define ItemFinalGrade @"Final Grade"
#define ItemExpectedGrade @"Expected Grade"
#define ItemPreliminaryGrade @"Preliminary Grade"

#define ItemIsUnitStandard @"Is Unit Standard"
#define ItemNCEALevel @"NCEA Level"
#define ItemTypeOfCredits @"Type of Credits"

@interface EditTextScreenItemData : NSObject

- (id)initWithTitle:(NSString *)title text:(NSString *)text placeholder:(NSString *)placeholder andType:(NSNumber *)type;

@property NSString *title, *text, *placeholder;
@property NSNumber *type;

@end
