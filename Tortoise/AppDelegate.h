//
//  AppDelegate.h
//  Tortoise
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>

@class LoggedInUserDS;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(LoggedInUserDS *)getLoggedInUserData;
-(void)setLoggedInUserData:(NSDictionary *)userDict isFacebookData:(BOOL)isFacebook;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

