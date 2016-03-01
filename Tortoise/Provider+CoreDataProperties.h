//
//  Provider+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Provider.h"

NS_ASSUME_NONNULL_BEGIN

@interface Provider (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *voice;

@end

NS_ASSUME_NONNULL_END
