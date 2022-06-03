platform :ios, '13.0'

target 'TonScan' do
  use_frameworks! :linkage => :static
  inhibit_all_warnings!
  
  # Common
  pod 'Moya', '~> 15.0'
  
  # Interface
  pod 'IGListKit', '~> 4.0'
  pod 'SnapKit', '~> 5.0.1'
  pod 'PinLayout', '~> 1.10.2'
  pod 'Kingfisher', '~> 6.3.1'
  pod 'Atributika', '~> 4.10.1'
  pod 'PanModal', :git => 'git@github.com:getblaster/PanModal.git'
  pod 'SwipeCellKit', '~> 2.7.1'
  
  # Analytics
  pod 'Firebase/Crashlytics', '~> 8.14.0'
  pod 'Firebase/Analytics', '~> 8.14.0'
  pod 'Firebase/Performance', '~> 8.14.0'
  pod 'Amplitude', '~> 8.10.0'
  
  # Utilities
  pod 'SwiftyBeaver', '~> 1.9.5'
  pod 'R.swift', '~> 6.1.0'
  
  # Debug
  pod 'Reveal-SDK', :configurations => ['Debug']
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end
