import 'package:flutter_dotenv/flutter_dotenv.dart';

///.envで管理
class SecretsManager {
  static String get contactAppUrl => dotenv.env['CONTACT_APP_URL'] ?? '';

  static String get slackWebhookURI => dotenv.env['SLACK_WEBHOOK_URI'] ?? '';

  static String get iosStoreURL => dotenv.env['IOS_STORE_URL'] ?? '';

  static String get androidStoreURL => dotenv.env['ANDROID_STORE_URL'] ?? '';

  static String getAppId(String packageName) {
    return dotenv.env['APP_ID_$packageName'] ?? '';
  }

  static String getOldPremiumSubscription1mItem(String packageName) {
    return dotenv.env['MONTHLY_SUBSCRIPTION_$packageName'] ?? '';
  }

  static String getOldPremiumSubscription1yItem(String packageName) {
    return dotenv.env['YEARLY_SUBSCRIPTION_$packageName'] ?? '';
  }

  static String getPremiumSubscription1mItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_1M_$packageName'] ?? '';
  }

  static String getPremiumSubscription3mItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_3M_$packageName'] ?? '';
  }

  static String getPremiumSubscription1yItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_1Y_$packageName'] ?? '';
  }

  static String getPremiumSubscriptionPlus1mItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_PLUS_1M_$packageName'] ?? '';
  }

  static String getPremiumSubscriptionPlus3mItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_PLUS_3M_$packageName'] ?? '';
  }

  static String getPremiumSubscriptionPlus1yItem(String packageName) {
    return dotenv.env['PREMIUM_SUBSCRIPTION_PLUS_1Y_$packageName'] ?? '';
  }

  static String getInAppPurchaseTicket120(String packageName) {
    return dotenv.env['INAPP_PURCHASE_TICKET_120_$packageName'] ?? '';
  }

  static String getInAppPurchaseTicket490(String packageName) {
    return dotenv.env['INAPP_PURCHASE_TICKET_490_$packageName'] ?? '';
  }

  static String getInAppPurchaseTicket1080(String packageName) {
    return dotenv.env['INAPP_PURCHASE_TICKET_1080_$packageName'] ?? '';
  }

  static String getDynamicLinkDomain(String packageName) {
    return dotenv.env['DYNAMIC_LINK_DOMAIN_$packageName'] ?? '';
  }

  static String getAfDevKey() {
    return dotenv.env['AF_DEV_KEY'] ?? '';
  }

  static String getAfCustomDomain() {
    return dotenv.env['AF_CUSTOM_DOMAIN'] ?? '';
  }

  static String getAfOneLinkDomain() {
    return dotenv.env['AF_ONE_LINK_DOMAIN'] ?? '';
  }

  static String getAfOneLinkUrlId(String packageName) {
    return dotenv.env['AF_ONE_LINK_URL_ID_$packageName'] ?? '';
  }
}
