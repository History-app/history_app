import 'package:flutter/material.dart';
import 'package:japanese_history_app/View/bottom_nav_view.dart';
import 'package:japanese_history_app/util/animations/page_transitions_theme.dart';
import 'package:japanese_history_app/view/widgets/over_lay_loading.dart';
import 'package:japanese_history_app/view/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'package:japanese_history_app/view/account_delete/account_delete_screen.dart';

import 'package:japanese_history_app/view/screens/email_account_screen/email_account_screen.dart';

class NavigationService {
  // NavigatorKey と内部ヘルパ
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get _context => navigatorKey.currentContext!;
  static NavigatorState get _nav => navigatorKey.currentState!;

  static String? _currentModalKey;
  static bool isModalSheetOpen([String? key]) =>
      _currentModalKey != null && (key == null || _currentModalKey == key);

  // 画面遷移の種類
  static Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      _nav.pushNamed<T>(routeName, arguments: arguments);

  static Future<T?> push<T extends Object?>(Route<T> route) => _nav.push<T>(route);

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => _nav.pushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) => _nav.pushNamedAndRemoveUntil<T>(newRouteName, predicate, arguments: arguments);

  static void pop<T extends Object?>([T? result]) => _nav.pop<T>(result);

  static void popUntil(RoutePredicate predicate) => _nav.popUntil(predicate);

  static Future<bool> showModal(
    String modalKey, {
    Object? arguments,
    bool barrierDismissible = true,
  }) async {
    final factory = _modalRoutes[modalKey];
    if (factory == null) {
      assert(false, 'Unknown modal: $modalKey');
      return false;
    }

    final modalName = _analyticsName(modalKey);
    // GaAnalyticsService().sendModalEvent(modalName: modalName);

    final result = await showDialog<bool>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => factory(ctx, arguments),
    );
    return result ?? false;
  }

  static Future<T?> showModalSheet<T>(
    String modalKey, {
    Object? arguments,
    bool isScrollControlled = true,
    Color? backgroundColor = Colors.white,
  }) async {
    final factory = _modalRoutes[modalKey];
    if (factory == null) {
      assert(false, 'Unknown bottom sheet: $modalKey');
      return null;
    }

    final modalName = _analyticsName(modalKey);
    // GaAnalyticsService().sendModalEvent(modalName: modalName);
    _currentModalKey = modalKey;
    try {
      return await showModalBottomSheet<T>(
        isScrollControlled: isScrollControlled,
        context: _context,
        backgroundColor: backgroundColor,
        builder: (ctx) => factory(ctx, arguments),
      );
    } finally {
      // 閉じたら必ずクリア
      _currentModalKey = null;
    }
  }

  static Future<bool> closeModalSheetIfOpen({String? modalKey}) async {
    if (isModalSheetOpen(modalKey)) {
      _nav.pop();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return true;
    }
    return false;
  }

  static String _analyticsName(String key) => key.replaceFirst(RegExp(r'^/+'), '');
}

///画面遷移のルートキー
abstract class ScreenRoutes {
  static const launch = '/LaunchScreen';
  static const login = '/LoginScreen';
  static const emailAccount = '/EmailAccountScreen';
  static const main = '/MainScreen';
  static const announcementDetail = '/AnnouncementDetailScreen';
  static const about = '/AboutScreen';
  static const company = '/CompanyScreen';
  static const purchasePremium = '/PurchasePremiumScreen';
  static const purchaseTicket = '/PurchaseTicketScreen';
  static const contact = '/ContactScreen';
  static const userInfo = '/UserInfoScreen';
  static const accountDelete = '/AccountDeleteScreen';
  static const skin = '/SkinScreen';
  static const notification = '/NotificationScreen';
  static const stockTheme = '/StockThemeScreen';
  static const badge = '/BadgeScreen';
  static const biz = '/BizScreen';
  static const bizLogin = '/BizLoginScreen';
  static const stockFull = '/StockFullScreen';
  static const dashboardPremiumDetail = '/DashboardPremiumDetailScreen';
  static const dashboardScoreDetail = '/DashboardScoreDetailScreen';
  static const dashboardTicketDetail = '/DashboardTicketDetailScreen';
  static const succeededSignUp = '/SucceededSignUpScreen';
  static const succeededSignIn = '/SucceededSignInScreen';
  static const announcementWeb = '/AnnouncementWebScreen';
  static const vision = '/VisionScreen';
  static const coaching = '/CoachingScreen';
  static const stockCoaching = '/StockCoachingScreen';
  static const chatLog = '/ChatLogScreen';
  static const visionChatLog = '/VisionChatLogScreen';
  static const tutorialVisionCoaching = '/TutorialVisionCoachingScreen';
  static const tutorial = '/TutorialScreen';
}

