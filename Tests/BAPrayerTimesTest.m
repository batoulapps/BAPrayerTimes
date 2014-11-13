//
//  BAPrayerTimesTest.m
//  BAPrayerTimes
//
//  Created by Ameir Al-Zoubi on 11/12/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BAPrayerTimes.h"

@interface BAPrayerTimesTest : XCTestCase

@end

@implementation BAPrayerTimesTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializers
{
    BAPrayerTimes *prayerTimes1 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]
                                                               method:BAPrayerMethodNorthAmerica
                                                               madhab:BAPrayerMadhabHanafi];
    
    XCTAssertNotNil(prayerTimes1, @"prayerTimes1 shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.fajrTime, @"prayerTimes1.fajrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.sunriseTime, @"prayerTimes1.sunriseTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.dhuhrTime, @"prayerTimes1.dhuhrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.asrTime, @"prayerTimes1.asrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.maghribTime, @"prayerTimes1.maghribTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.ishaTime, @"prayerTimes1.ishaTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes1.tomorrowFajrTime, @"prayerTimes1.tomorrowFajrTime shouldn't be nil");
    
    BAPrayerTimes *prayerTimes2 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodMWL
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:0
                                                      customIshaAngle:0
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0];
    
    XCTAssertNotNil(prayerTimes2, @"prayerTimes2 shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.fajrTime, @"prayerTimes2.fajrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.sunriseTime, @"prayerTimes2.sunriseTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.dhuhrTime, @"prayerTimes2.dhuhrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.asrTime, @"prayerTimes2.asrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.maghribTime, @"prayerTimes2.maghribTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.ishaTime, @"prayerTimes2.ishaTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes2.tomorrowFajrTime, @"prayerTimes2.tomorrowFajrTime shouldn't be nil");
    
    BAPrayerTimes *prayerTimes3 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]
                                                               method:BAPrayerMethodMCW
                                                               madhab:BAPrayerMadhabHanafi
                                                      customFajrAngle:0
                                                      customIshaAngle:0
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0
                                                        extremeMethod:0];
    
    XCTAssertNotNil(prayerTimes3, @"prayerTimes3 shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.fajrTime, @"prayerTimes3.fajrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.sunriseTime, @"prayerTimes3.sunriseTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.dhuhrTime, @"prayerTimes3.dhuhrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.asrTime, @"prayerTimes3.asrTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.maghribTime, @"prayerTimes3.maghribTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.ishaTime, @"prayerTimes3.ishaTime shouldn't be nil");
    XCTAssertNotNil(prayerTimes3.tomorrowFajrTime, @"prayerTimes3.tomorrowFajrTime shouldn't be nil");
}

- (void)testManualAdjustment
{
    NSInteger fajrAdjustment = 120;
    NSInteger sunriseAdjustment = 60;
    NSInteger dhuhrAdjustment = 5;
    NSInteger asrAdjustment = 0;
    NSInteger maghribAdjustment = -10;
    NSInteger ishaAdjustment = -60;
    
    BAPrayerTimes *prayerTimes1 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodMWL
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:0
                                                      customIshaAngle:0
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0];
    
    BAPrayerTimes *prayerTimes2 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodMWL
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:0
                                                      customIshaAngle:0
                                                 manualAdjustmentFajr:fajrAdjustment
                                              manualAdjustmentSunrise:sunriseAdjustment
                                                manualAdjustmentDhuhr:dhuhrAdjustment
                                                  manualAdjustmentAsr:asrAdjustment
                                              manualAdjustmentMaghrib:maghribAdjustment
                                                 manualAdjustmentIsha:ishaAdjustment];
    
    NSTimeInterval fajrDifference = [prayerTimes2.fajrTime timeIntervalSinceDate:prayerTimes1.fajrTime];
    NSTimeInterval sunriseDifference = [prayerTimes2.sunriseTime timeIntervalSinceDate:prayerTimes1.sunriseTime];
    NSTimeInterval dhuhrDifference = [prayerTimes2.dhuhrTime timeIntervalSinceDate:prayerTimes1.dhuhrTime];
    NSTimeInterval asrDifference = [prayerTimes2.asrTime timeIntervalSinceDate:prayerTimes1.asrTime];
    NSTimeInterval maghribDifference = [prayerTimes2.maghribTime timeIntervalSinceDate:prayerTimes1.maghribTime];
    NSTimeInterval ishaDifference = [prayerTimes2.ishaTime timeIntervalSinceDate:prayerTimes1.ishaTime];
    
    XCTAssertEqual(fajrDifference, (NSTimeInterval) fajrAdjustment * 60.0, @"fajr adjustment should equal fajr difference");
    XCTAssertEqual(sunriseDifference, (NSTimeInterval) sunriseAdjustment * 60.0, @"sunrise adjustment should equal sunrise difference");
    XCTAssertEqual(dhuhrDifference, (NSTimeInterval) dhuhrAdjustment * 60.0, @"dhuhr adjustment should equal dhuhr difference");
    XCTAssertEqual(asrDifference, (NSTimeInterval) asrAdjustment * 60.0, @"asr adjustment should equal asr difference");
    XCTAssertEqual(maghribDifference, (NSTimeInterval) maghribAdjustment * 60.0, @"maghrib adjustment should equal maghrib difference");
    XCTAssertEqual(ishaDifference, (NSTimeInterval) ishaAdjustment * 60.0, @"isha adjustment should equal isha difference");
}

- (void)testCustomAngles
{
    BAPrayerTimes *prayerTimes1 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodNorthAmerica
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:0
                                                      customIshaAngle:0
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0];

    BAPrayerTimes *prayerTimes2 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodNone
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:15
                                                      customIshaAngle:10
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0];

    BAPrayerTimes *prayerTimes3 = [[BAPrayerTimes alloc] initWithDate:[NSDate date]
                                                             latitude:35.779701
                                                            longitude:-78.641747
                                                             timeZone:[NSTimeZone localTimeZone]
                                                               method:BAPrayerMethodNone
                                                               madhab:BAPrayerMadhabShafi
                                                      customFajrAngle:10
                                                      customIshaAngle:15
                                                 manualAdjustmentFajr:0
                                              manualAdjustmentSunrise:0
                                                manualAdjustmentDhuhr:0
                                                  manualAdjustmentAsr:0
                                              manualAdjustmentMaghrib:0
                                                 manualAdjustmentIsha:0];

    XCTAssertEqualObjects(prayerTimes1.fajrTime, prayerTimes2.fajrTime, @"ISNA fajr and custom angle 15 fajr should be the same");
    XCTAssertNotEqualObjects(prayerTimes1.ishaTime, prayerTimes2.ishaTime, @"ISNA isha and custom angle 10 isha should not be the same");

    XCTAssertNotEqualObjects(prayerTimes1.fajrTime, prayerTimes3.fajrTime, @"ISNA fajr and custom angle 10 fajr should not be the same");
    XCTAssertEqualObjects(prayerTimes1.ishaTime, prayerTimes3.ishaTime, @"ISNA isha and custom angle 15 isha should be the same");
}


@end
