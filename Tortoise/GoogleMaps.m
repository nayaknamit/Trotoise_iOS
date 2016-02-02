//
//  GoogleMaps.m
//  Tortoise
//

#import "GoogleMaps.h"
@import GoogleMaps;

CLLocationManager *locationManager;

@interface GoogleMaps ()
    @property (nonatomic,strong) GMSCameraPosition *camera;
    @property (nonatomic,strong) GMSMapView *mapView;
@end

@implementation GoogleMaps

-(id)init{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    if(self = [super init]){
        
        
    }
    return self;
    
}

-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude zoom:(float)zoomScale title:(NSString*)title snippet:(NSString*)snippet frame:(CGRect)rect{
    
    if (longitude == 0 && latitude == 0) {

        //Set the user's current location
        latitude = locationManager.location.coordinate.latitude;
        longitude = locationManager.location.coordinate.longitude;
        
        
        //Show message if user doesn't have the connection
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"longitude: %f", longitude);
        NSLog(@"latitude: %f", latitude);
        
    }
    
    if(self=[super initWithFrame:rect]){
        _camera = [GMSCameraPosition cameraWithLatitude:latitude
                                              longitude:longitude
                                                   zoom:zoomScale];
        
        _mapView = [GMSMapView mapWithFrame:rect camera:_camera];
        _mapView.myLocationEnabled = YES;
        _mapView.settings.compassButton = YES;
        _mapView.settings.myLocationButton = YES;
        
        // Listen to the myLocation property of GMSMapView.
        [_mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
//
        
        // Creates a marker in the center of the map.
        self.frame = rect;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.title = title;
        marker.snippet = snippet;
        marker.map = _mapView;
        [self addSubview:_mapView];
    }
    return self;
}
- (void)didChangeValueForKey:(NSString *)key{
    
    
}


@end
