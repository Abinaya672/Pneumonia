// GeneratedPluginRegistrant.swift

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.serial_port", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "sendData") {
                if let data = call.arguments as? Dictionary<String, String>, let message = data["data"] {
                    self.sendDataToArduino(message: message)
                    result(nil)
                }
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func sendDataToArduino(message: String) {
        let file = fopen("/dev/ttyUSB0", "w") // Change port name as needed
        if (file != nil) {
            fputs(message, file)
            fclose(file)
        }
    }
}
