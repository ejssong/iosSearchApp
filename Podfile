# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iosSearchApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iosSearchApp
  # UI
  pod 'SnapKit', '~> 5.6.0'
  pod 'Then', '3.0.0'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "RxGesture"
  pod 'RxDataSources'
  pod 'RxKeyboard'
  
  # ReactorKit
  pod 'ReactorKit'
  
  #Network
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Moya'
  
  #Image
  pod 'SDWebImage'
end

post_install do |installer|
  installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
              end
          end
  end

    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
end
