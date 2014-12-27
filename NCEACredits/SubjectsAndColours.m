//
//  SubjectsAndColours.m
//  NCEACredits
//
//  Created by Dylan Chong on 4/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "SubjectsAndColours.h"

#define redKey @"red"
#define greenKey @"green"
#define blueKey @"blue"
#define alphaKey @"alpha"


@implementation SubjectsAndColours

- (SubjectsAndColours *)createBlank {
    SubjectsAndColours *sac = [[SubjectsAndColours alloc] init];
    sac.subjectsAndColours = [[NSMutableDictionary alloc] init];
    return sac;
}

- (SubjectsAndColours *)loadFromJSONWithProperties:(NSDictionary *)properties {
    SubjectsAndColours *sac = [[SubjectsAndColours alloc] init];
    sac.subjectsAndColours = [SubjectsAndColours convertBackSubjectsAndColoursDictionaryFromSave:[properties objectForKey:@"subjectsAndColours"]];
    return sac;
}

- (NSDictionary *)convertToDictionaryOfProperties {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:[SubjectsAndColours convertSubjectsAndColoursDictionaryForSave:_subjectsAndColours] forKey:@"subjectsAndColours"];
    
    return properties;
}

+ (NSDictionary *)convertSubjectsAndColoursDictionaryForSave:(NSDictionary *)toConvert {
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    for (NSString *key in toConvert) {
        CGFloat red, green, blue, alpha;
        [[toConvert objectForKey:key] getRed:&red green:&green blue:&blue alpha:&alpha];
        
        NSDictionary *convertedColour = [[NSDictionary alloc] initWithObjects:
                                         @[[NSNumber numberWithFloat:red], [NSNumber numberWithFloat:green],
                                           [NSNumber numberWithFloat:blue], [NSNumber numberWithFloat:alpha]]
                                                                      forKeys:
                                         @[redKey, greenKey, blueKey, alphaKey]
                                         ];
        
        [toSave setObject:convertedColour forKey:key];
    }
    
    return toSave;
}

+ (NSMutableDictionary *)convertBackSubjectsAndColoursDictionaryFromSave:(NSDictionary *)saved {
    NSMutableDictionary *reverted = [[NSMutableDictionary alloc] init];
    for (NSString *key in saved) {
        NSDictionary *convertedColour = [saved objectForKey:key];
                                         
        NSNumber *red, *green, *blue, *alpha;
        red = [convertedColour objectForKey:redKey];
        green = [convertedColour objectForKey:greenKey];
        blue = [convertedColour objectForKey:blueKey];
        alpha = [convertedColour objectForKey:alphaKey];
        
        UIColor *revertedColour = [UIColor colorWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:[alpha floatValue]];
        [reverted setObject:revertedColour forKey:key];
    }
    
    return reverted;
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

#warning TODO: keys sort but dictionary doesnt
- (void)sortSubjectsAlphabetically {
//    NSArray *sortedKeys = [[_subjectsAndColours allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc] init];
//    for (NSString *key in sortedKeys) {
//        [sortedDictionary setObject:[_subjectsAndColours objectForKey:key] forKey:key];
//    }
//    _subjectsAndColours = sortedDictionary;
}

- (void)checkOverSubjectsAndColoursWithSubjects:(NSArray *)subjectsOfAssessments {
    //Remove subjects that do not exist anymore in assessments
    NSMutableArray *subjectsAndColoursToRemove = [[NSMutableArray alloc] init];
    for (NSString *key in _subjectsAndColours) {
        BOOL subjectStillExists = NO;
        for (NSString *sub in subjectsOfAssessments) {
            if (sub == key) {
                subjectStillExists = YES;
            }
        }
        
        if (!subjectStillExists) {
            //existing subject/colour pair does not exist in subjectAssessments - remove it
            [subjectsAndColoursToRemove addObject:key];
        }
    }
    for (NSString *keyToRemove in subjectsAndColoursToRemove) {
        [_subjectsAndColours removeObjectForKey:keyToRemove];
    }
    
    //Add subjects that do not exist yet
    for (NSString *sub in subjectsOfAssessments) {
        BOOL subjectExists = NO;
        for (NSString *key in _subjectsAndColours) {
            if (sub == key) {
                subjectExists = YES;
                break;
            }
        }
        
        if (!subjectExists) {
            UIColor *colourToAdd = [self getUnusedColourFromDefaults];
            [_subjectsAndColours setObject:colourToAdd forKey:sub];
        }
    }
    
    [self sortSubjectsAlphabetically];
    [ApplicationDelegate saveCurrentProfileAndAppSettings];
}

- (NSDictionary *)getAllSubjectsAndColoursForSubjects:(NSArray *)subjectsOfAssessments {
    [self checkOverSubjectsAndColoursWithSubjects:subjectsOfAssessments];
    return _subjectsAndColours;
}

- (UIColor *)getUnusedColourFromDefaults {
    NSArray *colours = [self getSortedDefaultColours];
    for (UIColor *possibleColour in colours) {
        //Make sure colour isnt used
        BOOL colourIsUsed = NO;
        for (NSString *key in _subjectsAndColours) {
            if ([Styles colour:possibleColour isTheSameAsColour:[_subjectsAndColours objectForKey:key]]) {
                colourIsUsed = YES;
                break;
            }
        }
        
        if (!colourIsUsed) return possibleColour;
    }
    
    NSLog(@"Out of default colours, returning pink instead (subject button colour)");
    return [Styles pinkColour];
}

- (void)setColour:(UIColor *)colour forSubject:(NSString *)subject {
    [_subjectsAndColours setObject:colour forKey:subject];
}

- (NSArray *)getSortedDefaultColours {
#define RGB(redLevel, greenLevel, blueLevel) [UIColor colorWithRed:redLevel/255.0 green:greenLevel/255.0 blue:blueLevel/255.5 alpha:1.0]
    //Returns the order (and colours) for them to be automatically set
    return @[RGB(205, 20, 20), //red
             RGB(144, 217, 75), //lime green
             RGB(24, 94, 189), //darkish blue
             RGB(255, 153, 42), //orange
             RGB(242, 99, 131), //pink/magenta
             RGB(51, 172, 227), //light blue (cyanish)
             RGB(140, 140, 140), //medium grey
             RGB(77, 74, 74), //dark grey (blackish)
             RGB(177, 177, 177), //light grey
             RGB(109, 107, 104), //medium-dark grey
             RGB(154, 152, 147), //medium-light grey
             ];
}

@end
