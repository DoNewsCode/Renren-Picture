#
# Be sure to run `pod lib lint Renren-Picture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Renren-Picture'
  s.version          = '1.0.0.46'
  s.summary          = 'A short description of Renren-Picture.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://glab.tagtic.cn/developer_ios/Renren-Picture'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '418589912@qq.com' => 'chenjinming@donews.com' }
  s.source           = { :git => 'https://glab.tagtic.cn/developer_ios/Renren-Picture.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }

  s.source_files = 'Renren-Picture/Classes/**/*'
    
  # s.resource_bundles = {
  #   'Renren-Picture' => ['Renren-Picture/Assets/*.png']
  # }
  s.resource_bundles = {
    'Renren-Picture-UI' => ['Renren-Picture/Assets/Renren-Picture-UI.xcassets']
  }

  s.dependency 'Renren-EditImage'
  s.dependency 'RenRen-ImagePicker'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#   s.dependency 'Renren-Network'
   s.dependency 'Renren-BaseKit'
   s.dependency 'SDWebImageFLPlugin'
#   s.dependency 'SDWebImageWebPCoder'
   
   
end
