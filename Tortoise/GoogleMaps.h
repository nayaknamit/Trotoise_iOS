//
//  GoogleMaps.h
//  Tortoise
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleMaps : UIView
-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude zoom:(float)zoomScale title:(NSString*)title snippet:(NSString*)snippet frame:(CGRect)rect;

@end
