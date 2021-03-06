//
//  Language.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nuance,LanguageDS;

NS_ASSUME_NONNULL_BEGIN

@interface Language : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)insertDataIntoBasket:( LanguageDS*)dataObject withContextManagedObject:(NSManagedObjectContext *)context;
+(BOOL)isDataExistwithContext:(NSManagedObjectContext *)context;
+(NSArray *)getLanguageDataFromContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "Language+CoreDataProperties.h"
