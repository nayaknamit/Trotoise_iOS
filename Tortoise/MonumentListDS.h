//
//  MonumentListDS.h
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonumentListDS : NSObject
@property (nonatomic, retain) NSNumber *monumentID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *shortDesc;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *addInfo;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSMutableSet *imageAttributes;

@end

@interface ImageAttributeDS : NSObject
@property (nonatomic, retain) NSString *imageUrl;


@end

@interface CountryDS : NSObject
@property (nonatomic, retain) NSNumber *countryID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *shortDesc;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *addInfo;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSSet   *citylistSet;
@end

@interface ContinentDS : NSObject
@property (nonatomic, retain) NSNumber *continentID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) NSSet *countryList;

@end



@interface CityMonumentDS : NSObject

@property (nonatomic, retain) NSNumber *cityMonumentID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSSet *citymonumentrelationship;
@end

