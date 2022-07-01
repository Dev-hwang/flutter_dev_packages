//
//  MethodCallHandlerImpl.swift
//  flutter_dev_packages
//
//  Created by WOO JIN HWANG on 2022/06/16.
//

import CoreLocation
import Flutter
import Foundation

class MethodCallHandlerImpl: NSObject {
  private let permissionMethodChannel: FlutterMethodChannel
  private let systemMethodChannel: FlutterMethodChannel
  
  init(messenger: FlutterBinaryMessenger) {
    self.permissionMethodChannel = FlutterMethodChannel(name: "flutter_dev_packages/permission", binaryMessenger: messenger)
    self.systemMethodChannel = FlutterMethodChannel(name: "flutter_dev_packages/system", binaryMessenger: messenger)
    super.init()
    self.permissionMethodChannel.setMethodCallHandler(onMethodCall)
    self.systemMethodChannel.setMethodCallHandler(onMethodCall)
  }
  
  func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "isLocationServiceEnabled":
        result(CLLocationManager.locationServicesEnabled())
      case "openLocationServiceSettings":
        if #available(iOS 10.0, *) {
          if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:]) { success in result(success) }
            return
          }
        }
        result(false)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
