
Pod::Spec.new do |s|

  s.name         = 'SUIToolKit'
  s.version      = '0.3.3'
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
    ss.dependency 'AFNetworking', '~> 2.5.4'
    ss.dependency 'Reachability', '~> 3.2'
    ss.source_files = 'SUIToolKit/Tool/*.{h,m}'
  end

  s.subspec 'Category' do |ss|
    ss.dependency 'ReactiveCocoa', '~> 2.5'
    ss.dependency 'SUIToolKit/Tool'
    ss.source_files = 'SUIToolKit/Category/*.{h,m}'
  end

  s.subspec 'Exten' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Category'
    ss.dependency 'SDWebImage', '~> 3.7.3'
    ss.dependency 'DZNEmptyDataSet', '~> 1.7'
    ss.source_files = 'SUIToolKit/Exten/*.{h,m}'
  end

  s.subspec 'Base' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Category'
    ss.dependency 'SUIToolKit/Exten'
    ss.dependency 'ReactiveCocoa', '~> 2.5'
    ss.dependency 'MGSwipeTableCell', '~> 1.5.1'
    ss.dependency 'MJRefresh', '~> 1.4.7'
    ss.dependency 'MJExtension', '~> 2.3.7'
    ss.dependency 'MagicalRecord', '~> 2.3.0'
    ss.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.3'
    ss.source_files = 'SUIToolKit/Base/*.{h,m}'
  end

  s.subspec 'View' do |ss|
    ss.dependency 'SUIToolKit/Tool'
    ss.dependency 'SUIToolKit/Base'
    ss.dependency 'SUIToolKit/Category'
    ss.source_files = 'SUIToolKit/View/*.{h,m}'
  end

  s.frameworks = 'UIKit', 'Foundation', 'CoreData', 'QuartzCore', 'MobileCoreServices'

end
