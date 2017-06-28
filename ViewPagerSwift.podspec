#
# Be sure to run `pod lib lint ViewPagerSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ViewPagerSwift'
  s.version          = '1.0.3'
  s.summary          = 'ViewPager UI Element like Android ViewPager in swift version.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ViewPager Can manager several ViewController in on UI element,
one ViewController one page.
                       DESC

  s.homepage         = 'https://github.com/zzycami/ViewPager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zzycami@foxmail.com' => 'zzycami@foxmail.com' }
  s.source           = { :git => 'https://github.com/zzycami/ViewPager.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ViewPagerSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ViewPagerSwift' => ['ViewPagerSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
