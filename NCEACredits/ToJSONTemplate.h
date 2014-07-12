//
//  ToJSONTemplate.h
//  NCEACredits
//
//  Created by Dylan Chong on 6/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToJSONTemplate : NSObject

- (id)initWithJSONOrNil:(NSData *)json;
- (void)createBlank;
- (void)loadFromJSON:(NSData *)json;
- (NSData *)convertToJSON;

@end
