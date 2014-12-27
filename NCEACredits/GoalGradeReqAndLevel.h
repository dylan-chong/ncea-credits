//
//  GoalGradeReqAndLevel.h
//  NCEACredits
//
//  Created by Dylan Chong on 20/12/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoalGradeReqAndLevel : NSObject

- (id)initWithCreditsRequired:(NSUInteger)creds NCEALevel:(NSUInteger)level;
@property NSUInteger level, creditsRequired, literacyCredits, numeracyCredits;
@end
