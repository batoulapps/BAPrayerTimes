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
@property (assign, nonatomic) NSInteger extremeMethod;

@end

static NSInteger const kBADefaultExtremeMethod = 7;

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
                extremeMethod:kBADefaultExtremeMethod];
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
               extremeMethod:(NSInteger)extremeMethod
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
        
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
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
    
    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];

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

        switch (i) {
            case 0:
                _fajrTime = [self.calendar dateFromComponents:components];
                break;
            case 1:
                _sunriseTime = [self.calendar dateFromComponents:components];
                break;
            case 2:
                _dhuhrTime = [self.calendar dateFromComponents:components];
                break;
            case 3:
                _asrTime = [self.calendar dateFromComponents:components];
                break;
            case 4:
                _maghribTime = [self.calendar dateFromComponents:components];
                break;
            case 5:
                _ishaTime = [self.calendar dateFromComponents:components];
                break;
        }
    }

    components.day++;
    components.hour = nextFajr.hour;
    components.minute = nextFajr.minute;
    components.second = nextFajr.second;

    _tomorrowFajrTime = [self.calendar dateFromComponents:components];
}

@end
