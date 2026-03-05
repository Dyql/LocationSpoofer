#import <CoreLocation/CoreLocation.h>

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    // الإحداثيات الوهمية
    return CLLocationCoordinate2DMake(26.355237, 43.955600); 
}

%end
