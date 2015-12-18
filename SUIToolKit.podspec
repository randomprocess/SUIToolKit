
Pod::Spec.new do |s|

  s.name         = 'SUIToolKit'
  s.version      = '4.0.0'
  s.platform     = :ios, '7.0'
  s.summary      = 'A collection of convenient classes for iOS.'

  s.license      = 'MIT'
  s.homepage     = 'https://github.com/randomprocess/SUIToolKit'
  s.author       = { 'suio~' => 'randomprocess@qq.com' }
  s.source       = { :git => 'https://github.com/randomprocess/SUIToolKit.git',
                     :tag => s.version.to_s }

  s.requires_arc = true

  s.public_header_files = 'SUIToolKit/**/*.h'
  s.source_files  = 'SUIToolKit/SUIToolKit.h'


  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'QuartzCore'
  s.dependency 'SUIUtilities', '~> 1.0.0'
  s.dependency 'SUICategories', '~> 1.0.0'

  s.subspec 'MVVM' do |ss|
    ss.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.3'
  end


end
