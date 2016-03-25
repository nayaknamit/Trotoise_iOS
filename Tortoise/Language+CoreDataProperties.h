//
//  Language+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 3/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Language.h"

NS_ASSUME_NONNULL_BEGIN

@interface Language (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *localeCode;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *transCode;
@property (nullable, nonatomic, retain) NSNumber *isDefaultLanguage;
@property (nullable, nonatomic, retain) NSSet<Nuance *> *nuanceRelationship;

@end

@interface Language (CoreDataGeneratedAccessors)

- (void)addNuanceRelationshipObject:(Nuance *)value;
- (void)removeNuanceRelationshipObject:(Nuance *)value;
- (void)addNuanceRelationship:(NSSet<Nuance *> *)values;
- (void)removeNuanceRelationship:(NSSet<Nuance *> *)values;

@end

NS_ASSUME_NONNULL_END
