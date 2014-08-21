//
//  BAPrayerTimes.h
//  BAPrayerTimes
//
//  Created by Ameir Al-Zoubi on 8/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BAPrayerMethodNone, // this will use the customFajrAngle and customIshaAngle
    BAPrayerMethodEgyptianGeneralAuthorityOfSurvey,
    BAPrayerMethodKarachiShafi,
    BAPrayerMethodKarachiHanafi,
    BAPrayerMethodISNA,
    BAPrayerMethodMWL,
    BAPrayerMethodUmmQurra,
    BAPrayerMethodFixedIsha,
    BAPrayerMethodNewEgyptianAuthority,
    BAPrayerMethodUmmQurraRamadan
} BAPrayerMethod;

typedef enum {
    BAPrayerMadhabShafi = 1,
    BAPrayerMadhabHanafi
} BAPrayerMadhab;

extern NSString * const kBAPrayerTimesFajr;
extern NSString * const kBAPrayerTimesShuruq;
extern NSString * const kBAPrayerTimesDhuhr;
extern NSString * const kBAPrayerTimesAsr;
extern NSString * const kBAPrayerTimesMaghrib;
extern NSString * const kBAPrayerTimesIsha;
extern NSString * const kBAPrayerTimesFajrTomorrow;

@interface BAPrayerTimes : NSObject

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (assign, nonatomic) BAPrayerMethod method;
@property (assign, nonatomic) BAPrayerMadhab madhab;

@property (assign, nonatomic) double customFajrAngle;
@property (assign, nonatomic) double customIshaAngle;
@property (assign, nonatomic) NSInteger manualAdjustmentFajr;
@property (assign, nonatomic) NSInteger manualAdjustmentShuruq;
@property (assign, nonatomic) NSInteger manualAdjustmentDhuhr;
@property (assign, nonatomic) NSInteger manualAdjustmentAsr;
@property (assign, nonatomic) NSInteger manualAdjustmentMaghrib;
@property (assign, nonatomic) NSInteger manualAdjustmentIsha;
@property (assign, nonatomic) NSInteger extremeMethod;

- (id)initWithLatitude:(double)latitude longitude:(double)longitude timeZone:(NSTimeZone *)timeZone method:(BAPrayerMethod)method madhab:(BAPrayerMadhab)madhab;

- (NSDictionary *)prayerTimes;
- (NSDictionary *)prayerTimesForDate:(NSDate *)date;
- (NSDate *)prayerTimeForPrayer:(NSString *)prayerKey;
- (NSDate *)prayerTimeForPrayer:(NSString *)prayerKey date:(NSDate *)date;

@end
