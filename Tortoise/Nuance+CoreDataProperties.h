//
//  Nuance+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Nuance.h"

NS_ASSUME_NONNULL_BEGIN

@interface Nuance (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code4;
@property (nullable, nonatomic, retain) NSString *code6;
@property (nullable, nonatomic, retain) NSString *lang;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *provider;

@end

@interface Nuance (CoreDataGeneratedAccessors)

- (void)addProviderObject:(NSManagedObject *)value;
- (void)removeProviderObject:(NSManagedObject *)value;
- (void)addProvider:(NSSet<NSManagedObject *> *)values;
- (void)removeProvider:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
