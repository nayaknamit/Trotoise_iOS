//
//  CityMonument+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 4/29/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CityMonument.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityMonument (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *localeStrings;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *offline;
@property (nullable, nonatomic, retain) NSString *voiceBasePath;
@property (nullable, nonatomic, retain) NSString *langIDString;
@property (nullable, nonatomic, retain) NSSet<MonumentList *> *citymonumentrelationship;

@end

@interface CityMonument (CoreDataGeneratedAccessors)

- (void)addCitymonumentrelationshipObject:(MonumentList *)value;
- (void)removeCitymonumentrelationshipObject:(MonumentList *)value;
- (void)addCitymonumentrelationship:(NSSet<MonumentList *> *)values;
- (void)removeCitymonumentrelationship:(NSSet<MonumentList *> *)values;

@end

NS_ASSUME_NONNULL_END
