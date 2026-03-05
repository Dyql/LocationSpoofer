#import <CoreLocation/CoreLocation.h>

%hook CLLocation

- (CLLocationCoordinate2D)coordinate {
    // الإحداثيات الجديدة التي حددتها (القصيم)
    double baseLat = 26.355237;
    double baseLon = 43.955600;

    // إضافة "ارتجاج" عشوائي (Jitter) يحاكي طبيعة إشارة الـ GPS
    // نستخدم أرقاماً صغيرة جداً ليبقى الموقع ضمن نطاق المبنى المحدد
    double latNoise = ((double)arc4random() / 0xFFFFFFFFu) * 0.00003 - 0.000015;
    double lonNoise = ((double)arc4random() / 0xFFFFFFFFu) * 0.00003 - 0.000015;

    return CLLocationCoordinate2DMake(baseLat + latNoise, baseLon + lonNoise);
}

// تزييف الدقة لتكون متغيرة (بين 5 و 12 متر) لإيهام فلاتر السيرفر
- (CLLocationAccuracy)horizontalAccuracy {
    return 5.0 + ((double)arc4random() / 0xFFFFFFFFu) * 7.0;
}

// تزييف الارتفاع ليتناسب مع منطقة القصيم (حوالي 600-650 متر)
- (CLLocationDistance)altitude {
    return 605.0 + ((double)arc4random() / 0xFFFFFFFFu) * 5.0;
}

// تحديث الوقت للحظة الحالية لمنع كشف "البيانات القديمة"
- (NSDate *)timestamp {
    return [NSDate date];
}

%end
