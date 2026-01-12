import Flutter

/// Internal engine manager - not exposed to consumers
class FlutterEngineHolder {
  static let shared = FlutterEngineHolder()
  let engine: FlutterEngine
  private(set) var controller: FlutterViewController?
  private var isEngineRunning = false

  private init() {
    engine = FlutterEngine(name: "main_engine")
    engine.run()
    isEngineRunning = true
  }

  func makeController() -> FlutterViewController {
    if let existing = controller {
      engine.viewController = nil
      controller = nil
    }

    let vc = FlutterViewController(
      engine: engine,
      nibName: nil,
      bundle: nil
    )

    controller = vc
    return vc
  }

  func detachController() {
    engine.viewController = nil
    controller = nil
  }
  
  /// Restart the Flutter engine
  func restartEngine() {
    if isEngineRunning {
      engine.viewController = nil
      controller = nil
    }
  }
  
  deinit {
    if isEngineRunning {
      engine.viewController = nil
      controller = nil
    }
  }
}
