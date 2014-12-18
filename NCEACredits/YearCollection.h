//
//  YearCollection.h
//  NCEACredits
//
//  Created by Dylan Chong on 11/06/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToJSONTemplate.h"
#import "Year.h"

@interface YearCollection : ToJSONTemplate

@property NSMutableArray *years;
- (Year *)getMostUpToDateYear;

@end
