#import <CoreLocation/CoreLocation.h>
#import <math.h>

// دالة لتوليد ضجيج يتبع التوزيع الطبيعي (Gaussian)
double generateGaussianNoise(double mean, double stdDev) {
    static double z1;
    static BOOL generate = NO;
    generate = !generate;

    if (!generate) return z1 * stdDev + mean;

    double u1, u2;
    do {
        u1 = (double)arc4random() / 0xFFFFFFFFu;
        u2 = (double)arc4random() / 0xFFFFFFFFu;
    } while (u1 <= 1e-7);

    double z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * M_PI * u2);
    z1 = sqrt(-2.0 * log(u1)) * sin(2.0 * M_PI * u2);
    return z0 * stdDev + mean;
}

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    // إحداثياتك المستهدفة في القصيم
    double baseLat = 26.355237;
    double baseLon = 43.955600;

    // إضافة ضجيج غاوسي بانحراف معياري صغير جداً (0.00001)
    // هذا يجعل البيانات تتبع توزيع "الجرس" الطبيعي بدلاً من التوزيع الموحد
    double latNoise = generateGaussianNoise(0, 0.00001);
    double lonNoise = generateGaussianNoise(0, 0.00001);

    return CLLocationCoordinate2DMake(baseLat + latNoise, baseLon + lonNoise);
}

- (CLLocationAccuracy)horizontalAccuracy {
    // محاكاة تغير الدقة بشكل طبيعي أيضاً
    return generateGaussianNoise(7.0, 1.5); 
}

- (NSDate *)timestamp {
    return [NSDate date];
}

%end
