//
//  ToJSONTemplate.m
//  NCEACredits
//
//  Created by Dylan Chong on 6/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//

#import "ToJSONTemplate.h"

@implementation ToJSONTemplate

- (id)initWithPropertiesOrNil:(NSDictionary *)properties {
    if (!properties) {
        //Blank
        self = [self createBlank];
    } else {
        //Load
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

- (NSDictionary *)convertToDictionaryOfProperties {
    NSAssert(NO, @"You must override the method convertToDictionaryOfProperties from class ToJSONTemplate. If you are calling this method on the root to convert the whole thing to JSON, call convertToJSONAsRoot instead.");
    return nil;
}

/* This code must be implemented in place of the convertToDictionaryOfProperties method of all template subclasses below it. This is the method that is called when you want to convert the whole hierarchy into JSON.
 
 - (NSData *)convertToJSONAsRoot {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setObject:_profileName forKey:@"profileName"];
 
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:properties options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@", error);
    return data;
}
 */

//------------------------------ Conversion ------------------------------

+ (NSMutableArray *)convertArrayOfTemplateSubclassesToJSON:(NSArray *)array {
    NSMutableArray *converted = [[NSMutableArray alloc] init];
    
    for (ToJSONTemplate *obj in array) {
        [converted addObject:[obj convertToDictionaryOfProperties]];
    }
    
    return converted;
}

+ (NSMutableArray *)convertBackArrayOfJSONObjects:(NSArray *)array toTemplateSubclass:(NSString *)stringOfClassName {
    NSMutableArray *deconverted = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in array) {
        [deconverted addObject:[(ToJSONTemplate *)NSClassFromString(stringOfClassName) initWithPropertiesOrNil:obj]];
    }
    
    return deconverted;
}


@end
