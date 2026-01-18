import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:japanese_history_app/configs/secrets_manager.dart';
import 'package:japanese_history_app/repositories/user_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

final afService = AfService();

class AfService {
  static final AfService _instance = AfService._internal();
  factory AfService() => _instance;
  AfService._internal() {
    initFuture = _init();
  }

  late final Future<void> initFuture;
  late final AppsflyerSdk appsflyerSdk;

  final _deepLinkController = StreamController<DeepLinkData>.broadcast(sync: true);
  Stream<DeepLinkData> get deepLinkStream => _deepLinkController.stream;

  Future<void> _init() async {
    try {
      final info = await PackageInfo.fromPlatform();

      final afOptions = AppsFlyerOptions(
        afDevKey: SecretsManager.getAfDevKey(),
        appId: SecretsManager.getAppId(info.packageName),
        showDebug: false,
        manualStart: false,
      );
      print('AF appId = ${SecretsManager.getAppId(info.packageName)}');
      print('AF devKey = ${SecretsManager.getAfDevKey()}');
      print('AF packageName = ${info.packageName}');

      appsflyerSdk = AppsflyerSdk(afOptions);

      // ★ await は不要（void を返す）。必ず initSdk より前に呼ぶ
      appsflyerSdk.setOneLinkCustomDomain([
        // SecretsManager.getAfCustomDomain(), // 例: stockr-app.bldt.jp
        SecretsManager.getAfOneLinkDomain(), // 例: stockr.onelink.me
      ]);

      // DeepLink リスナーはこのあとでOK
      appsflyerSdk.onDeepLinking(_onDeepLink);

      // SDK 初期化 → 起動
      await appsflyerSdk.initSdk(registerOnDeepLinkingCallback: true);
      print('こここ');
      appsflyerSdk.startSDK(
        onSuccess: () => print('AF SDK start success'),
        onError: (code, msg) => print('[AF] SDK error $code: $msg'),
      );
    } catch (e) {}
  }

  Future<void> _onDeepLink(DeepLinkResult result) async {
    print('ここここ');
    if (result.status != Status.FOUND || result.deepLink == null) {
      return;
    }

    final dl = result.deepLink!;
    final email = dl.getStringValue('af_sub1');
    final linkS = dl.getStringValue('af_sub2');
    if (email == null || linkS == null) {
      return;
    }

    // ★ 一度/二度の URL エンコードに耐えるように頑健にデコードする
    String decoded = linkS;
    try {
      decoded = Uri.decodeFull(decoded);
      // まだ % が多く残る/ isSignInWithEmailLink が弾くときはもう一度
      if (decoded.contains('%3A') || decoded.contains('%2F') || decoded.contains('%3F')) {
        decoded = Uri.decodeFull(decoded);
      }
    } catch (_) {
      print('[AF] DeepLink decode error: $linkS');
    }

    final uri = Uri.parse(decoded);
    _deepLinkController.add(DeepLinkData(email: email, link: uri));
    print('[AF] DeepLink received: $email, $uri');
  }

  void dispose() {
    _deepLinkController.close();
  }

  /// UserId（Customer User ID）登録
  Future<void> setUserId({required String userId}) async {
    appsflyerSdk.setCustomerUserId(userId);
  }

  ///AppsFlyerUserId取得
  Future<String?> getUserId() async {
    final userId = await UserRepository().getUserUid();
    return userId;
  }

  ///AppsFlyerUserId取得
  Future<String?> getAfUserId() async {
    final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
    return appsFlyerUserId;
  }

  ///Email登録
  Future<void> setUserEmails({required String email}) async {
    appsflyerSdk.setUserEmails([email]);
  }

  // ///初回起動時
  // Future<void> sendFirstOpen() async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.first_open,
  //     parameterMap: <String, dynamic>{'userId': userId, 'appsFlyerUserId': appsFlyerUserId},
  //   );
  // }

  // ///アカウント作成
  // Future<void> sendCreateAccount() async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.create_account,
  //     parameterMap: <String, dynamic>{'userId': userId, 'appsFlyerUserId': appsFlyerUserId},
  //   );
  // }

