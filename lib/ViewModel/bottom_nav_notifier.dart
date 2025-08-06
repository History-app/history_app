import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/widgets/bottom_nav_state.dart';

class BottomNavNotifier extends StateNotifier<BottomNavState> {
  BottomNavNotifier() : super(const BottomNavState(selectedIndex: 0));
  void updateIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

final bottomNavProvider =
    StateNotifierProvider<BottomNavNotifier, BottomNavState>((ref) {
  return BottomNavNotifier();
});
