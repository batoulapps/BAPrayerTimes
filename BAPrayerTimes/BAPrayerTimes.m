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

@implementation BAPrayerTimes

- (instancetype)initWithLatitude:(double)latitude
                       longitude:(double)longitude
                        timeZone:(NSTimeZone *)timeZone
                          method:(BAPrayerMethod)method
                          madhab:(BAPrayerMadhab)madhab
{
    return [self initWithLatitude:latitude
                        longitude:longitude
                         timeZone:timeZone
                           method:method
                           madhab:madhab
                  customFajrAngle:18.0
                  customIshaAngle:17.0
             manualAdjustmentFajr:0
          manualAdjustmentSunrise:0
            manualAdjustmentDhuhr:0
              manualAdjustmentAsr:0
          manualAdjustmentMaghrib:0
             manualAdjustmentIsha:0];
}

- (instancetype)initWithLatitude:(double)latitude
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
    return [self initWithLatitude:latitude
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
                    extremeMethod:15
                             date:[NSDate date]];
}

- (instancetype)initWithLatitude:(double)latitude
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
                            date:(NSDate *)date
{
    self = [super init];
    if (self) {
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
        _date = [NSDate date];
        
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

    NSDateComponents *comps = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];

    date.day = (int)comps.day;
    date.month = (int)comps.month;
    date.year = (int)comps.year;

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

    /* calculate prayer times */
    getPrayerTimes(&loc, &conf, &date, ptList);

    /* get tomorrow's fajr */
    getNextDayFajr(&loc, &conf, &date, &nextFajr);

    for (int i = 0; i < 6; i++) {
        comps.hour = ptList[i].hour;
        comps.minute = ptList[i].minute;
        comps.second = ptList[i].second;

        switch (i) {
            case 0:
                comps.minute = comps.minute + self.manualAdjustmentFajr;
                _fajrTime = [self.calendar dateFromComponents:comps];
                break;
            case 1:
                comps.minute = comps.minute + self.manualAdjustmentSunrise;
                _sunriseTime = [self.calendar dateFromComponents:comps];
                break;
            case 2:
                comps.minute = comps.minute + self.manualAdjustmentDhuhr;
                _dhuhrTime = [self.calendar dateFromComponents:comps];
                break;
            case 3:
                comps.minute = comps.minute + self.manualAdjustmentAsr;
                _asrTime = [self.calendar dateFromComponents:comps];
                break;
            case 4:
                comps.minute = comps.minute + self.manualAdjustmentMaghrib;
                _maghribTime = [self.calendar dateFromComponents:comps];
                break;
            case 5:
                comps.minute = comps.minute + self.manualAdjustmentIsha;
                _ishaTime = [self.calendar dateFromComponents:comps];
                break;
        }
    }

    comps.day++;
    comps.hour = nextFajr.hour;
    comps.minute = nextFajr.minute + self.manualAdjustmentFajr;
    comps.second = nextFajr.second;

    _tomorrowFajrTime = [self.calendar dateFromComponents:comps];
}

@end
