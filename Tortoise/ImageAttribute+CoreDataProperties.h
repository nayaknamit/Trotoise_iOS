//
//  ImageAttribute+CoreDataProperties.h
//  Tortoise
//
//  Created by Namit Nayak on 2/8/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageAttribute (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
