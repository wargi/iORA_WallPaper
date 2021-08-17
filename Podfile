# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IoraWallPaper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'CenteredCollectionView'

  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'Firebase/AdMob'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'

  # RxSwift: Main Framework
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # RxSwift: Etc
  pod 'NSObject+Rx'
  pod 'RxSwiftExt'
  pod 'Action'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxReachability'
  pod 'RxKeyboard'
  
  # Networking
  pod 'RxAlamofire'

end

deployment_target = '12.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end
