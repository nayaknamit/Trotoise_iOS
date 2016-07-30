//
//  Voice+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Voice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Voice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *transCode;
@property (nullable, nonatomic, retain) NSString *nuCode4;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *voice;
@property (nullable, nonatomic, retain) NSString *path;

@end

NS_ASSUME_NONNULL_END
