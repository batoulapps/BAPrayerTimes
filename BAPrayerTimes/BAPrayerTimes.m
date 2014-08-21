//
//  BAPrayerTimes.m
//  BAPrayerTimes
//
//  Created by Ameir Al-Zoubi on 8/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import "BAPrayerTimes.h"
#import "astro.h"

NSString * const kBAPrayerTimesFajr = @"fajr";
NSString * const kBAPrayerTimesShuruq = @"shuruq";
NSString * const kBAPrayerTimesDhuhr = @"dhuhr";
NSString * const kBAPrayerTimesAsr = @"asr";
NSString * const kBAPrayerTimesMaghrib = @"maghrib";
NSString * const kBAPrayerTimesIsha = @"isha";
NSString * const kBAPrayerTimesFajrTomorrow = @"tomorrowFajr";

@interface BAPrayerTimes ()

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation BAPrayerTimes

- (id)initWithLatitude:(double)latitude longitude:(double)longitude timeZone:(NSTimeZone *)timeZone method:(BAPrayerMethod)method madhab:(BAPrayerMadhab)madhab
{
self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
        _timeZone = timeZone;
        _method = method;
        _madhab = madhab;
        _customFajrAngle = 0.0;
        _customIshaAngle = 0.0;
        _manualAdjustmentFajr = 0;
        _manualAdjustmentShuruq = 0;
        _manualAdjustmentDhuhr = 0;
        _manualAdjustmentAsr = 0;
        _manualAdjustmentMaghrib = 0;
        _manualAdjustmentIsha = 0;

        /* defaulting to the angle based division of the night for extreme location
        see prayer.h for all possible values */
        _extremeMethod = 15;

        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return self;
}

- (NSDate *)prayerTimeForPrayer:(NSString *)prayerKey
{
    return [self prayerTimeForPrayer:prayerKey date:[NSDate date]];
}

- (NSDate *)prayerTimeForPrayer:(NSString *)prayerKey date:(NSDate *)date
{
    NSDictionary *calculatedPrayerTimes = [self prayerTimesForDate:date];
    
    return calculatedPrayerTimes[prayerKey];
}

- (NSDictionary *)prayerTimes
{
    return [self prayerTimesForDate:[NSDate date]];
}

- (NSDictionary *)prayerTimesForDate:(NSDate *)cocoaDate
{
    Location loc;
    Method conf;
    Date date;

    Prayer ptList[6];
    Prayer nextFajr;

    NSDateComponents *comps = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:cocoaDate];

    date.day = (int)comps.day;
    date.month = (int)comps.month;
    date.year = (int)comps.year;

    loc.degreeLat = self.latitude;
    loc.degreeLong = self.longitude;

    NSInteger secondsFromGMT = [self.timeZone secondsFromGMTForDate:cocoaDate];
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

    const NSArray *prayerKeys = @[kBAPrayerTimesFajr, kBAPrayerTimesShuruq, kBAPrayerTimesDhuhr, kBAPrayerTimesAsr, kBAPrayerTimesMaghrib, kBAPrayerTimesIsha];

    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < 6; i++) {
        comps.hour = ptList[i].hour;
        comps.minute = ptList[i].minute;
        comps.second = ptList[i].second;

        switch (i) {
            case 0:
                comps.minute = comps.minute + self.manualAdjustmentFajr;
                break;
            case 1:
                comps.minute = comps.minute + self.manualAdjustmentShuruq;
                break;
            case 2:
                comps.minute = comps.minute + self.manualAdjustmentDhuhr;
                break;
            case 3:
                comps.minute = comps.minute + self.manualAdjustmentAsr;
                break;
            case 4:
                comps.minute = comps.minute + self.manualAdjustmentMaghrib;
                break;
            case 5:
                comps.minute = comps.minute + self.manualAdjustmentIsha;
                break;
        }

        [results setObject:[self.calendar dateFromComponents:comps] forKey:[prayerKeys objectAtIndex:i]];
    }

    comps.day++;
    comps.hour = nextFajr.hour;
    comps.minute = nextFajr.minute + self.manualAdjustmentFajr;
    comps.second = nextFajr.second;

    [results setObject:[self.calendar dateFromComponents:comps] forKey:kBAPrayerTimesFajrTomorrow];

    return [results copy];
}

@end
