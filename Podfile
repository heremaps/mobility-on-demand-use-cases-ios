platform :ios, '9.0'

def shared_pods
  pod 'HEREMapsStarter', '>= 3.10'
end

target 'OnDemandPassenger' do
  shared_pods
end

target 'OnDemandPassengerTests' do
  use_frameworks!

  shared_pods
  pod 'Quick', '1.3.4'
  pod 'OCMock', '3.4'
  pod 'Expecta', '1.0.5'
  pod 'OHHTTPStubs', '6.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
