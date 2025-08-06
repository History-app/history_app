import 'package:flutter_riverpod/flutter_riverpod.dart'; // UserProvider をインポート
import '../../repositories/user_repository.dart';
import '../../Model/user/user.dart';
import '../../providers/user_provider.dart';

final settingsNotifierProvider =
    StateNotifierProvider<SettingsStateNotifier, User>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return SettingsStateNotifier(userRepository, ref);
});

class SettingsStateNotifier extends StateNotifier<User> {
  final UserRepository userRepository;
  final Ref ref;
  SettingsStateNotifier(this.userRepository, this.ref)
      : super(User(uid: '', nullCount: 5)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await ref.read(userProvider.future);
      state = user;
    } catch (e) {}
  }

  Future<void> updateNullCount(count) async {
    try {
      await userRepository.setNullCount(count);
      state = state.copyWith(nullCount: count);
    } catch (error) {}
  }
}
