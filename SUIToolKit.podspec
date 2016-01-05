
Pod::Spec.new do |s|

  s.name         = 'SUIToolKit'
  s.version      = '1.0.3'
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
  s.dependency 'ReactiveCocoa', '~> 2.5'
  s.dependency 'SUIUtilities', '~> 1.0.0'
  s.dependency 'SUICategories', '~> 1.1.0'

  s.subspec 'DBHelper' do |ss|
    ss.dependency 'ReactiveCocoa', '~> 2.5'
    ss.dependency 'LKDBHelper', '~> 2.1.7'
    ss.source_files = 'SUIToolKit/DBHelper/*.{h,m}'
  end

  s.subspec 'MVVM' do |ss|
    ss.dependency 'SUIToolKit/DBHelper'
    ss.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.3'
    ss.source_files = 'SUIToolKit/MVVM/*.{h,m}'
  end

  s.subspec 'Toolbar' do |ss|
    ss.source_files = 'SUIToolKit/Toolbar/*.{h,m}'
  end

end