final _screenRoutes = <String, Route<dynamic> Function(RouteSettings)>{
  // ScreenRoutes.launch: (s) => _fade(const LaunchScreen(), s),
  // ScreenRoutes.login: (s) => _fade(LoginScreen(), s),
  ScreenRoutes.emailAccount: (s) => _zoom(const EmailAccountScreen()),
  ScreenRoutes.main: (s) => _fade(const BottomNavView(), s),
  // ScreenRoutes.announcementDetail: (s) =>
  //     _left(AnnouncementDetailScreen(selectedAnnouncement: s.arguments as Announcement)),
  // ScreenRoutes.stockFull: (s) => _bottom(const StockFullScreen()),
  // ScreenRoutes.announcementWeb: (s) => _bottom(const AnnouncementMediaScreen()),
  // ScreenRoutes.about: (s) => _zoom(const AboutScreen()),
  // ScreenRoutes.company: (s) => _zoom(const CompanyScreen()),
  // ScreenRoutes.purchasePremium: (s) => _zoom(const PurchasePremiumScreen()),
  // ScreenRoutes.purchaseTicket: (s) => _zoom(const PurchaseTicketScreen()),
  // ScreenRoutes.contact: (s) => _zoom(const ContactScreen()),
  // ScreenRoutes.userInfo: (s) => _zoom(UserInfoScreen()),
  ScreenRoutes.accountDelete: (s) => _zoom(const AccountDeleteScreen()),
  // ScreenRoutes.skin: (s) => _zoom(SkinScreen()),
  // ScreenRoutes.notification: (s) => _zoom(const NotificationScreen()),
  // ScreenRoutes.stockTheme: (s) => _fade(StockThemeScreen(), s),
  // ScreenRoutes.badge: (s) => _fade(BadgeScreen(), s),
  // ScreenRoutes.biz: (s) => _fade(const BizScreen(), s),
  // ScreenRoutes.bizLogin: (s) => _fade(BizLoginScreen(), s),
  // ScreenRoutes.dashboardPremiumDetail: (s) => _fade(const DashboardPremiumDetailScreen(), s),
  // ScreenRoutes.dashboardScoreDetail: (s) => _fade(const DashboardScoreDetailScreen(), s),
  // ScreenRoutes.dashboardTicketDetail: (s) => _fade(const DashboardTicketDetailScreen(), s),
  // ScreenRoutes.succeededSignUp: (s) => _fade(const SucceededSignUpScreen(), s),
  // ScreenRoutes.succeededSignIn: (s) => _fade(const SucceededSignInScreen(), s),
  // ScreenRoutes.vision: (s) => _fade(const VisionScreen(), s),
  // ScreenRoutes.coaching: (s) => _fade(const VisionCoachingScreen(), s),
  // ScreenRoutes.stockCoaching: (s) => _fade(const StockCoachingScreen(), s),
  // ScreenRoutes.chatLog: (s) => _fade(const ChatLogScreen(), s),
  // ScreenRoutes.visionChatLog: (s) => _fade(const VisionChatLogScreen(), s),
  // ScreenRoutes.tutorialVisionCoaching: (s) => _fade(const TutorialVisionCoachingScreen(), s),
  // ScreenRoutes.tutorial: (s) => _fade(const TutorialScreen(), s),
};

