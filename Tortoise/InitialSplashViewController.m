//
//  InitialSplashViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/10/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "InitialSplashViewController.h"
#import "TTAPIHandler.h"
#import "KLCPopup.h"
#import "LanguageTableView.h"
#import "LanguageDS.h"
#import "LoggedInUserDS.h"
#import <GoogleMaps.h>
#import "SplashViewController.h"

#import "HomeViewController.h"
#import "MenuTableViewController.h"
#import "TranslatorManager.h"
#import "LanguageDataManager.h"
@interface InitialSplashViewController ()<CLLocationManagerDelegate>
{
    
    BOOL isOpenOnce;
    BOOL isCloseAnimation;
    CGFloat textImageLogoX;
    CGFloat storiesLogoX;
}
@property (nonatomic,weak)   IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UIImageView *textImageView;
@property (nonatomic,weak) IBOutlet UILabel *storiesLogoLbl;

@end
@implementation InitialSplashViewController
static dispatch_once_t predicate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash_logo.png"]];
    
    
    //    imageView.center = self.view.center;
    
    storiesLogoX = _storiesLogoLbl.frame.origin.x;
    textImageLogoX = _leadConstraint.constant;
    _imageView.frame = CGRectMake(-200, _imageView.frame.origin.y,_imageView.frame.size.width,_imageView.frame.size.height);
    //    _textImageView.frame = CGRectMake(-500, _textImageView.frame.origin.y, _textImageView.frame.size.width, _textImageView.frame.size.height);
    
    _storiesLogoLbl.frame = CGRectMake(self.view.frame.size.width+200, _storiesLogoLbl.frame.origin.y, _storiesLogoLbl.frame.size.width, _storiesLogoLbl.frame.size.height);
    
    
    [self animateSplashScreen];
    
    isOpenOnce = NO;
    isCloseAnimation = NO;
    [self setUpLocationManager];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _leadConstraint.constant = 400;
    _trailConstraint.constant = -200;
    [_storiesLogoLbl updateConstraintsIfNeeded];
    [_textImageView updateConstraintsIfNeeded];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)setUpLocationManager{
    
    APP_DELEGATE.locationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]){
        [APP_DELEGATE.locationManager requestWhenInUseAuthorization];
        //        [self.locationManager requestAlwaysAuthorization];
        //        [_locationManager requestAlwaysAuthorization];
        
        [APP_DELEGATE.locationManager requestAlwaysAuthorization];
        
        APP_DELEGATE.locationManager.distanceFilter = 1000.0f;
        APP_DELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [APP_DELEGATE.locationManager startUpdatingLocation];
        APP_DELEGATE.locationManager.delegate = self;
        
    }
    
}

