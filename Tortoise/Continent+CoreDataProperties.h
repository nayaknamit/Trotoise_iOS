//
//  Continent+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Continent.h"

NS_ASSUME_NONNULL_BEGIN

@interface Continent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *symbol;
@property (nullable, nonatomic, retain) NSSet<Country *> *countryList;

@end

@interface Continent (CoreDataGeneratedAccessors)

- (void)addCountryListObject:(Country *)value;
- (void)removeCountryListObject:(Country *)value;
- (void)addCountryList:(NSSet<Country *> *)values;
- (void)removeCountryList:(NSSet<Country *> *)values;

@end

NS_ASSUME_NONNULL_END
