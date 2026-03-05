#import <CoreLocation/CoreLocation.h>

// متغيرات ثابتة لحفظ حالة الموقع (لجعل القراءة تعتمد على ما قبلها)
static double lastLatOffset = 0;
static double lastLonOffset = 0;

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    // إحداثيات القصيم
    double baseLat = 26.355237; 
    double baseLon = 43.955600;

    // محاكاة "السير العشوائي" (Random Walk)
    // نغير الموقع بمقدار ضئيل جداً بناءً على آخر موقع
    double step = 0.000005; 
    lastLatOffset += (((double)arc4random() / 0xFFFFFFFFu) * step * 2) - step;
    lastLonOffset += (((double)arc4random() / 0xFFFFFFFFu) * step * 2) - step;

    // وضع حدود (Boundaries) لكي لا يبتعد الموقع كثيراً عن المكتب
    if (fabs(lastLatOffset) > 0.00005) lastLatOffset *= 0.9;
    if (fabs(lastLonOffset) > 0.00005) lastLonOffset *= 0.9;

    return CLLocationCoordinate2DMake(baseLat + lastLatOffset, baseLon + lastLonOffset);
}

%end
