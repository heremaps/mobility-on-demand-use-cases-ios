platform :ios, '9.0'

target 'OnDemandPassengerTests' do
  use_frameworks!

  pod 'Quick', '1.1.0'
  pod 'OCMock', '3.4'
  pod 'Expecta', '1.0.5'
  pod 'OHHTTPStubs', '6.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
