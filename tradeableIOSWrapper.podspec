Pod::Spec.new do |s|
  s.name             = 'tradeableIOSWrapper'
  s.version          = '1.0.0'
  s.summary          = 'iOS Framework to embed Flutter trading widgets'
  s.description      = <<-DESC
  A native iOS framework that wraps the Tradeable Flutter SDK, allowing easy integration
  of Flutter-based trading widgets into native iOS apps with SwiftUI support.
                       DESC
  s.homepage         = 'https://github.com/deepakgrandhi/tradeableIOSWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Deepak Grandhi' => 'your.email@example.com' }
  s.source           = { :git => 'https://github.com/deepakgrandhi/tradeableIOSWrapper.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  
  s.source_files = 'tradeableIOSWrapper/**/*.{h,m,swift}'
  s.public_header_files = 'tradeableIOSWrapper/**/*.h'
  
  # Flutter module dependency
  flutter_module_path = 'flutter_module'
  
  s.prepare_command = <<-CMD
    if [ ! -d "#{flutter_module_path}" ]; then
      git clone https://github.com/deepakgrandhi/tradeable_flutter_sdk_module.git #{flutter_module_path}
    fi
    cd #{flutter_module_path} && git pull origin main && flutter pub get
  CMD
  
  # Load Flutter pods
  s.script_phases = [
    {
      :name => 'Setup Flutter',
      :script => 'cd flutter_module && flutter pub get',
      :execution_position => :before_compile
    }
  ]
  
  # Flutter dependencies
  s.dependency 'Flutter'
  s.dependency 'FlutterPluginRegistrant'
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
