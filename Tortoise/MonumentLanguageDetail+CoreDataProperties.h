//
//  MonumentLanguageDetail+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 4/29/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MonumentLanguageDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonumentLanguageDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *locale;
@property (nullable, nonatomic, retain) NSNumber *monumentID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *shortDesc;
@property (nullable, nonatomic, retain) NSString *code4;
@property (nullable, nonatomic, retain) NSNumber *langID;

@end

NS_ASSUME_NONNULL_END
