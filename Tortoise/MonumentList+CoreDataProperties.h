//
//  MonumentList+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 10/15/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MonumentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonumentList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *shortDesc;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *addInfo;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) CityMonument *citymonument;

@end

NS_ASSUME_NONNULL_END
