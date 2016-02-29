//
//  AppDelegate.m
//  Tortoise
//

#import "AppDelegate.h"
#import "Constants.h"
#import "SCFacebook.h"
#import "LoggedInUserDS.h"
#import "LanguageDS.h"
#import "SplashViewController.h"
@import GoogleMaps;

@interface AppDelegate ()
@property (nonatomic,strong) LoggedInUserDS *loggedInUserDS;
@property (nonatomic,strong) NSArray *languageDataArray;
@property (nonatomic,strong) NSArray *cityMonumentListArray;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic,strong)NSString *currentLocationAddress;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    //INITIALIZING THE GOOGLE MAPS
   
    [GMSServices provideAPIKey:GOOGLE_KEY];
    
    _isLanguageChange = NO;
    
    ///GOOGLE SIGN IN IMPLEMENTATION
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;

    
    //Init SCFacebook
    [SCFacebook initWithReadPermissions:@[@"user_about_me",
                                          @"user_birthday",
                                          @"email",
                                          @"user_photos",
                                          @"user_events",
                                          @"user_friends",
                                          @"user_videos",
                                          @"public_profile"]
                     publishPermissions:@[@"manage_pages",
                                          @"publish_actions",
                                          @"publish_pages"]
     ];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // Override point for customization after application launch.
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    float height =  screenBounds.size.height;
    
    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                              UIApplicationOpenURLOptionsAnnotationKey: annotation};
    return [self application:application
                     openURL:url
                     options:options];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Google SignIN Methods

-(void)disconnectGoogleSignIn{
    
    [[GIDSignIn sharedInstance] disconnect];

}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if (_loggedInUserDS) {
        _loggedInUserDS = nil;
    }
    _loggedInUserDS = [[LoggedInUserDS alloc] init];
    if(user!=nil){
        
        [_loggedInUserDS setName:user.profile.name];
        [_loggedInUserDS setUserID:user.userID];
        [_loggedInUserDS setAuthenticationID:user.authentication.idToken];
        [_loggedInUserDS setEmail:user.profile.email];
        [_loggedInUserDS setIsFacebookLoggedIn:NO];
        if(user.profile.hasImage){
            NSURL *ur = [user.profile imageURLWithDimension:110];
            [_loggedInUserDS setImageUrl:[user.profile imageURLWithDimension:110]];
            
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GOOGLE_SIGIN_PROFILE" object:_loggedInUserDS];
        
    }
    
}

-(void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    
    _loggedInUserDS = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LoggedInUserInfo"];
    [self instantiateIntialVC];
}

-(LoggedInUserDS *)getLoggedInUserData{
    return (_loggedInUserDS!=nil)?_loggedInUserDS:nil;
    
}

/*
 {
 birthday = "02/08/1986";
 email = "namitnayak@gmail.com";
 id = 10153882061369557;
 name = "Namit Nayak";
 picture =     {
 data =         {
 "is_silhouette" = 0;
 url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/11377271_10153334225094557_1366334402212167737_n.jpg?oh=72348cc6426b827510a80b17282a80ca&oe=573C69DD&__gda__=1463698904_4c472358c19a12012973bfb7e2083f0d";
 };
 };
 }
 
 */

-(void)setCurrentLocationAddress:(NSString *)address{
   if( _loggedInUserDS!=nil)
   {
    _loggedInUserDS.formattedAddressString = address;
       _currentLocationAddress = address;
   }else{
    _currentLocationAddress = address;
   }
    
   
}
-(NSString *)getCurrentLocationAddress{
    
    return  _currentLocationAddress;
}
-(void)setDefaultLanguage{
    
    [_languageDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LanguageDS *languageDs = (LanguageDS *)obj;
        if ([languageDs.name isEqualToString:@"English (US)"]) {
            
            [self setSelectedLanguageData:languageDs];
            *stop = YES;
            return ;
            
        }
    }];
}


-(void)setRangeType:(TRRANGETYPE)rangeType{
    
    if(_loggedInUserDS !=nil)
    {
        _loggedInUserDS.rangeType = rangeType;
        
    }
}
-(TRRANGETYPE)getRangeType{
    if(_loggedInUserDS !=nil)
    {
     return    _loggedInUserDS.rangeType ;
        
    }
    return TRRANGE_KILOMETERTYPE;
}
-(void)setSelectedLanguageData:(LanguageDS *)languageDS{
    if(_loggedInUserDS !=nil)
    {
        _loggedInUserDS.selectedLanguageDS = languageDS;
        
        
    }
}
-(LanguageDS *)getLanguage{
    
    if(_loggedInUserDS !=nil)
    {
      return   _loggedInUserDS.selectedLanguageDS ;
        
        
    }
    return nil;
}
-(void)logOutUser{
    if(_loggedInUserDS){
        
        if(_loggedInUserDS.isFacebookLoggedIn)
        {
            [SCFacebook logoutCallBack:^(BOOL success, id result) {
            
                if (success) {
                    NSLog(@"Facebook Logout Successfully");
                    
                }
                [self instantiateIntialVC];
                _loggedInUserDS = nil;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LoggedInUserInfo"];

            }];
        
        }else{
            [self disconnectGoogleSignIn];
    
        }
        
       
   
        
        
    }
    
}
-(void)instantiateIntialVC{
 UIStoryboard *stoaryBoard     =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
SplashViewController *splashVC =  [stoaryBoard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:splashVC];
    nav.navigationBarHidden = YES;
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;

}
-(void)setLoggedInUserData:(NSDictionary *)userDict isFacebookData:(BOOL)isFacebook{

    if(_loggedInUserDS !=nil){
        _loggedInUserDS = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:@"LoggedInUserInfo"];

    _loggedInUserDS = [[LoggedInUserDS alloc] init];
    _loggedInUserDS.name = [userDict objectForKey:@"name"];
    _loggedInUserDS.userID = [userDict objectForKey:@"id"];
    _loggedInUserDS.authenticationID = [userDict objectForKey:@"id"];
    _loggedInUserDS.isFacebookLoggedIn = isFacebook;
    _loggedInUserDS.email = [userDict objectForKey:@"email"];
    if ([userDict objectForKey:@"picture"]!=nil) {
        
//        NSURL *url = [NSURL URLWithString:[[[userDict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
        _loggedInUserDS.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&redirect=true&width=150&height=150",_loggedInUserDS.userID]];
        
    }
    if([userDict objectForKey:@"cover"]!=nil){
        NSURL *url = [NSURL URLWithString:[[userDict objectForKey:@"cover"] objectForKey:@"source"]];
        _loggedInUserDS.coverImageUrl = url;
        
    }
    
    
}

-(CLLocationCoordinate2D)getCurrentLocationCoordinate{
    
    return _locationCoordinate;
}
-(void)setCurrentLocationCoordinate:(CLLocationCoordinate2D)coordinate{
    _locationCoordinate = coordinate;
    
}

-(NSArray *)getLanguageDataArray{
    
    return _languageDataArray;
}
-(void)setLanguageDataArray:(NSArray *)languageDataArray{
    
    _languageDataArray = [NSArray arrayWithArray:languageDataArray];
    
}

-(NSArray *)getMonumentListArray{
    
    return _cityMonumentListArray;
}
-(void)setCityMonumentListArray:(NSArray *)arr{
    if(_cityMonumentListArray != nil){
        
        _cityMonumentListArray = nil;
    }
    _cityMonumentListArray = [NSArray arrayWithArray:arr];
    
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.budhha.Tortoise" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tortoise" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tortoise.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