  // ///メールアドレス登録
  // Future<void> sendSignUp() async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.sign_up,
  //     parameterMap: <String, dynamic>{'userId': userId, 'appsFlyerUserId': appsFlyerUserId},
  //   );
  // }

  // ///ログイン
  // Future<void> sendSignIn({required String email}) async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.sign_up,
  //     parameterMap: <String, dynamic>{
  //       'userId': userId,
  //       'appsFlyerUserId': appsFlyerUserId,
  //       'email': email,
  //     },
  //   );
  // }

  // ///チュートリアル完了
  // Future<void> sendTutorialDoneEvent({required String status}) async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.tutorial_done,
  //     parameterMap: <String, dynamic>{
  //       'userId': userId,
  //       'appsFlyerUserId': appsFlyerUserId,
  //       'status': status,
  //     },
  //   );
  // }

  // ///初回ストック完了
  // Future<void> sendFirstPost({required String text}) async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.first_post,
  //     parameterMap: <String, dynamic>{
  //       'userId': userId,
  //       'appsFlyerUserId': appsFlyerUserId,
  //       'text': text,
  //     },
  //   );
  // }

  // ///初回再発見完了
  // Future<void> sendFirstLookBack() async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.first_lookback,
  //     parameterMap: <String, dynamic>{'userId': userId, 'appsFlyerUserId': appsFlyerUserId},
  //   );
  // }

  // ///アプリ内課金
  // Future<void> sendInAppPurchaseEvent({required String itemId}) async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();

  //   await sendEvent(
  //     event: itemId == 'ticket_120'
  //         ? AppsFlyerEvent.purchase_ticket_120
  //         : itemId == 'ticket_490'
  //         ? AppsFlyerEvent.purchase_ticket_490
  //         : itemId == 'ticket_1080'
  //         ? AppsFlyerEvent.purchase_ticket_1080
  //         : AppsFlyerEvent.unKnown,
  //     parameterMap: <String, dynamic>{
  //       'userId': userId,
  //       'appsFlyerUserId': appsFlyerUserId,
  //       'itemId': itemId,
  //     },
  //   );
  // }

  // ///プレミアム更新
  // Future<void> sendSubscriptionEvent({required String itemId}) async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();

  //   AppsFlyerEvent event;

  //   if (itemId == 'premium_subscription_1m') {
  //     event = AppsFlyerEvent.subscription_1m;
  //   } else if (itemId == 'premium_subscription_3m') {
  //     event = AppsFlyerEvent.subscription_3m;
  //   } else if (itemId == 'premium_subscription_1y') {
  //     event = AppsFlyerEvent.subscription_1y;
  //   } else if (itemId == 'monthlysubscription') {
  //     event = AppsFlyerEvent.subscription_monthly;
  //   } else if (itemId == 'yearlysubscription') {
  //     event = AppsFlyerEvent.subscription_yearly;
  //   } else {
  //     event = AppsFlyerEvent.unKnown;
  //   }

  //   await sendEvent(
  //     event: event,
  //     parameterMap: <String, dynamic>{
  //       'userId': userId,
  //       'appsFlyerUserId': appsFlyerUserId,
  //       'itemId': itemId,
  //     },
  //   );
  // }

  // ///プレミアムキャンセル
  // Future<void> sendSubscriptionCancelEvent() async {
  //   final userId = await UserRepository().getUserUid();
  //   final appsFlyerUserId = await appsflyerSdk.getAppsFlyerUID();
  //   await sendEvent(
  //     event: AppsFlyerEvent.subscription_cancel,
  //     parameterMap: <String, dynamic>{'userId': userId, 'appsFlyerUserId': appsFlyerUserId},
  //   );
  // }

  // /// イベントを送信
  // /// [event] AppsFlyerEvent
  // /// [parameterMap] parameter Map
  // Future<void> sendEvent({
  //   required AppsFlyerEvent event,
  //   required Map<String, dynamic> parameterMap,
  // }) async {
  //   try {
  //     final eventName = event.toString().split('.')[1];
  //     await appsflyerSdk.logEvent(eventName, parameterMap);
  //   } on Exception catch (e, s) {}
  // }
}

/// 認証結果を表すクラス
class DeepLinkData {
  final String email;
  final Uri link;
  DeepLinkData({required this.email, required this.link});
}
