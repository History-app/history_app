import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class ConfigRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  ConfigRepository() {
    initState();
  }

  void initState() {}

  Future<bool> versionCheck() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(info.version);

      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('hPYRQlZmrx8WWejONhcy')
          .get();
      final newVersion =
          Version.parse(doc.data()!['ios_force_app_version'] as String);

      return currentVersion < newVersion;
    } catch (e) {
      return false;
    }
  }
}

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepository();
});
