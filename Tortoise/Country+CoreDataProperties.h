//
//  Country+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Country.h"

NS_ASSUME_NONNULL_BEGIN

@interface Country (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *symbol;
@property (nullable, nonatomic, retain) NSSet<CityMonument *> *citylist;

@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addCitylistObject:(CityMonument *)value;
- (void)removeCitylistObject:(CityMonument *)value;
- (void)addCitylist:(NSSet<CityMonument *> *)values;
- (void)removeCitylist:(NSSet<CityMonument *> *)values;

@end

NS_ASSUME_NONNULL_END
