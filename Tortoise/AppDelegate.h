//
//  AppDelegate.h
//  Tortoise
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>
#import <CoreLocation/CoreLocation.h>
#import "LoggedInUserDS.h"
@class LoggedInUserDS, Language, CLLocationManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)NSMutableArray *defaultCityMonumentList;
@property (nonatomic) BOOL isLanguageChange;
@property (nonatomic) BOOL isLocationEnabled;
-(LoggedInUserDS *)getLoggedInUserData;
-(void)setLoggedInUserData:(NSDictionary *)userDict isFacebookData:(BOOL)isFacebook;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)setSelectedLanguageData:(Language *)languageDS;
-(Language *)getLanguage;
-(void)disconnectGoogleSignIn;
-(void)logOutUser;
//-(NSArray *)getMonumentListArray;
//-(void)setCityMonumentListArray:(NSArray *)arr;
-(CLLocationCoordinate2D)getCurrentLocationCoordinate;
-(void)setCurrentLocationCoordinate:(CLLocationCoordinate2D)coordinate;
//-(void)setDefaultLanguage;
-(void)setCurrentLocationAddress:(NSString *)address;
-(NSString *)getCurrentLocationAddress;
-(void)setRangeType:(TRRANGETYPE)rangeType;
-(TRRANGETYPE)getRangeType;
-(NSArray *)getSplashTextArray;
-(void)setSplashTextWithLanguageChange:(NSArray *)arr;
-(void)setUserDefaultLanguageIsCached:(BOOL)isCached;
-(BOOL)getUserDefaultLanguageIsChached;
-(NSDictionary *)getLocalCahceLangugeDict;
-(void)setInitialDefaultLanguage;
-(void)checkForNetworkServiceEnabled;
-(void)setUpLanguageInUSerDefualts:(Language *)languageDS withSplashTextArr:(NSArray *)textAr;
@end

