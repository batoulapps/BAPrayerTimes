//
//  BAPrayerTimes.m
//  BAPrayerTimes
//
//  Created by Ameir Al-Zoubi on 8/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import "BAPrayerTimes.h"
#import "astro.h"

@interface BAPrayerTimes ()

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (assign, nonatomic) BAPrayerMethod method;
@property (assign, nonatomic) BAPrayerMadhab madhab;
@property (assign, nonatomic) double customFajrAngle;
@property (assign, nonatomic) double customIshaAngle;
@property (assign, nonatomic) NSInteger manualAdjustmentFajr;
@property (assign, nonatomic) NSInteger manualAdjustmentSunrise;
@property (assign, nonatomic) NSInteger manualAdjustmentDhuhr;
@property (assign, nonatomic) NSInteger manualAdjustmentAsr;
@property (assign, nonatomic) NSInteger manualAdjustmentMaghrib;
@property (assign, nonatomic) NSInteger manualAdjustmentIsha;
@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic) BAExtremeMethod extremeMethod;
@property (assign, nonatomic) double extremeLatitude;

@end

static BAExtremeMethod const kBADefaultExtremeMethod = BAExtremeMethodSeventhOfNight;
static double const kBADefaultExtremeLatitude = 48.5;

@implementation BAPrayerTimes

- (instancetype)initWithDate:(NSDate *)date
                    latitude:(double)latitude
                   longitude:(double)longitude
                    timeZone:(NSTimeZone *)timeZone
                      method:(BAPrayerMethod)method
                      madhab:(BAPrayerMadhab)madhab
{
    return [self initWithDate:date
                     latitude:latitude
                    longitude:longitude
                     timeZone:timeZone
                       method:method
                       madhab:madhab
              customFajrAngle:18.0
              customIshaAngle:18.0
         manualAdjustmentFajr:0
      manualAdjustmentSunrise:0
        manualAdjustmentDhuhr:0
          manualAdjustmentAsr:0
      manualAdjustmentMaghrib:0
         manualAdjustmentIsha:0];
}

- (instancetype)initWithDate:(NSDate *)date
                    latitude:(double)latitude
                   longitude:(double)longitude
                    timeZone:(NSTimeZone *)timeZone
                      method:(BAPrayerMethod)method
                      madhab:(BAPrayerMadhab)madhab
             customFajrAngle:(double)customFajrAngle
             customIshaAngle:(double)customIshaAngle
        manualAdjustmentFajr:(NSInteger)manualAdjustmentFajr
     manualAdjustmentSunrise:(NSInteger)manualAdjustmentSunrise
       manualAdjustmentDhuhr:(NSInteger)manualAdjustmentDhuhr
         manualAdjustmentAsr:(NSInteger)manualAdjustmentAsr
     manualAdjustmentMaghrib:(NSInteger)manualAdjustmentMaghrib
        manualAdjustmentIsha:(NSInteger)manualAdjustmentIsha
{
    return [self initWithDate:date
                     latitude:latitude
                    longitude:longitude
                     timeZone:timeZone
                       method:method
                       madhab:madhab
              customFajrAngle:customFajrAngle
              customIshaAngle:customIshaAngle
         manualAdjustmentFajr:manualAdjustmentFajr
      manualAdjustmentSunrise:manualAdjustmentSunrise
        manualAdjustmentDhuhr:manualAdjustmentDhuhr
          manualAdjustmentAsr:manualAdjustmentAsr
      manualAdjustmentMaghrib:manualAdjustmentMaghrib
         manualAdjustmentIsha:manualAdjustmentIsha
                extremeMethod:kBADefaultExtremeMethod
              extremeLatitude:kBADefaultExtremeLatitude];
}

- (instancetype)initWithDate:(NSDate *)date
                    latitude:(double)latitude
                   longitude:(double)longitude
                    timeZone:(NSTimeZone *)timeZone
                      method:(BAPrayerMethod)method
                      madhab:(BAPrayerMadhab)madhab
             customFajrAngle:(double)customFajrAngle
             customIshaAngle:(double)customIshaAngle
        manualAdjustmentFajr:(NSInteger)manualAdjustmentFajr
     manualAdjustmentSunrise:(NSInteger)manualAdjustmentSunrise
       manualAdjustmentDhuhr:(NSInteger)manualAdjustmentDhuhr
         manualAdjustmentAsr:(NSInteger)manualAdjustmentAsr
     manualAdjustmentMaghrib:(NSInteger)manualAdjustmentMaghrib
        manualAdjustmentIsha:(NSInteger)manualAdjustmentIsha
               extremeMethod:(BAExtremeMethod)extremeMethod
             extremeLatitude:(double)extremeLatitude
{
    self = [super init];
    if (self) {
        _date = date;
        _latitude = latitude;
        _longitude = longitude;
        _timeZone = timeZone;
        _method = method;
        _madhab = madhab;
        _customFajrAngle = customFajrAngle;
        _customIshaAngle = customIshaAngle;
        _manualAdjustmentFajr = manualAdjustmentFajr;
        _manualAdjustmentSunrise = manualAdjustmentSunrise;
        _manualAdjustmentDhuhr = manualAdjustmentDhuhr;
        _manualAdjustmentAsr = manualAdjustmentAsr;
        _manualAdjustmentMaghrib = manualAdjustmentMaghrib;
        _manualAdjustmentIsha = manualAdjustmentIsha;
        _extremeMethod = extremeMethod;
        _extremeLatitude = extremeLatitude;
        
#ifdef __IPHONE_8_0
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        
        [self calculatePrayerTimes];
    }
    return self;
}


