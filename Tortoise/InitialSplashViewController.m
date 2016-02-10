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
#import "LanguageDataManager.h"
@interface InitialSplashViewController ()<CLLocationManagerDelegate>
{
   IBOutlet UIImageView *imageView;
    BOOL isOpenOnce;
}

@end
@implementation InitialSplashViewController
static dispatch_once_t predicate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash_logo.png"]];
    
    
//    imageView.center = self.view.center;
    
    imageView.frame = CGRectMake(-200, imageView.frame.origin.y,imageView.frame.size.width,imageView.frame.size.height);
    
//    [self.view insertSubview:imageView atIndex:1000];
    [self animateSplashScreen];
    
    isOpenOnce = NO;
    [self setUpLocationManager];
    
    
    
    
}


-(void)setUpLocationManager{
    
    APP_DELEGATE.locationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]){
        [APP_DELEGATE.locationManager requestWhenInUseAuthorization];
        //        [self.locationManager requestAlwaysAuthorization];
        //        [_locationManager requestAlwaysAuthorization];
        
        [APP_DELEGATE.locationManager requestAlwaysAuthorization];
        
        APP_DELEGATE.locationManager.distanceFilter = 1000.0f;
        APP_DELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
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
//    [[TTAPIHandler sharedWorker] getMonumentListByRange:@"28.467504" withLongitude:@"77.059479" withrad:radiusValue withRequestType:GET_MONUMENT_LIST_BY_RANGE responseHandler:^(NSArray *cityMonumentArra, NSError *error) {
//        _dataArra =  [NSMutableArray arrayWithArray:cityMonumentArra];
//        [self.tableView reloadData];
//        [self mapSetUpWithLatitude:location.coordinate.latitude withLongitude:location.coordinate.longitude];
//        
//        _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)_dataArra.count,radiusValue];
//        
//    }];
    
    if(TARGET_OS_SIMULATOR){
        
        lat = @"28.467504";
        longitude = @"77.059479";
    }
   
    dispatch_once(&predicate, ^{
        //your code here
        
        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:@"30" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(NSArray *cityMonumentArra, NSError *error) {
             
             [APP_DELEGATE setCityMonumentListArray:cityMonumentArra];
             if(![[LanguageDataManager sharedManager] isLanguageDataExistInCoreData]){
                 [[TTAPIHandler sharedWorker] getLanguageMappingwithRequestType:GET_LANGUAGE_MAPPING withResponseHandler:^(NSArray *languageMappingArra, NSError *error) {
                     
                     [APP_DELEGATE setLanguageDataArray:languageMappingArra];
                     [self openSplashViewController];
                 }];
             }else{
                 NSArray *languageArr = [[LanguageDataManager sharedManager] getParseAPIDataToLanguageDS:nil];
                 
                 [APP_DELEGATE setLanguageDataArray:languageArr];
                 [self openSplashViewController];
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
                     
                 }];

             }
             
             
             
         }];
        
    });
    

    
    
}
-(void)openSplashViewController{
    if(!isOpenOnce){
        
        SplashViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
        
        [self.navigationController pushViewController:nav animated:YES];
        isOpenOnce = YES;
        
    }
}

-(void)animateSplashScreen{
    [UIView animateWithDuration:3 animations:^{
        
        imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2)-(150/2), imageView.frame.origin.y,imageView.frame.size.width,imageView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        imageView.frame = CGRectMake(-200, imageView.frame.origin.y,imageView.frame.size.width,imageView.frame.size.height);
        [self animateSplashScreen];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
