//
//  BAPrayerTimes.h
//  BAPrayerTimes
//
//  Created by Ameir Al-Zoubi on 8/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BAPrayerMethod) {
    BAPrayerMethodNone, // this will use the customFajrAngle and customIshaAngle
    BAPrayerMethodEgyptianGeneralAuthorityOfSurvey,
    BAPrayerMethodKarachiShafi,
    BAPrayerMethodKarachiHanafi,
    BAPrayerMethodNorthAmerica,
    BAPrayerMethodMWL,
    BAPrayerMethodUmmQurra,
    BAPrayerMethodFixedIsha,
    BAPrayerMethodNewEgyptianAuthority,
    BAPrayerMethodUmmQurraRamadan,
    BAPrayerMethodMCW
};

typedef NS_ENUM(NSUInteger, BAPrayerMadhab) {
    BAPrayerMadhabShafi = 1,
    BAPrayerMadhabHanafi = 2,
};

typedef NS_ENUM(NSUInteger, BAPrayerType) {
    BAPrayerTypeFajr = 0,
    BAPrayerTypeSunrise,
    BAPrayerTypeDhuhr,
    BAPrayerTypeAsr,
    BAPrayerTypeMaghrib,
    BAPrayerTypeIsha,
    BAPrayerTypeTomorrowFajr,
    BAPrayerTypeNone
};

typedef NS_ENUM(NSUInteger, BAExtremeMethod) {
    BAExtremeMethodNearestLatitude = 3,
    BAExtremeMethodNearestGoodDay = 5,
    BAExtremeMethodSeventhOfNight = 7,
    BAExtremeMethodAngle = 15,
};

@interface BAPrayerTimes : NSObject

@property (strong, nonatomic) NSDate *date;

/* calculated prayer times */
@property (strong, nonatomic, readonly) NSDate *fajrTime;
@property (strong, nonatomic, readonly) NSDate *sunriseTime;
@property (strong, nonatomic, readonly) NSDate *dhuhrTime;
@property (strong, nonatomic, readonly) NSDate *asrTime;
@property (strong, nonatomic, readonly) NSDate *maghribTime;
@property (strong, nonatomic, readonly) NSDate *ishaTime;
@property (strong, nonatomic, readonly) NSDate *tomorrowFajrTime;

- (instancetype)initWithDate:(NSDate *)date
                    latitude:(double)latitude
                   longitude:(double)longitude
                    timeZone:(NSTimeZone *)timeZone
                      method:(BAPrayerMethod)method
                      madhab:(BAPrayerMadhab)madhab;

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
        manualAdjustmentIsha:(NSInteger)manualAdjustmentIsha;

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
             extremeLatitude:(double)extremeLatitude;

- (NSDate *)prayerTimeForType:(BAPrayerType)prayerType;
- (BAPrayerType)currentPrayerTypeForDate:(NSDate *)date;
- (BAPrayerType)nextPrayerTypeForDate:(NSDate *)date;

@end
