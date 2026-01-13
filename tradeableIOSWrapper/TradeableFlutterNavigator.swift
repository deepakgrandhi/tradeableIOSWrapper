//
//  TradeableFlutterNavigator.swift
//  tradeableIOSWrapper
//
//  Created by Deepak Grandhi on 12/01/26.
//

import Foundation
import Flutter

/// Public API for managing Flutter navigation and authentication
public class TradeableFlutterNavigator {
    public static let shared = TradeableFlutterNavigator()
    
    private lazy var methodChannel = FlutterMethodChannel(
        name: "embedded_flutter/navigation",
        binaryMessenger: FlutterEngineHolder.shared.engine.binaryMessenger
    )
    
    private lazy var authChannel = FlutterMethodChannel(
        name: "embedded_flutter/auth",
        binaryMessenger: FlutterEngineHolder.shared.engine.binaryMessenger
    )
    
    private init() {}
    
    // MARK: - Authentication
    
    /// Initialize TFS with authentication credentials
    /// - Parameters:
    ///   - baseUrl: API base URL
    ///   - authToken: User authentication token
    ///   - portalToken: Portal token
    ///   - appId: Application ID
    ///   - clientId: Client ID
    ///   - publicKey: Public key for encryption
    ///   - completion: Callback when initialization is complete
    public func initializeTFS(
        baseUrl: String,
        authToken: String,
        portalToken: String,
        appId: String,
        clientId: String,
        publicKey: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let params: [String: Any] = [
            "baseUrl": baseUrl,
            "authToken": authToken,
            "portalToken": portalToken,
            "appId": appId,
            "clientId": clientId,
            "publicKey": publicKey
        ]
        
        authChannel.invokeMethod("initializeTFS", arguments: params) { result in
            if let error = result as? FlutterError {
                completion(false, error.message)
            } else if let success = result as? Bool {
                completion(success, nil)
            } else {
                completion(true, nil)
            }
        }
    }
    
    /// Check if user is authenticated
    public func isAuthenticated(completion: @escaping (Bool) -> Void) {
        authChannel.invokeMethod("isAuthenticated", arguments: nil) { result in
            completion(result as? Bool ?? false)
        }
    }
    
    /// Logout user
    public func logout() {
        authChannel.invokeMethod("logout", arguments: nil)
    }
    
    // MARK: - Navigation
    
    /// Navigate to a specific route in Flutter
    /// - Parameters:
    ///   - route: The route name to navigate to
    ///   - arguments: Optional data to pass to the route
    public func navigateTo(_ route: String, arguments: [String: Any]? = nil) {
        let params: [String: Any] = [
            "route": route,
            "arguments": arguments ?? [:]
        ]
        methodChannel.invokeMethod("navigateTo", arguments: params)
    }
    
    /// Go back to the previous route
    public func goBack() {
        methodChannel.invokeMethod("goBack", arguments: nil)
    }
    
    /// Replace current route with a new one
    /// - Parameters:
    ///   - route: The route name to navigate to
    ///   - arguments: Optional data to pass to the route
    public func replace(_ route: String, arguments: [String: Any]? = nil) {
        let params: [String: Any] = [
            "route": route,
            "arguments": arguments ?? [:]
        ]
        methodChannel.invokeMethod("replaceRoute", arguments: params)
    }
    
    /// Clear all routes and navigate to a new one
    /// - Parameters:
    ///   - route: The route name to navigate to
    ///   - arguments: Optional data to pass to the route
    public func popToRoot(_ route: String = "/", arguments: [String: Any]? = nil) {
        let params: [String: Any] = [
            "route": route,
            "arguments": arguments ?? [:]
        ]
        methodChannel.invokeMethod("popToRoot", arguments: params)
    }
    
    /// Send data to the current Flutter view
    /// - Parameters:
    ///   - data: Dictionary of data to send
    public func sendData(_ data: [String: Any]) {
        methodChannel.invokeMethod("receiveData", arguments: data)
    }
    
    /// Register a handler for receiving data from Flutter
    /// - Parameter handler: Closure called when Flutter sends data
    public func registerDataHandler(_ handler: @escaping ([String: Any]) -> Void) {
        methodChannel.setMethodCallHandler { call, result in
            if call.method == "sendData" {
                if let arguments = call.arguments as? [String: Any] {
                    handler(arguments)
                }
            }
            result(nil)
        }
    }
}
