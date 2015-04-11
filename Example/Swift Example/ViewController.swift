//
//  MasterViewController.swift
//  Swift Example
//
//  Created by Ameir Al-Zoubi on 11/19/14.
//  Copyright (c) 2014 Batoul Apps. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.NoStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return formatter
    }()
    
    var prayerTimes: BAPrayerTimes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prayerTimes = BAPrayerTimes(
            date: NSDate(),
            latitude: 35.779701,
            longitude: -78.641747,
            timeZone: NSTimeZone(name: "US/Eastern"),
            method: .NorthAmerica,
            madhab: .Hanafi)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        if let prayers = prayerTimes {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Fajr"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.fajrTime)
                break
            case 1:
                cell.textLabel?.text = "Sunrise"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.sunriseTime)
                break
            case 2:
                cell.textLabel?.text = "Dhuhr"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.dhuhrTime)
                break
            case 3:
                cell.textLabel?.text = "Asr"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.asrTime)
                break
            case 4:
                cell.textLabel?.text = "Maghrib"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.maghribTime)
                break
            case 5:
                cell.textLabel?.text = "Isha"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.ishaTime)
                break
            case 6:
                cell.textLabel?.text = "Fajr Tomorrow"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(prayers.tomorrowFajrTime)
                break
            default:
                break
            }
        }

        return cell
    }
}

