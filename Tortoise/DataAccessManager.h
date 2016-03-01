//
//  DataAccessManager.h
//  tescoAssignment
//
//  Created by Namit Nayak on 1/25/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataAccessManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
+ (DataAccessManager *) sharedInstance;


@end
