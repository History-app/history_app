import Flutter
import UIKit
import FirebaseCore 
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    firebaseConfigure()
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func firebaseConfigure() {
    #if DEBUG
      print("🧪 DEBUG モード：Dev用の Firebase 設定を読み込み")
      let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
    #else
      print("🚀 RELEASE モード：Prod用の Firebase 設定を読み込み")
      let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
    #endif

    guard let filePath = filePath,
          let options = FirebaseOptions(contentsOfFile: filePath) else {
      print("❌ FirebaseOptions の読み込みに失敗しました")
      return
    }

    FirebaseApp.configure(options: options)
}
