Pod::Spec.new do |s|
  s.name         = 'BAPrayerTimes'
  s.version      = '1.0.1'
  s.summary      = 'An Objective-C library for calculating Islamic prayer times'

  s.description  = <<-DESC
                   BAPrayerTimes is an Objective-C interface
                   for the C based ITL prayer times library.
                   BAPrayerTimes can be used for iOS
                   or OS X apps.
                   DESC

  s.homepage     = 'https://github.com/batoulapps/BAPrayerTimes'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Batoul Apps' => 'support@batoulapps.com' }

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source       = { :git => 'https://github.com/batoulapps/BAPrayerTimes.git', :tag => '1.0.1', :submodules => true }

  s.source_files = 'BAPrayerTimes/BAPrayerTimes.{h,m}',
                   'ITL/prayertime/prayer.{h,c}',
                   'ITL/prayertime/astro.{h,c}'

end
