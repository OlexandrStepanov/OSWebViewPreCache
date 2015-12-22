#
# Be sure to run `pod lib lint OSWebViewPreCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OSWebViewPreCache"
  s.version          = "1.0"
  s.summary          = "Offline cache ready-to-go solution for web sites like 'Terms and Conditions' and 'Privacy policy'"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "99% of business projects require to have 'Terms and Conditions' and 'Privacy policy' pages. Moreover, in most cases it is legal obligation to have these pages accessible even when device is offline, without internet connection. OSWebViewPreCache is easy-to-go solution for offline caching of web pages."

  s.homepage         = "https://github.com/OlexandrStepanov/OSWebViewPreCache"
  s.license          = 'Apache 2.0'
  s.author           = { "Olexandr Stepanov" => "yltastep@gmail.com" }
  s.source           = { :git => "https://github.com/OlexandrStepanov/OSWebViewPreCache.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'OSWebViewPreCache' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Reachability'
end
