import Flutter
import UIKit

public class SwiftFlutterDevPackagesPlugin: NSObject, FlutterPlugin {
  private var methodCallHandler: MethodCallHandlerImpl? = nil
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterDevPackagesPlugin()
    instance.initServices()
    instance.initChannels(registrar.messenger())
  }
  
  private func initServices() {
    
  }
  
  private func initChannels(_ messenger: FlutterBinaryMessenger) {
    methodCallHandler = MethodCallHandlerImpl(messenger: messenger)
  }
}
