//
//  TableViewCellData.m
//  NCEACredits
//
//  Created by Dylan Chong on 12/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "TableViewCellData.h"

@implementation TableViewCellData

- (id)initWithDetail:(NSString *)d text:(NSString *)t reuseId:(NSString *)r andStyle:(UITableViewCellStyle)s {
    self = [super init];
    
    if (self) {
        _style = s;
        _text = t;
        _detail = d;
        _reuseId = r;
    }
    
    return self;
}

@end
