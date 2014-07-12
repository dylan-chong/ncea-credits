//
//  TableViewCellData.h
//  NCEACredits
//
//  Created by Dylan Chong on 12/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewCellData : NSObject

- (id)initWithDetail:(NSString *)d text:(NSString *)t reuseId:(NSString *)r andStyle:(UITableViewCellStyle)s;

@property NSString *detail, *text, *reuseId;
@property UITableViewCellStyle style;

@end
