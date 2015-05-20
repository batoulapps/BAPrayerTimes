#BAPrayerTimes

[![Build Status](https://travis-ci.org/batoulapps/BAPrayerTimes.svg?branch=master)](https://travis-ci.org/batoulapps/BAPrayerTimes)
[![Coverage Status](https://coveralls.io/repos/batoulapps/BAPrayerTimes/badge.svg?branch=master)](https://coveralls.io/r/batoulapps/BAPrayerTimes?branch=master)

BAPrayerTimes is an Objective-C library for calculating Islamic prayer times. It provides a convenient Objective-C interface to the ITL prayer times library, making it easy to correctly calculate prayer times on iOS and OS X.

##ITL
[The Islamic Tools and Libraries (ITL)](https://github.com/arabeyes-org/ITL) is a widely used library for useful Islamic tools written in C. It is an open source project maintained by the arabeyes organization. Being written in C allows it to natively run on iOS and OS X. It is used in many popular Linux utilities and is the source of prayer time calculations for this library.

##Installation
The simplest way to use BAPrayerTimes is with CocoaPods.

```
pod 'BAPrayerTimes', '~> 1.4'
```
	
You can also simply download the source and include it in your project. The necessary files are BAPrayerTimes.h, BAPrayerTimes.c, prayer.h, prayer.c, astro.h, and astro.c
	
##Requirements
BAPrayerTimes is officially supported on iOS 6 and above as well as OS X 10.8 and above. It will most likely work on systems much earlier than those, however no testing has been done to verify this.

##Usage
First import ``BAPrayerTimes.h`` and then initialize a ``BAPrayerTimes`` object. There are a few different initializers you can use to create a BAPrayerTimes object depending on how much customization you want to add. The most basic initializer is:

```obj-c
BAPrayerTimes *prayerTimes = [[BAPrayerTimes alloc] initWithDate:date
                                                        latitude:35.779701
                                                       longitude:-78.641747
                                                        timeZone:timezone
                                                          method:BAPrayerMethodMWL
                                                          madhab:BAPrayerMadhabShafi];
```
                                                    
Here you provide the date the prayer times are for, the user's latitude, longitude and timezone as well the calculation method for Fajr and Isha and the madhab to use for Asr. There are additional initializers where you can also include angles for a custom calculation method and manual adjustments for each prayer.

After the object has been initialized you can get any of the prayer times by accessing the property for a specific prayer.

```obj-c
prayerTimes.fajrTime
```
	
You can access the times for Fajr, Sunrise Dhuhr, Asr, Maghrib, Isha and tomorrow's Fajr. To get prayer times for a different date, simply update the date property.

```obj-c
prayerTimes.date = newDate;
```

We have provided a sample app in the [example](Example/) directory showing a basic iOS implementation of BAPrayerTimes.

##Calculation Methods
BAPrayerTimes provides an enum with all the options that the ITL library has. However, it does not automatically set a calculation method for a specific location as there does not appear to be a definitive resource for this yet. Below are a list of suggested locations to use a particular calculation method. This list is by no means definitive and we hope to receive pull requests for any adjustments to the list.

**Umm Al-Qura** (``BAPrayerMethodUmmQurra``)

Saudi Arabia


**Gulf** (``BAPrayerMethodFixedIsha``)

United Arab Emirates, Kuwait, Bahrain, Oman, Yemen, Qatar


**Moonsighting Committee Worldwide** (``BAPrayerMethodMCW``)

US, Canada, UK


**Egyptian General Authority of Survey** (``BAPrayerMethodNewEgyptianAuthority``)

Egypt, Sudan, Libya, Algeria, Morocco, Lebanon, Jordan, Syria, Palestine, Iraq, Turkey, Malaysia


**University of Islamic Sciences, Karachi** (``BAPrayerMethodKarachiHanafi``)

Pakistan, India, Bangladesh, Afghanistan


**Muslim World League** (``BAPrayerMethodMWL``)

Germany, Spain, France, Singapore, Indonesia, Philippines


**North America** (``BAPrayerMethodNorthAmerica``)

Not Recommended


## Contributing
It is our sincere hope that developers adopt this library and contribute back to it, providing a high level of standard for prayer time calculations to all developers. If you wish to contribute to the Objective-C interface, please create a pull request for this repo. If you would like to contribute to the C-based library that calculates the times, please open a pull request for the [ITL repo](https://github.com/arabeyes-org/ITL). One thing we hope to add soon are unit tests to provide ease of mind that the calculated times are correct and that changes to the code have not had any adverse effects.

## License

BAPrayerTimes is available under the MIT license. See the LICENSE file for more info.
