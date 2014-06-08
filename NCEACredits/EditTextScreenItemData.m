//
//  EditTextScreenItemData.m
//  NCEACredits
//
//  Created by Dylan Chong on 8/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "EditTextScreenItemData.h"

@implementation EditTextScreenItemData

- (id)initWithTitle:(NSString *)title text:(NSString *)text placeholder:(NSString *)placeholder andType:(NSNumber *)type {
    self = [super init];
    
    if (self) {
        _title = title;
        _text = text;
        _placeholder = placeholder;
        _type = type;
    }
    
    return self;
}

@end
