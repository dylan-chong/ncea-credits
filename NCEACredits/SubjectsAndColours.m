//
//  SubjectsAndColours.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsAndColours.h"

@implementation SubjectsAndColours

- (SubjectsAndColours *)createBlank {
    SubjectsAndColours *sac = [[SubjectsAndColours alloc] init];
    sac.subjectsAndColours = [[NSMutableDictionary alloc] init];
    return sac;
}

- (SubjectsAndColours *)loadFromJSONWithProperties:(NSDictionary *)properties {
    SubjectsAndColours *sac = [[SubjectsAndColours alloc] init];
    sac.subjectsAndColours = [properties objectForKey:@"subjectsAndColours"];
    return sac;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_subjectsAndColours forKey:@"subjectsAndColours"];
    
    return properties;
}

//*
//****
//*********
//****************
//*************************
#pragma mark - ***************************************************************
//*************************
//****************
//*********
//****
//*

- (UIColor *)getColourForSubject:(NSString *)subject {
    #warning TODO: lookup in dictionary for colour and return it, else return the next unused default colour
    return nil;
}

- (void)setColour:(UIColor *)colour forSubject:(NSString *)subject {
    #warning TODO:
}

- (NSArray *)getSortedDefaultColours {
#define RGB(redLevel, greenLevel, blueLevel) [UIColor colorWithRed:redLevel/255.0 green:greenLevel/255.0 blue:blueLevel/255.5 alpha:1.0]
    //Returns the order (and colours) for them to be automatically set
    return @[RGB(205, 20, 20), //red
             RGB(144, 217, 75), //lime green
             RGB(24, 94, 189), //darkish blue
             RGB(51, 172, 227), //light blue (cyanish)
             RGB(255, 153, 42), //orange
             RGB(242, 99, 131), //pink/magenta
             RGB(140, 140, 140), //medium grey
             RGB(77, 74, 74), //dark grey (blackish)
             RGB(177, 177, 177), //light grey
             RGB(109, 107, 104), //medium-dark grey
             RGB(154, 152, 147), //medium-light grey
             ];
}

@end
