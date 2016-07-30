//
//  MonumentList+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 4/29/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MonumentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonumentList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addInfo;
@property (nullable, nonatomic, retain) NSString *conv_desc;
@property (nullable, nonatomic, retain) NSString *conv_name;
@property (nullable, nonatomic, retain) NSString *conv_shortDesc;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *offline;
@property (nullable, nonatomic, retain) NSString *shortDesc;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSOrderedSet<ImageAttribute *> *imageAttributes;
@property (nullable, nonatomic, retain) NSOrderedSet<Voice *> *voiceAttributes;
@property (nullable, nonatomic, retain) NSOrderedSet<MonumentLanguageDetail *> *multiLocaleMonument;

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

- (void)insertObject:(Voice *)value inVoiceAttributesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromVoiceAttributesAtIndex:(NSUInteger)idx;
- (void)insertVoiceAttributes:(NSArray<Voice *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeVoiceAttributesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInVoiceAttributesAtIndex:(NSUInteger)idx withObject:(Voice *)value;
- (void)replaceVoiceAttributesAtIndexes:(NSIndexSet *)indexes withVoiceAttributes:(NSArray<Voice *> *)values;
- (void)addVoiceAttributesObject:(Voice *)value;
- (void)removeVoiceAttributesObject:(Voice *)value;
- (void)addVoiceAttributes:(NSOrderedSet<Voice *> *)values;
- (void)removeVoiceAttributes:(NSOrderedSet<Voice *> *)values;

- (void)insertObject:(MonumentLanguageDetail *)value inMultiLocaleMonumentAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMultiLocaleMonumentAtIndex:(NSUInteger)idx;
- (void)insertMultiLocaleMonument:(NSArray<MonumentLanguageDetail *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMultiLocaleMonumentAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMultiLocaleMonumentAtIndex:(NSUInteger)idx withObject:(MonumentLanguageDetail *)value;
- (void)replaceMultiLocaleMonumentAtIndexes:(NSIndexSet *)indexes withMultiLocaleMonument:(NSArray<MonumentLanguageDetail *> *)values;
- (void)addMultiLocaleMonumentObject:(MonumentLanguageDetail *)value;
- (void)removeMultiLocaleMonumentObject:(MonumentLanguageDetail *)value;
- (void)addMultiLocaleMonument:(NSOrderedSet<MonumentLanguageDetail *> *)values;
- (void)removeMultiLocaleMonument:(NSOrderedSet<MonumentLanguageDetail *> *)values;

@end

NS_ASSUME_NONNULL_END