abstract class ModalRoutes {
  static const loading = '/OverLayLoadingModal';
  static const cancelPremium = '/CancelPremiumModal';
  static const succeededPurchasePremium = '/SucceededPurchasePremiumModal';
  static const succeededPurchaseTickets = '/SucceededPurchaseTicketModal';
  static const failedPurchase = '/FailedPurchaseModal';
  static const updatePremiumPlan = '/UpdatePremiumPlanModalSheet';
  static const selectStocksMenu = '/SelectStocksMenuModal';
  static const requestNotification = '/requestNotificationModal';
  static const notificationSetting = '/NotificationSettingModal';
  static const notificationRecommendTutorial = '/NotificationRecommendTutorialModal';
  static const flaseAuthEmailModal = '/FlaseAuthEmailModal';
  static const flaseAuthEmailTutorialModal = '/FlaseAuthEmailTutorialModal';
  static const notificationRecommend = '/NotificationRecommendModal';
}

final _modalRoutes = <String, ModalFactory>{
  ModalRoutes.loading: (_, __) => const OverLayLoadingModal(),
  // ModalRoutes.cancelPremium: (_, __) => const CancelPremiumModal(),
  // ModalRoutes.succeededPurchasePremium: (_, __) => const SucceededPurchasePremiumModal(),
  // ModalRoutes.succeededPurchaseTickets: (_, __) => const SucceededPurchaseTicketModal(),
  // ModalRoutes.failedPurchase: (_, __) => const FailedPurchaseModal(),
  // ModalRoutes.updatePremiumPlan: (_, __) => const UpdatePremiumPlanModalSheet(),
  // ModalRoutes.selectStocksMenu: (_, __) => const SelectStocksMenuModal(),
  // ModalRoutes.requestNotification: (_, __) => const RequestNotificationModal(),
  // ModalRoutes.notificationSetting: (_, __) => const NotificationSettingModal(),
  // ModalRoutes.notificationRecommendTutorial: (_, __) => const NotificationRecommendTutorialModal(),
  // ModalRoutes.flaseAuthEmailModal: (_, __) => const FlaseAuthEmailModal(),
  // ModalRoutes.flaseAuthEmailTutorialModal: (_, __) => const FlaseAuthEmailTutorialModal(),
  // ModalRoutes.notificationRecommend: (_, __) => const NotificationRecommendModal(),
};

// 画面遷移アニメーション
class PageRouter {
  static Route<dynamic>? generate(RouteSettings settings) {
    final builder = _screenRoutes[settings.name];
    if (builder == null) {
      return null;
    }

    // '/ScreenName' → 'ScreenName'
    final screenName = settings.name!.replaceFirst('/', '');
    // GaAnalyticsService().setScreenEvent(screenName: screenName);

    return builder(settings);
  }
}

typedef ModalFactory = Widget Function(BuildContext context, Object? args);

Route<T> _fade<T>(Widget c, RouteSettings s) =>
    PageTransition(type: PageTransitionType.fade, child: c, settings: s);
PageRoute _zoom(Widget c) => PageTransitionZoom(child: c);
PageRoute _left(Widget c) => PageTransitionLeftToRight(child: c);
PageRoute _bottom(Widget c) => PageTransitionBottomToTop(child: c);

class PageTransitionBottomToTop extends PageRouteBuilder<Widget> {
  PageTransitionBottomToTop({required Widget child})
    : super(
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(a),
          child: c,
        ),
        barrierColor: Colors.black.withValues(alpha: 0.25),
        opaque: false,
      );
}

class PageTransitionLeftToRight extends PageRouteBuilder<Widget> {
  PageTransitionLeftToRight({required Widget child})
    : super(
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(a),
          child: c,
        ),
      );
}

class PageTransitionRightToLeft extends PageRouteBuilder<Widget> {
  PageTransitionRightToLeft({required Widget child})
    : super(
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, a, __, c) => SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: Offset.zero).animate(a),
          child: c,
        ),
      );
}

class PageTransitionZoom extends PageRouteBuilder<Widget> {
  PageTransitionZoom({required Widget child})
    : super(
        pageBuilder: (_, __, ___) => child,
        transitionsBuilder: (_, a, sa, c) =>
            ZoomPageTransition(animation: a, secondaryAnimation: sa, child: c),
      );
}
