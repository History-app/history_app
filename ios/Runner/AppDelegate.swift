import Flutter
import UIKit
import FirebaseCore
import FirebaseAuth
import AppsFlyerLib

@main
@objc class AppDelegate: FlutterAppDelegate, AppsFlyerLibDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ============================
    // Firebase 初期化
    // ============================
    firebaseConfigure()

    // Flutter plugin 登録
    GeneratedPluginRegistrant.register(with: self)

    // ============================
    // AppsFlyer 初期化
    // ============================
    AppsFlyerLib.shared().appsFlyerDevKey = "LqSi9Qa3E3ae62PUpJkkYL"
    AppsFlyerLib.shared().appleAppID = "6744389554"
    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().isDebug = true
    AppsFlyerLib.shared().start()

    return true
  }

  // ==================================================
  // Universal Links（https://）
  // Firebase メールリンク + AppsFlyer
  // ==================================================
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {

    // Firebase Auth（メールリンク）
    if let url = userActivity.webpageURL {
      _ = Auth.auth().canHandle(url)
    }

    // AppsFlyer（DeepLink 用）
    AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)

    // ❌ Flutter routing には渡さない
    return true
  }

  // ==================================================
  // URI Scheme（myapp://）
  // ==================================================
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    // Firebase Auth
    _ = Auth.auth().canHandle(url)

    // AppsFlyer
    AppsFlyerLib.shared().handleOpen(url, options: options)

    // ❌ Flutter routing には渡さない
    return true
  }

  // ==================================================
  // AppsFlyer Delegate（デバッグ）
  // ==================================================
  func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
    print("📲 AppsFlyer attribution:", attributionData)
  }

  func onAppOpenAttributionFailure(_ error: Error) {
    print("❌ AppsFlyer attribution error:", error)
  }

  func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
    print("📈 AppsFlyer conversion data:", conversionInfo)
  }

  func onConversionDataFail(_ error: Error) {
    print("❌ AppsFlyer conversion error:", error)
  }

  // ==================================================
  // Firebase 初期化（Dev / Prod）
  // ==================================================
  private func firebaseConfigure() {
    #if DEBUG
      let filePath = Bundle.main.path(
        forResource: "GoogleService-Info-Dev",
        ofType: "plist"
      )
    #else
      let filePath = Bundle.main.path(
        forResource: "GoogleService-Info",
        ofType: "plist"
      )
    #endif

    guard
      let filePath = filePath,
      let options = FirebaseOptions(contentsOfFile: filePath)
    else {
      fatalError("❌ FirebaseOptions の読み込みに失敗")
    }

    FirebaseApp.configure(options: options)
    print("✅ Firebase configured: \(options.bundleID ?? "unknown")")
  }
}
