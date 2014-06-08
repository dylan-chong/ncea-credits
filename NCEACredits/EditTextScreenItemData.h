//
//  EditTextScreenItemData.h
//  NCEACredits
//
//  Created by Dylan Chong on 8/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

#define tNSN(x) [NSNumber numberWithInt:x]
#define ItemData(theTitle, theText, thePlaceholder, theType) [[EditTextScreenItemData alloc] initWithTitle:theTitle text:theText placeholder:thePlaceholder andType:theType]

@interface EditTextScreenItemData : NSObject

- (id)initWithTitle:(NSString *)title text:(NSString *)text placeholder:(NSString *)placeholder andType:(NSNumber *)type;

@property NSString *title, *text, *placeholder;
@property NSNumber *type;

@end
