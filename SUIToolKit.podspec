
Pod::Spec.new do |s|

  s.name         = 'SUIToolKit'
  s.version      = '0.2'
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


  s.subspec 'Tool' do |ss|
    ss.source_files = 'SUIToolKit/Tool/*.{h,m}'
  end


  s.subspec 'Base' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Category'
    ss.source_files = 'SUIToolKit/Base/*.{h,m}'
  end


  s.subspec 'Category' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Base'
    ss.source_files = 'SUIToolKit/Category/*.{h,m}'
  end


  s.subspec 'View' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Base'
    ss.dependency 'SUIToolKit/Category'
    ss.source_files = 'SUIToolKit/View/*.{h,m}'
  end


  s.frameworks = 'UIKit', 'Foundation', 'CoreData', 'QuartzCore'
  s.dependency 'AFNetworking', '~> 2.5.4'
  s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.3'
  s.dependency 'MJRefresh', '~> 1.4.7'
  s.dependency 'MJExtension', '~> 2.3.7'
  s.dependency 'MagicalRecord', '~> 2.3.0'
  s.dependency 'MGSwipeTableCell', '~> 1.5.1'
  s.dependency 'DZNEmptyDataSet', '~> 1.7'

end
