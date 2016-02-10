//
//  AppDelegate.h
//  Tortoise
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>
#import <CoreLocation/CoreLocation.h>
@class LoggedInUserDS, LanguageDS, CLLocationManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong)CLLocationManager *locationManager;
-(LoggedInUserDS *)getLoggedInUserData;
-(void)setLoggedInUserData:(NSDictionary *)userDict isFacebookData:(BOOL)isFacebook;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)setSelectedLanguageData:(LanguageDS *)languageDS;
-(void)disconnectGoogleSignIn;
-(void)logOutUser;
-(NSArray *)getLanguageDataArray;
-(void)setLanguageDataArray:(NSArray *)languageDataArray;
-(NSArray *)getMonumentListArray;
-(void)setCityMonumentListArray:(NSArray *)arr;
-(CLLocationCoordinate2D)getCurrentLocationCoordinate;
-(void)setCurrentLocationCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setDefaultLanguage;
-(void)setCurrentLocationAddress:(NSString *)address;
-(NSString *)getCurrentLocationAddress;
@end

