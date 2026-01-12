# Tradeable iOS Wrapper

Native iOS framework for embedding Flutter trading widgets in your iOS app.

## Installation

Add to your `Podfile`:

```ruby
platform :ios, '13.0'

# Setup Flutter first
flutter_module_path = 'flutter_module'

unless File.exist?(flutter_module_path)
  system("git clone https://github.com/deepakgrandhi/tradeable_flutter_sdk_module.git #{flutter_module_path}")
end

system("cd #{flutter_module_path} && git pull origin main && flutter pub get")

flutter_podhelper = File.join(flutter_module_path, '.ios', 'Flutter', 'podhelper.rb')
if File.exist?(flutter_podhelper)
  load flutter_podhelper
end

target 'YourApp' do
  use_frameworks!
  
  # Install Flutter pods BEFORE other pods
  install_all_flutter_pods(flutter_module_path)
  
  # Then add tradeableIOSWrapper
  pod 'tradeableIOSWrapper', :git => 'https://github.com/deepakgrandhi/tradeableIOSWrapper.git'
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
```

Then run:
```bash
pod install
```

## Usage

### Import the Framework
```swift
import tradeableIOSWrapper
```

### 1. Direct Display Mode
```swift
TradeableFlutterView(
    mode: .direct,
    width: 320,
    height: 220,
    data: ["text": "Trading Widget"]
)
```

### 2. Card Flip Mode
```swift
TradeableFlutterView(
    mode: .cardFlip,
    width: 320,
    height: 220,
    data: ["text": "Tap to Flip"]
)
```

### 3. Fullscreen Mode
```swift
TradeableFlutterView(
    mode: .fullscreen,
    data: ["text": "Open Fullscreen"]
)
```

### Navigation & Data Passing
```swift
// Send data to Flutter
TradeableFlutterNavigator.shared.sendData(["key": "value"])

// Navigate to a route
TradeableFlutterNavigator.shared.navigateTo("route_name", arguments: ["arg": "value"])

// Go back
TradeableFlutterNavigator.shared.goBack()
```

## Requirements

- iOS 13.0+
- Xcode 14.0+
- Swift 5.0+
- Flutter SDK installed

## Quick Test

To test this framework immediately, provide consumers:
1. **Repository URL**: `https://github.com/deepakgrandhi/tradeableIOSWrapper.git`
2. **Sample Podfile** (see Installation section above)
3. **Sample Code** (see Usage section above)

Consumers can create a new iOS app and add the framework using the Podfile configuration.