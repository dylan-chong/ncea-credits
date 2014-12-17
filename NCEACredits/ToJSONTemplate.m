//
//  ToJSONTemplate.m
//  NCEACredits
//
//  Created by Dylan Chong on 6/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ToJSONTemplate.h"

@implementation ToJSONTemplate

- (id)initWithJSONOrNil:(NSData *)json {
    if (!json) {
        //Blank
        self = [self createBlank];
    } else {
        //Load
        NSError *error;
        NSDictionary *properties = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
        if (error) NSLog(@"%@", error);
        
        self = [self loadFromJSONWithProperties:properties];
    }
    
    return self;
}

//Must be instance methods so that they are automatically run instead of the template methods
- (ToJSONTemplate *)createBlank {
    NSAssert(NO, @"You must override the method createBlank from class ToJSONTemplate, returning a new object (with appropriately assigned properties).");
    return nil;
}

- (ToJSONTemplate *)loadFromJSONWithProperties:(NSDictionary *)properties {
    NSAssert(NO, @"You must override the method loadFromJSON from class ToJSONTemplate, returning a new object (with appropriately assigned properties).");
    return nil;
}

- (NSData *)convertToJSON {
    NSAssert(NO, @"You must override the method convertToJSON from class ToJSONTemplate.");
    return nil;
}

//------------------------------ Conversion ------------------------------

+ (NSMutableArray *)convertArrayOfTemplateSubclassesToJSON:(NSArray *)array {
    NSMutableArray *converted = [[NSMutableArray alloc] init];
    
    for (ToJSONTemplate *obj in array) {
        [converted addObject:NSDataToNSString([obj convertToJSON])];
    }
    
    return converted;
}

+ (NSMutableArray *)convertBackArrayOfJSONObjects:(NSArray *)array toTemplateSubclass:(NSString *)stringOfClassName {
    NSMutableArray *deconverted = [[NSMutableArray alloc] init];
    for (NSString *obj in array) {
        [deconverted addObject:[(ToJSONTemplate *)NSClassFromString(stringOfClassName) initWithJSONOrNil:NSStringToNSData(obj)]];
    }
    
    return deconverted;
}


@end
