//
//  BAViewController.m
//  Prayer Times Example
//
//  Created by Ameir Al-Zoubi on 8/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

#import "BAViewController.h"
#import "BAPrayerTimes.h"

@interface BAViewController ()

@property (strong, nonatomic) NSDictionary *calculatedPrayerTimes;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation BAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    BAPrayerTimes *prayerTimes = [[BAPrayerTimes alloc] initWithLatitude:35.779701
															   longitude:-78.641747
																timeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]
																  method:BAPrayerMethodMWL
																  madhab:BAPrayerMadhabShafi];
    self.calculatedPrayerTimes = [prayerTimes getPrayerTimes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Fajr";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesFajr]];
            break;
        case 1:
            cell.textLabel.text = @"Sunrise";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesShuruq]];
            break;
        case 2:
            cell.textLabel.text = @"Dhuhr";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesDhuhr]];
            break;
        case 3:
            cell.textLabel.text = @"Asr";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesAsr]];
            break;
        case 4:
            cell.textLabel.text = @"Maghrib";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesMaghrib]];
            break;
        case 5:
            cell.textLabel.text = @"Isha";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.calculatedPrayerTimes[kBAPrayerTimesIsha]];
            break;
    }
    
    return cell;
}

@end
