
Pod::Spec.new do |s|

  s.name         = 'SUIToolKit'
  s.version      = '1.0'
  s.platform     = :ios, '7.0'
  s.summary      = 'A collection of convenient classes for iOS.'

  s.license      = 'MIT'
  s.homepage     = 'https://github.com/randomprocess/SUIToolKit'
  s.author       = { 'suio~' => 'randomprocess@qq.com' }
  s.source       = { :git => 'https://github.com/randomprocess/SUIToolKit.git',
                     :tag => s.version.to_s }

  s.requires_arc = true

  s.source_files  = 'SUIToolKit/SUIToolKit.h'

  s.subspec 'Category' do |ss|
    ss.source_files = 'SUIToolKit/Category/*.{h,m}'
    ss.frameworks = 'UIKit', 'Foundation', 'CoreData'
    ss.dependency 'UITableView+FDTemplateLayoutCell ', '~> 1.3'
  end




end
