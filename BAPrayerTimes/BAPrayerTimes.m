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
              customIshaAngle:17.0
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
    
    /* The MCW method compares against a calculated angle of 18 degrees */
    BAPrayerMethod calculationMethod = self.method == BAPrayerMethodMCW ? BAPrayerMethodKarachiShafi : self.method;
    
    /* fill the method configuration parameters with default values  */
    getMethod(calculationMethod, &conf);
    
    /* use normal rounding */
    conf.round = 1;
    
    /* override default madhab with our value */
    conf.mathhab = self.madhab;
    
    if(self.method == BAPrayerMethodNone) {
        conf.fajrAng = self.customFajrAngle;
        conf.ishaaAng = self.customIshaAngle;
    } else if (self.method == BAPrayerMethodISNA) {
        /* The ITL values for NORTH_AMERICA are 17.5 and 15 which
         approximate the MCW method. As we have the MCW method
         available, we will use the North America legacy
         values for those who still want to use it */
        conf.fajrAng = 15.0;
        conf.ishaaAng = 15.0;
    }
    
    /* method to use for extreme locations */
    conf.extreme = (int)self.extremeMethod;
    
    
    /* above 55 degrees latitude use the extreme method */
    conf.nearestLat = 55.0;
    
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
    
    if(self.method == BAPrayerMethodMCW) {
        [self calculatePrayerTimesForMCW];
    }
}

- (void)calculatePrayerTimesForMCW
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps.minute = (-1 * [self seasonalFajrOffset]) - self.manualAdjustmentSunrise;
    NSDate *adjustedFajrTime = [self.calendar dateByAddingComponents:comps toDate:_sunriseTime options:0];
    
    comps.minute = [self seasonalIshaOffset] - self.manualAdjustmentMaghrib;
    NSDate *adjustedIshaTime = [self.calendar dateByAddingComponents:comps toDate:_maghribTime options:0];
    
    comps.minute = 5;
    _dhuhrTime = [self.calendar dateByAddingComponents:comps toDate:_dhuhrTime options:0];
    
    comps.minute = 3;
    _maghribTime = [self.calendar dateByAddingComponents:comps toDate:_maghribTime options:0];
    
    if ([adjustedFajrTime compare:_fajrTime] == NSOrderedDescending) {
        _fajrTime = adjustedFajrTime;
    }
    
    if ([adjustedIshaTime compare:_ishaTime] == NSOrderedAscending) {
        _ishaTime = adjustedIshaTime;
    }
}

- (NSInteger)seasonalFajrOffset
{
    float A, B, C, D;
    
    NSUInteger dayOfYear = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date];
    NSInteger DYY = dayOfYear + 10;
    
    A = 75 + 28.65 / 55.0 * abs(self.latitude);
    B = 75 + 19.44 / 55.0 * abs(self.latitude);
    C = 75 + 32.74 / 55.0 * abs(self.latitude);
    D = 75 + 48.1 / 55.0 * abs(self.latitude);
    
    if ( DYY < 91) {
        A = A + ( B - A )/ 91.0 * DYY;
    } else if ( DYY < 137) {
        A = B + ( C - B ) / 46.0 * ( DYY - 91 );
    } else if ( DYY< 183 ) {
        A = C + ( D - C ) / 46.0 * ( DYY - 137 );
    } else if ( DYY < 229 ) {
        A = D + ( C - D ) / 46.0 * ( DYY - 183 );
    } else if ( DYY < 275 ) {
        A = C + ( B - C ) / 46.0 * ( DYY - 229 );
    } else if ( DYY >= 275 ) {
        A = B + ( A - B ) / 91.0 * ( DYY - 275 );
    }
    
    return (NSInteger)round(A);
}

- (NSInteger)seasonalIshaOffset
{
    float A, B, C, D;
    
    NSUInteger dayOfYear = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date];
    NSInteger DYY = dayOfYear + 10;
    
    A = 75 + 25.6 / 55.0 * abs(self.latitude);
    B = 75 + 2.05 / 55.0 * abs(self.latitude);
    C = 75 - 9.21 / 55.0 * abs(self.latitude);
    D = 75 + 6.14 / 55.0 * abs(self.latitude);
    
    if ( DYY < 91) {
        A = A + ( B - A )/ 91.0 * DYY;
    } else if ( DYY < 137) {
        A = B + ( C - B ) / 46.0 * ( DYY - 91 );
    } else if ( DYY< 183 ) {
        A = C + ( D - C ) / 46.0 * ( DYY - 137 );
    } else if ( DYY < 229 ) {
        A = D + ( C - D ) / 46.0 * ( DYY - 183 );
    } else if ( DYY < 275 ) {
        A = C + ( B - C ) / 46.0 * ( DYY - 229 );
    } else if ( DYY >= 275 ) {
        A = B + ( A - B ) / 91.0 * ( DYY - 275 );
    }
    
    return (NSInteger)round(A);
}

@end
