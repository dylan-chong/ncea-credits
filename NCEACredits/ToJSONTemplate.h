//
//  ToJSONTemplate.h
//  NCEACredits
//
//  Created by Dylan Chong on 6/07/14.
//  Copyright (c) 2014 PiGuyGames. All rights reserved.
//


// The purpose of this class is for making lots of (child) classes (which will be a subclass of this) that will be converted in and out of JSON. When creating a new object, use the initWithJSONOrNil: method. Sending nil through will mean the createBlank method is called; otherwise loadFromJSON: is called. This init method shouldn't be overriden, you must override createBlank and loadFromJSON: so that they will return the newly created objects. Inside these, use the plain init method and then apply properties to it. You must also override the convertToJSON method.


#import <Foundation/Foundation.h>

//In the hierarchy, when a template subclass is the property of another subclass, the converted nsdata must be converted to a string to be saved as a property. Going backwards, it should be converted back.
#define NSDataToNSString(data) [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
#define NSStringToNSData(string) [string dataUsingEncoding:NSUTF8StringEncoding]

@interface ToJSONTemplate : NSObject

//Mustn't override
- (id)initWithJSONOrNil:(NSData *)json;

//Must override
- (ToJSONTemplate *)createBlank;
- (ToJSONTemplate *)loadFromJSONWithProperties:(NSDictionary *)properties;
- (NSData *)convertToJSON;

+ (NSMutableArray *)convertArrayOfTemplateSubclassesToJSON:(NSArray *)array;
+ (NSMutableArray *)convertBackArrayOfJSONObjects:(NSArray *)array toTemplateSubclass:(NSString *)stringOfClassName;
@end
