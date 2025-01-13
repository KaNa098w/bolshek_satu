import Firebase
import UIKit
import Flutter
import FirebaseCore
import YandexMapsMobile


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    YMKMapKit.setApiKey("721e8e1b-9628-4803-9dba-4479c4369909")
    FirebaseApp.configure() 
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
