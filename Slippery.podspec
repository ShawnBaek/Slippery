#
# Be sure to run `pod lib lint Slippery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Slippery'
  s.version          = '0.2.0'
  s.summary          = 'Slippery is UICollectionViewFlowlayout to highlight the cell.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Easy to customize your CollectionView styles and user-facing swipe interaction.
                       DESC

  s.homepage         = 'https://github.com/shawnbaek/Slippery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shawnbaek' => 'shawn@shawnbaek.com' }
  s.source           = { :git => 'https://github.com/shawnbaek/Slippery.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/yoshiboarder'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'
#  s.source_files = 'Slippery/Classes/**/*'
  s.source_files = 'Slippery/Classes/SlipperyFlowLayout.swift'
  
  # s.resource_bundles = {
  #   'Slippery' => ['Slippery/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
