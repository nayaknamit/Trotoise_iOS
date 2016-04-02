//
//  MonumentList+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 3/26/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MonumentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonumentList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addInfo;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *shortDesc;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSString *conv_name;
@property (nullable, nonatomic, retain) NSString *conv_desc;
@property (nullable, nonatomic, retain) NSString *conv_shortDesc;
@property (nullable, nonatomic, retain) NSOrderedSet<ImageAttribute *> *imageAttributes;

@end

@interface MonumentList (CoreDataGeneratedAccessors)

- (void)insertObject:(ImageAttribute *)value inImageAttributesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImageAttributesAtIndex:(NSUInteger)idx;
- (void)insertImageAttributes:(NSArray<ImageAttribute *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImageAttributesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImageAttributesAtIndex:(NSUInteger)idx withObject:(ImageAttribute *)value;
- (void)replaceImageAttributesAtIndexes:(NSIndexSet *)indexes withImageAttributes:(NSArray<ImageAttribute *> *)values;
- (void)addImageAttributesObject:(ImageAttribute *)value;
- (void)removeImageAttributesObject:(ImageAttribute *)value;
- (void)addImageAttributes:(NSOrderedSet<ImageAttribute *> *)values;
- (void)removeImageAttributes:(NSOrderedSet<ImageAttribute *> *)values;

@end

NS_ASSUME_NONNULL_END
