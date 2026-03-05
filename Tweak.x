#import <CoreLocation/CoreLocation.h>

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    // الإحداثيات الوهمية
    return CLLocationCoordinate2DMake(24.7136, 46.6753); 
}

%end