#pragma mark - Date Calculation

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self calculatePrayerTimes];
}

#pragma mark - Calculation

- (void)calculatePrayerTimes
{
    Location loc;
    Method conf;
    Date date;

    Prayer ptList[6];
    Prayer nextFajr;
    
#ifdef __IPHONE_8_0
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.date];
#else
    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
#endif

    date.day = (int)components.day;
    date.month = (int)components.month;
    date.year = (int)components.year;

    loc.degreeLat = self.latitude;
    loc.degreeLong = self.longitude;

    NSInteger secondsFromGMT = [self.timeZone secondsFromGMTForDate:self.date];
    /* convert to hours */
    loc.gmtDiff = (double)secondsFromGMT/60.0/60.0;

    /* gmtDiff already contains DST adjustment so we keep this at 0 */
    loc.dst = 0;

    /* default values */
    loc.seaLevel = 0;
    loc.pressure = 1010;
    loc.temperature= 10;

    /* fill the method configuration parameters with default values  */
    getMethod(self.method, &conf);

    /* use normal rounding */
    conf.round = 1;

    /* override default madhab with our value */
    conf.mathhab = self.madhab;

    if(self.method == BAPrayerMethodNone) {
        conf.fajrAng = self.customFajrAngle;
        conf.ishaaAng = self.customIshaAngle;
    }

    /* method to use for extreme locations */
    conf.extreme = (int)self.extremeMethod;
    conf.extremeLat = self.extremeLatitude;

    conf.offset = 1;
    conf.offList[0] = self.manualAdjustmentFajr;
    conf.offList[1] = self.manualAdjustmentSunrise;
    conf.offList[2] = self.manualAdjustmentDhuhr;
    conf.offList[3] = self.manualAdjustmentAsr;
    conf.offList[4] = self.manualAdjustmentMaghrib;
    conf.offList[5] = self.manualAdjustmentIsha;

    /* calculate prayer times */
    getPrayerTimes(&loc, &conf, &date, ptList);

    /* get tomorrow's fajr */
    getNextDayFajr(&loc, &conf, &date, &nextFajr);

    for (int i = 0; i < 6; i++) {
        components.hour = ptList[i].hour;
        components.minute = ptList[i].minute;
        components.second = ptList[i].second;

        [self setTime:[self.calendar dateFromComponents:components] forPrayerType:(BAPrayerType)i];
    }

    components.day++;
    components.hour = nextFajr.hour;
    components.minute = nextFajr.minute;
    components.second = nextFajr.second;

    [self setTime:[self.calendar dateFromComponents:components] forPrayerType:BAPrayerTypeTomorrowFajr];
    
    // adjust dates for post-midnight values
    for (NSInteger i = 1; i < 6; i++) {
        NSDate *previousPrayerTime = [self prayerTimeForType:i-1];
        NSDate *prayerTime = [self prayerTimeForType:i];
        if ([previousPrayerTime compare:prayerTime] > NSOrderedSame) {
            NSDateComponents *adjustmentComponents = [[NSDateComponents alloc] init];
            adjustmentComponents.day = 1;
            prayerTime = [self.calendar dateByAddingComponents:adjustmentComponents toDate:prayerTime options:0];
            [self setTime:prayerTime forPrayerType:(BAPrayerType)i];
        }
    }
}

- (NSDate *)prayerTimeForType:(BAPrayerType)prayerType
{
    switch (prayerType) {
        case BAPrayerTypeFajr:
            return self.fajrTime;
        case BAPrayerTypeSunrise:
            return self.sunriseTime;
        case BAPrayerTypeDhuhr:
            return self.dhuhrTime;
        case BAPrayerTypeAsr:
            return self.asrTime;
        case BAPrayerTypeMaghrib:
            return self.maghribTime;
        case BAPrayerTypeIsha:
            return self.ishaTime;
        case BAPrayerTypeTomorrowFajr:
            return self.tomorrowFajrTime;
        case BAPrayerTypeNone:
            return nil;
    }
}

- (BAPrayerType)currentPrayerTypeForDate:(NSDate *)date
{
    BAPrayerType currentPrayer = BAPrayerTypeNone;
    
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *prayerTime = [self prayerTimeForType:i];
        if ([prayerTime compare:date] == NSOrderedDescending) {
            currentPrayer = (i + 6 - 1) % 6;
            break;
        }
    }
    
    return currentPrayer;
}

- (BAPrayerType)nextPrayerTypeForDate:(NSDate *)date
{
    if ([self.fajrTime compare:date] == NSOrderedDescending) {
        return BAPrayerTypeFajr;
    }
    
    BAPrayerType currentPrayer = [self currentPrayerTypeForDate:date];
    return (currentPrayer + 1) % 7;
}

#pragma mark - Helpers

- (void)setTime:(NSDate *)prayerTime forPrayerType:(BAPrayerType)prayerType
{
    switch (prayerType) {
        case BAPrayerTypeFajr:
            _fajrTime = prayerTime;
            break;
        case BAPrayerTypeSunrise:
            _sunriseTime = prayerTime;
            break;
        case BAPrayerTypeDhuhr:
            _dhuhrTime = prayerTime;
            break;
        case BAPrayerTypeAsr:
            _asrTime = prayerTime;
            break;
        case BAPrayerTypeMaghrib:
            _maghribTime = prayerTime;
            break;
        case BAPrayerTypeIsha:
            _ishaTime = prayerTime;
            break;
        case BAPrayerTypeTomorrowFajr:
            _tomorrowFajrTime = prayerTime;
            break;
        case BAPrayerTypeNone:
            //no-op
            break;
    }
}

@end
