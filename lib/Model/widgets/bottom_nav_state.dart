import 'package:freezed_annotation/freezed_annotation.dart';
part 'bottom_nav_state.freezed.dart';

@freezed
class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    required int selectedIndex,
  }) = _BottomNavState;
}