#pragma mark - CLLOCATION DELEGATE
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation* location = [locations lastObject];
    [APP_DELEGATE.locationManager stopUpdatingLocation];
    //    CLLocation *newLocation = locations.lastObject;
    //
    //    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    //    if (locationAge > 5.0) return;
    //
    //    if (newLocation.horizontalAccuracy < 0) return;
    
    [APP_DELEGATE setCurrentLocationCoordinate:location.coordinate];
    
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude ];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude ];
    APP_DELEGATE.isLocationEnabled = YES;
    dispatch_once(&predicate, ^{
        //your code here
        
        __weak InitialSplashViewController *weakRef = self;
        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:@"30"withLanguageLocale:@"en" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(BOOL isResultSuccess, NSError *error) {
             
             if (error!=nil) {
                 [weakRef.navigationController.view makeToast:@"Unable to load Monuments List."
                                                     duration:1.0
                                                     position:CSToastPositionCenter];
                 [self openSplashViewController];
                 
                 
             }else{
                 
                 [self setUpLanguageCall];
                 
                 
             }
             
             
             
             
             
         }];
        
    });
    
    
    
    
}
-(void)setUpLanguageCall{
    if(![[LanguageDataManager sharedManager] isLanguageDataExistInCoreData]){
        [[TTAPIHandler sharedWorker] getLanguageMappingwithRequestType:GET_LANGUAGE_MAPPING withResponseHandler:^(BOOL isSuccess, NSError *error) {
            [[LanguageDataManager sharedManager] setInitialDefaultLanguage];
            if (isSuccess) {
                if (!APP_DELEGATE.isLocationEnabled) {
                    isCloseAnimation = YES;
                    [self openSplashViewController];
                    return ;
                }
                [self callGMSPlaceLikelihood];
            }else{
                [self openSplashViewController];
            }
            
        }];
    }else{
        
        [[LanguageDataManager sharedManager] setInitialDefaultLanguage];
        if (!APP_DELEGATE.isLocationEnabled) {
            isCloseAnimation = YES;
            [self openSplashViewController];
            return ;
        }
        [self callGMSPlaceLikelihood];
        
        
    }
}
-(void)callGMSPlaceLikelihood{
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        GMSPlaceLikelihood *likelihood =   [likelihoodList.likelihoods objectAtIndex:0];
        
        GMSPlace *place = likelihood.place;
        NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
        NSLog(@"Current Place address %@", place.formattedAddress);
        NSLog(@"Current Place attributions %@", place.attributions);
        NSLog(@"Current PlaceID %@", place.placeID);
        
        
        [APP_DELEGATE setCurrentLocationAddress:place.formattedAddress];
        isCloseAnimation = YES;
        
        [self openSplashViewController];
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    APP_DELEGATE.isLocationEnabled = NO;
    [self setUpLanguageCall];
    [APP_DELEGATE checkForNetworkServiceEnabled];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
-(void)openSplashViewController{
    NSDictionary *loggedInUserDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserInfo"];
    
    
    if(loggedInUserDict!=nil){
        [APP_DELEGATE setLoggedInUserData:loggedInUserDict isFacebookData:NO];
        
        //       SWRevealController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:<#(UIViewController *)#> frontViewController:<#(UIViewController *)#>]
        //        UIViewController *Cc = self.revealViewController;
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        HomeViewController * homeVC = [sb instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        MenuTableViewController *menuTableVC = [sb instantiateViewControllerWithIdentifier:@"MenuTableViewController"];
        
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                        initWithRearViewController:menuTableVC frontViewController:nav];
        
        [self.navigationController pushViewController:mainRevealController animated:YES];
        
    }else{
        if(!isOpenOnce){
            SplashViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
            
            [self.navigationController pushViewController:nav animated:YES];
            isOpenOnce = YES;
            
        }
    }
    
}

-(void)animateSplashScreen{
    
    __weak InitialSplashViewController *weakRef = self;
    [UIView animateWithDuration:3 animations:^{
        
        weakRef.imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2)-(150/2), weakRef.imageView.frame.origin.y,weakRef.imageView.frame.size.width,weakRef.imageView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        weakRef.leadConstraint.constant = -6;
        [weakRef.textImageView updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:20 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [weakRef.textImageView layoutIfNeeded];
        } completion:^(BOOL finished) {
            //            weakRef.trailConstraint.constant = -28;
            //            [weakRef.storiesLogoLbl updateConstraintsIfNeeded];
            
            [UIView animateWithDuration:10 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakRef.trailConstraint.constant = -18;
                [weakRef.storiesLogoLbl updateConstraintsIfNeeded];
                
                
            } completion:^(BOOL finished) {
                //                [weakRef openSplashViewController];
                
            }];
        }];
        
        
        
        
        //           [weakRef performSelector:@selector(animate) withObject:nil afterDelay:3.0];
        
        
        
        /*
         if(isCloseAnimation){
         
         
         [weakRef performSelector:@selector(animate) withObject:nil afterDelay:3.0];
         
         
         }
         */
        /*else{
         weakRef.imageView.frame = CGRectMake(-200, weakRef.imageView.frame.origin.y,weakRef.imageView.frame.size.width,weakRef.imageView.frame.size.height);
         
         [weakRef animateSplashScreen];
         
         }*/
        
    }];
    
}
-(void)animate{
    __weak InitialSplashViewController *weakRef = self;
    
    
    [UIView animateWithDuration:5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakRef.leadConstraint.constant = -6;
        [weakRef.textImageView updateConstraintsIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:4 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakRef.trailConstraint.constant = -28;
            [weakRef.storiesLogoLbl updateConstraintsIfNeeded];
            
            
        } completion:^(BOOL finished) {
            [weakRef openSplashViewController];
            
        }];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.imageView.image = nil;
    self.storiesLogoLbl = nil;
    self.textImageView  = nil;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
